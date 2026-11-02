import 'dart:math';
import 'package:clock/clock.dart';
import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';
import 'package:rekindle_core/src/bandit/beta_sampler.dart';
import 'package:rekindle_core/src/bandit/interest_selector.dart';
import 'package:rekindle_core/src/data/database.dart';
import 'package:rekindle_core/src/domain/enums.dart';
import 'package:rekindle_core/src/domain/models.dart';
import 'package:rekindle_core/src/services/onboarding_service.dart';
import 'package:rekindle_core/src/services/response_service.dart';
import 'package:rekindle_core/src/services/surface_service.dart';

void main() {
  late AppDatabase db;
  late ThompsonInterestSelector selector;
  const uuid = Uuid();

  setUp(() {
    db = AppDatabase(
      NativeDatabase.memory(
        setup: (rawDb) => rawDb.execute('PRAGMA foreign_keys = ON;'),
      ),
    );
    selector = ThompsonInterestSelector(BetaSampler(Random(42)));
  });

  tearDown(() async {
    await db.close();
  });

  group('AT1 & OnboardingService Tests', () {
    test('onboarding creates settings, interests, snippets and is idempotent', () async {
      final onboarding = OnboardingService(db: db);

      const draft = OnboardingDraft(
        selectedInterests: ['Space Exploration', 'Ancient Rome', 'Gardening'],
        memories: {
          'Space Exploration': 'The James Webb Space Telescope opened a new window into the early universe.',
          'Ancient Rome': 'The Roman aqueducts used gravity alone to transport water across vast distances.',
        },
        level: NotificationLevel.gentle,
        windows: {DeliveryWindow.morning, DeliveryWindow.evening},
      );

      final firstRun = await onboarding.complete(draft);
      expect(firstRun, isTrue);

      // Verify interests created
      final interests = await db.select(db.interestsTable).get();
      expect(interests.length, equals(3));

      // Verify snippets created
      final snippets = await db.select(db.snippetsTable).get();
      expect(snippets.length, equals(2));

      // Verify settings created
      final settings = await db.select(db.notificationSettingsTable).getSingle();
      expect(settings.level, equals('GENTLE'));

      // Second run must be idempotent
      final secondRun = await onboarding.complete(draft);
      expect(secondRun, isFalse);
    });
  });

  group('AT2 & AT3: SurfaceService Tests', () {
    test('AT2: Surface never returns an interest that has no snippets', () async {
      final onboarding = OnboardingService(db: db);
      const draft = OnboardingDraft(
        selectedInterests: ['Empty Interest', 'Filled Interest'],
        memories: {
          'Filled Interest': 'This interest has a thought attached.',
        },
      );
      await onboarding.complete(draft);

      final surfaceService = SurfaceService(db: db, selector: selector);
      final item = await surfaceService.next();

      expect(item, isNotNull);
      expect(item!.interest.name, equals('Filled Interest'));
      expect(item.snippet.content, contains('has a thought attached'));
    });

    test('AT3: Recency suppression excludes recently surfaced snippet when alternatives exist', () async {
      final fixedNow = DateTime.utc(2026, 11, 2, 12, 0, 0);

      await withClock(Clock.fixed(fixedNow), () async {
        final interestId = uuid.v4();
        await db.into(db.interestsTable).insert(
              InterestsTableCompanion.insert(
                id: interestId,
                name: 'Astronomy',
                nameKey: 'astronomy',
                createdAt: fixedNow,
              ),
            );

        final snippet1Id = uuid.v4();
        final snippet2Id = uuid.v4();

        await db.into(db.snippetsTable).insert(
              SnippetsTableCompanion.insert(
                id: snippet1Id,
                interestId: interestId,
                content: 'Snippet 1: Mars rovers.',
                source: 'MANUAL',
                createdAt: fixedNow,
                updatedAt: fixedNow,
              ),
            );

        await db.into(db.snippetsTable).insert(
              SnippetsTableCompanion.insert(
                id: snippet2Id,
                interestId: interestId,
                content: 'Snippet 2: Andromeda galaxy.',
                source: 'MANUAL',
                createdAt: fixedNow,
                updatedAt: fixedNow,
              ),
            );

        // Surface snippet 1 now
        final surfaceService = SurfaceService(
          db: db,
          selector: selector,
          clock: Clock.fixed(fixedNow),
        );
        final item1 = await surfaceService.next(interestId: interestId);
        expect(item1, isNotNull);

        // The very next surface 1 hour later must suppress the snippet that was just shown
        final oneHourLater = fixedNow.add(const Duration(hours: 1));
        final nextSurfaceService = SurfaceService(
          db: db,
          selector: selector,
          clock: Clock.fixed(oneHourLater),
        );

        final item2 = await nextSurfaceService.next(interestId: interestId);
        expect(item2, isNotNull);
        expect(item2!.snippet.id, isNot(equals(item1!.snippet.id)));
      });
    });
  });

  group('AT4: ResponseService Exactly-Once Tests', () {
    test('submitting same response twice applies one reward and returns applied=false second time', () async {
      final now = DateTime.utc(2026, 11, 2, 12, 0, 0);

      final interestId = uuid.v4();
      await db.into(db.interestsTable).insert(
            InterestsTableCompanion.insert(
              id: interestId,
              name: 'Robotics',
              nameKey: 'robotics',
              alpha: const Value(1.0),
              beta: const Value(1.0),
              createdAt: now,
            ),
          );

      final exposureId = uuid.v4();
      await db.into(db.exposuresTable).insert(
            ExposuresTableCompanion.insert(
              id: exposureId,
              interestId: interestId,
              kind: 'SNIPPET',
              templateCode: 'IN_APP',
              copyVariant: 'STANDARD',
              voice: 'CALM',
              channel: 'IN_APP',
              surfacedAt: now,
            ),
          );

      // Create settings row
      await db.into(db.notificationSettingsTable).insert(
            const NotificationSettingsTableCompanion(
              id: Value(1),
              consecutiveIgnored: Value(2),
              backoffStep: Value(1),
            ),
          );

      final responseService = ResponseService(db: db, clock: Clock.fixed(now));

      final realCmd = ResponseCommand(
        exposureId: exposureId,
        reaction: Reaction.keep,
        via: RespondedVia.inApp,
      );

      // First call: succeeds
      final res1 = await responseService.apply(realCmd);
      expect(res1.applied, isTrue);
      expect(res1.reaction, equals(Reaction.keep));

      // Verify interest alpha incremented (+1)
      var interest = await (db.select(db.interestsTable)..where((tbl) => tbl.id.equals(interestId))).getSingle();
      expect(interest.alpha, equals(2.0));
      expect(interest.beta, equals(1.0));

      // Verify settings backoff counters reset
      final settings = await (db.select(db.notificationSettingsTable)..where((tbl) => tbl.id.equals(1))).getSingle();
      expect(settings.consecutiveIgnored, equals(0));
      expect(settings.backoffStep, equals(0));

      // Second call (duplicate / double-tap): must return applied=false
      final res2 = await responseService.apply(realCmd);
      expect(res2.applied, isFalse);
      expect(res2.reaction, equals(Reaction.keep));

      // Verify alpha was NOT incremented again
      interest = await (db.select(db.interestsTable)..where((tbl) => tbl.id.equals(interestId))).getSingle();
      expect(interest.alpha, equals(2.0));
    });

    test('inline reply creates new snippet with source NOTIFICATION_REPLY', () async {
      final now = DateTime.utc(2026, 11, 2, 12, 0, 0);

      final interestId = uuid.v4();
      await db.into(db.interestsTable).insert(
            InterestsTableCompanion.insert(
              id: interestId,
              name: 'Architecture',
              nameKey: 'architecture',
              createdAt: now,
            ),
          );

      final exposureId = uuid.v4();
      await db.into(db.exposuresTable).insert(
            ExposuresTableCompanion.insert(
              id: exposureId,
              interestId: interestId,
              kind: 'CAPTURE_PROMPT',
              templateCode: 'T5_JOT_IT_DOWN',
              copyVariant: 'CALM',
              voice: 'CALM',
              channel: 'PUSH',
              surfacedAt: now,
            ),
          );

      await db.into(db.notificationSettingsTable).insert(
            const NotificationSettingsTableCompanion(id: Value(1)),
          );

      final responseService = ResponseService(db: db, clock: Clock.fixed(now));
      final res = await responseService.apply(
        ResponseCommand(
          exposureId: exposureId,
          reaction: Reaction.captured,
          via: RespondedVia.notificationAction,
          text: 'Flying buttresses allowed Gothic cathedrals to have much higher ceilings.',
        ),
      );

      expect(res.applied, isTrue);

      final snippets = await (db.select(db.snippetsTable)..where((tbl) => tbl.interestId.equals(interestId))).get();
      expect(snippets.length, equals(1));
      expect(snippets.first.source, equals('NOTIFICATION_REPLY'));
      expect(snippets.first.content, contains('Flying buttresses'));
    });
  });
}
