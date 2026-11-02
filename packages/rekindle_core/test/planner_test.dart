import 'dart:math';
import 'package:clock/clock.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';
import 'package:rekindle_core/src/bandit/beta_sampler.dart';
import 'package:rekindle_core/src/bandit/interest_selector.dart';
import 'package:rekindle_core/src/data/database.dart';
import 'package:rekindle_core/src/planner/nudge_planner.dart';

class FakeNotificationGateway implements NotificationGateway {
  final scheduled = <int, Map<String, dynamic>>{};
  final cancelled = <int>[];

  @override
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    required String payload,
    required List<NotificationActionInfo> actions,
  }) async {
    scheduled[id] = {
      'title': title,
      'body': body,
      'date': scheduledDate,
      'payload': payload,
      'actions': actions,
    };
  }

  @override
  Future<void> cancelNotification(int id) async {
    cancelled.add(id);
    scheduled.remove(id);
  }

  @override
  Future<void> cancelAll() async {
    cancelled.addAll(scheduled.keys);
    scheduled.clear();
  }
}

void main() {
  late AppDatabase db;
  late ThompsonInterestSelector selector;
  late FakeNotificationGateway gateway;
  const uuid = Uuid();
  final fixedNow = DateTime.utc(2026, 11, 2, 10, 0, 0);

  setUp(() {
    db = AppDatabase(
      NativeDatabase.memory(
        setup: (rawDb) => rawDb.execute('PRAGMA foreign_keys = ON;'),
      ),
    );
    selector = ThompsonInterestSelector(BetaSampler(Random(42)));
    gateway = FakeNotificationGateway();
  });

  tearDown(() async {
    await db.close();
  });

  group('NudgePlanner Tests', () {
    test('does not schedule when permission is DENIED or level is OFF', () async {
      await db.into(db.appStates).insert(
            AppStatesCompanion.insert(
              installSeed: 1234,
              timezone: 'UTC',
              notificationPermission: const Value('DENIED'),
              onboardingCompletedAt: Value(fixedNow),
              createdAt: fixedNow,
            ),
          );

      await db.into(db.notificationSettingsTable).insert(
            const NotificationSettingsTableCompanion(
              id: Value(1),
              level: Value('GENTLE'),
            ),
          );

      final planner = NudgePlanner(
        db: db,
        selector: selector,
        gateway: gateway,
        clock: Clock.fixed(fixedNow),
      );

      final result = await planner.replan(fixedNow);
      expect(result.isEmpty, isTrue);
      expect(gateway.scheduled.isEmpty, isTrue);
    });

    test('plans nudges respecting delivery governor and calls gateway', () async {
      await db.into(db.appStates).insert(
            AppStatesCompanion.insert(
              installSeed: 1234,
              timezone: 'UTC',
              notificationPermission: const Value('GRANTED'),
              onboardingCompletedAt: Value(fixedNow),
              lastSeenAt: Value(fixedNow.subtract(const Duration(hours: 4))), // seen 4h ago
              createdAt: fixedNow,
            ),
          );

      await db.into(db.notificationSettingsTable).insert(
            const NotificationSettingsTableCompanion(
              id: Value(1),
              level: Value('GENTLE'),
            ),
          );

      final interestId = uuid.v4();
      await db.into(db.interestsTable).insert(
            InterestsTableCompanion.insert(
              id: interestId,
              name: 'Architecture',
              nameKey: 'architecture',
              createdAt: fixedNow,
            ),
          );

      await db.into(db.snippetsTable).insert(
            SnippetsTableCompanion.insert(
              id: uuid.v4(),
              interestId: interestId,
              content: 'Gothic architecture introduced flying buttresses and ribbed vaults.',
              source: 'MANUAL',
              createdAt: fixedNow,
              updatedAt: fixedNow,
            ),
          );

      final planner = NudgePlanner(
        db: db,
        selector: selector,
        gateway: gateway,
        clock: Clock.fixed(fixedNow),
      );

      final nudges = await planner.replan(fixedNow);
      expect(nudges.isNotEmpty, isTrue);
      expect(gateway.scheduled.length, equals(nudges.length));

      final firstNudge = nudges.first;
      expect(firstNudge.templateCode, equals('T1_SPARK'));
      expect(firstNudge.title, contains('Architecture'));
      expect(firstNudge.actions.length, equals(3));
      expect(firstNudge.actions.map((a) => a.id), containsAll(['keep', 'skip', 'more']));
    });

    test('schedules T5 Jot It Down when interest has no snippets', () async {
      await db.into(db.appStates).insert(
            AppStatesCompanion.insert(
              installSeed: 5678,
              timezone: 'UTC',
              notificationPermission: const Value('GRANTED'),
              onboardingCompletedAt: Value(fixedNow),
              createdAt: fixedNow,
            ),
          );

      await db.into(db.notificationSettingsTable).insert(
            const NotificationSettingsTableCompanion(
              id: Value(1),
              level: Value('GENTLE'),
            ),
          );

      final interestId = uuid.v4();
      await db.into(db.interestsTable).insert(
            InterestsTableCompanion.insert(
              id: interestId,
              name: 'Neuroscience',
              nameKey: 'neuroscience',
              createdAt: fixedNow,
            ),
          );

      final planner = NudgePlanner(
        db: db,
        selector: selector,
        gateway: gateway,
        clock: Clock.fixed(fixedNow),
      );

      final nudges = await planner.replan(fixedNow);
      expect(nudges.isNotEmpty, isTrue);

      final firstNudge = nudges.first;
      expect(firstNudge.templateCode, equals('T5_JOT_IT_DOWN'));
      expect(firstNudge.title, contains('Neuroscience'));
      expect(firstNudge.actions.first.hasTextInput, isTrue);
    });
  });
}
