import 'package:clock/clock.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../data/database.dart';
import '../domain/enums.dart';
import '../domain/models.dart';

final class OnboardingService {
  OnboardingService({
    required this.db,
    this.clock = const Clock(),
    this.uuid = const Uuid(),
  });

  final AppDatabase db;
  final Clock clock;
  final Uuid uuid;

  int _calculateWindowsBitmask(Set<DeliveryWindow> windows) {
    var mask = 0;
    if (windows.contains(DeliveryWindow.morning)) mask |= 1;
    if (windows.contains(DeliveryWindow.afternoon)) mask |= 2;
    if (windows.contains(DeliveryWindow.evening)) mask |= 4;
    return mask == 0 ? 5 : mask; // default morning + evening if empty
  }

  /// Completes onboarding in a single atomic transaction.
  /// Idempotent: returns false without writing if already completed.
  Future<bool> complete(OnboardingDraft draft, {String timezone = 'UTC'}) async {
    final now = clock.now().toUtc();

    return db.transaction(() async {
      // 1. Check if already completed
      final existingState = await (db.select(db.appStates)..where((tbl) => tbl.id.equals(1))).getSingleOrNull();
      if (existingState != null && existingState.onboardingCompletedAt != null) {
        return false;
      }

      final seed = existingState?.installSeed ?? now.millisecondsSinceEpoch;

      // 2. Upsert AppState
      await db.into(db.appStates).insertOnConflictUpdate(
            AppStatesCompanion(
              id: const Value(1),
              installSeed: Value(seed),
              timezone: Value(timezone),
              onboardingCompletedAt: Value(now),
              createdAt: Value(existingState?.createdAt ?? now),
            ),
          );

      // 3. Upsert NotificationSettings
      final windowsMask = _calculateWindowsBitmask(draft.windows);
      await db.into(db.notificationSettingsTable).insertOnConflictUpdate(
            NotificationSettingsTableCompanion(
              id: const Value(1),
              level: Value(draft.level.name.toUpperCase()),
              windows: Value(windowsMask),
              voice: Value(draft.voice.name.toUpperCase()),
              showTextOnLockScreen: Value(draft.showTextOnLockScreen),
            ),
          );

      // 4. Insert chosen interests and initial snippets
      var snippetCount = 0;
      for (final interestName in draft.selectedInterests) {
        final trimmed = interestName.trim();
        if (trimmed.isEmpty) continue;
        final key = trimmed.toLowerCase();

        // Avoid duplicate insertion
        final existingInterest = await (db.select(db.interestsTable)..where((tbl) => tbl.nameKey.equals(key))).getSingleOrNull();

        final String interestId;
        if (existingInterest != null) {
          interestId = existingInterest.id;
        } else {
          interestId = uuid.v4();
          await db.into(db.interestsTable).insert(
                InterestsTableCompanion.insert(
                  id: interestId,
                  name: trimmed,
                  nameKey: key,
                  createdAt: now,
                ),
              );
        }

        // Insert snippet if memory was captured
        final memory = draft.memories[trimmed];
        if (memory != null && memory.trim().isNotEmpty) {
          final content = memory.trim();
          final bounded = content.length > 1000 ? content.substring(0, 1000) : content;

          await db.into(db.snippetsTable).insert(
                SnippetsTableCompanion.insert(
                  id: uuid.v4(),
                  interestId: interestId,
                  content: bounded,
                  source: 'ONBOARDING',
                  createdAt: now,
                  updatedAt: now,
                ),
              );
          snippetCount++;
        }
      }

      // 5. Record analytics event
      final localDate = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      await db.into(db.analyticsEventsTable).insert(
            AnalyticsEventsTableCompanion.insert(
              ts: now,
              localDate: localDate,
              localHour: now.hour,
              type: 'onboarding_completed',
              props: Value(
                '{"interests":${draft.selectedInterests.length},"snippets":$snippetCount,"level":"${draft.level.name}"}',
              ),
            ),
          );

      return true;
    });
  }
}
