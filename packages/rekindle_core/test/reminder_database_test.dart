import 'package:drift/native.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';
import 'package:rekindle_core/rekindle_core.dart';

void main() {
  late AppDatabase db;
  late DriftReminderRepository repository;
  const uuid = Uuid();

  setUp(() {
    db = AppDatabase(
      NativeDatabase.memory(
        setup: (rawDb) {
          rawDb.execute('PRAGMA foreign_keys = ON;');
        },
      ),
    );
    repository = DriftReminderRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('Drift SQLite Schema v2 & ReminderRepository Tests', () {
    test('database opens at schemaVersion 2', () {
      expect(db.schemaVersion, 2);
    });

    test('migration from v1 to v2 preserves existing data', () async {
      // 1. Setup raw database with v1 schema and existing user data
      final raw = sqlite3.openInMemory();
      raw.execute('''
        PRAGMA user_version = 1;
        CREATE TABLE interests_table (
          id TEXT NOT NULL PRIMARY KEY,
          name TEXT NOT NULL,
          name_key TEXT NOT NULL UNIQUE,
          alpha REAL NOT NULL DEFAULT 1.0,
          beta REAL NOT NULL DEFAULT 1.0,
          push_cooldown_until INTEGER,
          archived_at INTEGER,
          created_at INTEGER NOT NULL
        );
        CREATE TABLE snippets_table (
          id TEXT NOT NULL PRIMARY KEY,
          interest_id TEXT NOT NULL REFERENCES interests_table(id) ON DELETE CASCADE,
          content TEXT NOT NULL,
          source TEXT NOT NULL,
          created_at INTEGER NOT NULL,
          updated_at INTEGER NOT NULL
        );
        INSERT INTO interests_table (id, name, name_key, created_at) VALUES ('int-1', 'Philosophy', 'philosophy', 1700000000);
        INSERT INTO snippets_table (id, interest_id, content, source, created_at, updated_at) VALUES ('snip-1', 'int-1', 'The unexamined life is not worth living.', 'MANUAL', 1700000000, 1700000000);
      ''');

      // 2. Open with Drift AppDatabase
      final migratedDb = AppDatabase(NativeDatabase.opened(raw));

      // 3. Verify existing data is preserved
      final interests = await migratedDb.select(migratedDb.interestsTable).get();
      expect(interests.length, 1);
      expect(interests.first.name, 'Philosophy');

      final snippets = await migratedDb.select(migratedDb.snippetsTable).get();
      expect(snippets.length, 1);
      expect(snippets.first.content, 'The unexamined life is not worth living.');

      // 4. Verify v2 tables are created and operational
      final reminderId = uuid.v4();
      final now = DateTime.utc(2026, 11, 4, 10, 0);
      final reminder = Reminder(
        id: reminderId,
        title: 'Read Plato',
        status: ReminderStatus.active,
        scheduleType: ScheduleType.once,
        startLocalDateTime: DateTime(2026, 11, 4, 10, 0),
        timeZoneId: 'UTC',
        createdAtUtc: now,
        updatedAtUtc: now,
      );
      final repo = DriftReminderRepository(migratedDb);
      await repo.saveReminder(
        reminder: reminder,
        rule: OnceRule(DateTime(2026, 11, 4, 10, 0)),
      );

      final fetched = await repo.getReminder(reminderId);
      expect(fetched, isNotNull);
      expect(fetched!.title, 'Read Plato');

      await migratedDb.close();
    });

    test('saveReminder, getReminder, and getRecurrenceRule roundtrip', () async {
      final reminderId = uuid.v4();
      final now = DateTime.utc(2026, 11, 4, 10, 0);

      final reminder = Reminder(
        id: reminderId,
        title: 'Review Machine Learning Notes',
        description: 'Focus on cross-validation and bias-variance tradeoff',
        status: ReminderStatus.active,
        scheduleType: ScheduleType.weekly,
        startLocalDateTime: DateTime(2026, 11, 4, 9, 0),
        timeZoneId: 'America/New_York',
        nextOccurrenceAtUtc: DateTime.utc(2026, 11, 6, 14, 0),
        scheduleVersion: 1,
        notificationEnabled: true,
        linkedActivityId: 'act-123',
        createdAtUtc: now,
        updatedAtUtc: now,
      );

      final rule = WeeklyRule(
        weekdays: {1, 3, 5},
        localTime: const ReminderTime(hour: 9, minute: 0),
      );

      final occurrence = ReminderOccurrence(
        id: uuid.v4(),
        reminderId: reminderId,
        scheduleVersion: 1,
        scheduledAtUtc: DateTime.utc(2026, 11, 6, 14, 0),
        scheduledLocalDateTime: DateTime(2026, 11, 6, 9, 0),
        status: OccurrenceStatus.scheduled,
        notificationId: 101,
        createdAtUtc: now,
        updatedAtUtc: now,
      );

      await repository.saveReminder(
        reminder: reminder,
        rule: rule,
        initialOccurrence: occurrence,
      );

      // Verify reminder retrieved
      final fetchedReminder = await repository.getReminder(reminderId);
      expect(fetchedReminder, isNotNull);
      expect(fetchedReminder!.id, reminderId);
      expect(fetchedReminder.title, 'Review Machine Learning Notes');
      expect(fetchedReminder.status, ReminderStatus.active);
      expect(fetchedReminder.scheduleType, ScheduleType.weekly);
      expect(fetchedReminder.timeZoneId, 'America/New_York');
      expect(fetchedReminder.nextOccurrenceAtUtc, DateTime.utc(2026, 11, 6, 14, 0));
      expect(fetchedReminder.linkedActivityId, 'act-123');

      // Verify rule retrieved
      final fetchedRule = await repository.getRecurrenceRule(reminderId);
      expect(fetchedRule, isNotNull);
      expect(fetchedRule, isA<WeeklyRule>());
      final weekly = fetchedRule as WeeklyRule;
      expect(weekly.weekdays, {1, 3, 5});
      expect(weekly.localTime.hour, 9);
      expect(weekly.localTime.minute, 0);

      // Verify occurrence retrieved
      final fetchedOccurrence = await repository.getOccurrence(occurrence.id);
      expect(fetchedOccurrence, isNotNull);
      expect(fetchedOccurrence!.reminderId, reminderId);
      expect(fetchedOccurrence.notificationId, 101);
      expect(fetchedOccurrence.status, OccurrenceStatus.scheduled);
    });

    test('cascading delete removes recurrence rules and occurrences', () async {
      final reminderId = uuid.v4();
      final now = DateTime.utc(2026, 11, 4, 10, 0);

      final reminder = Reminder(
        id: reminderId,
        title: 'Meditation Break',
        status: ReminderStatus.active,
        scheduleType: ScheduleType.interval,
        startLocalDateTime: DateTime(2026, 11, 4, 10, 0),
        timeZoneId: 'UTC',
        createdAtUtc: now,
        updatedAtUtc: now,
      );

      final rule = const IntervalRule(value: 2, unit: IntervalUnit.hours);

      final occ1 = ReminderOccurrence(
        id: uuid.v4(),
        reminderId: reminderId,
        scheduleVersion: 1,
        scheduledAtUtc: DateTime.utc(2026, 11, 4, 12, 0),
        scheduledLocalDateTime: DateTime(2026, 11, 4, 12, 0),
        status: OccurrenceStatus.scheduled,
        notificationId: 201,
        createdAtUtc: now,
        updatedAtUtc: now,
      );

      final occ2 = ReminderOccurrence(
        id: uuid.v4(),
        reminderId: reminderId,
        scheduleVersion: 1,
        scheduledAtUtc: DateTime.utc(2026, 11, 4, 14, 0),
        scheduledLocalDateTime: DateTime(2026, 11, 4, 14, 0),
        status: OccurrenceStatus.pending,
        notificationId: 202,
        createdAtUtc: now,
        updatedAtUtc: now,
      );

      await repository.saveReminder(
        reminder: reminder,
        rule: rule,
        initialOccurrence: occ1,
      );
      await repository.saveOccurrence(occ2);

      // Confirm all entities exist
      expect(await repository.getReminder(reminderId), isNotNull);
      expect(await repository.getRecurrenceRule(reminderId), isNotNull);
      expect(await repository.getOccurrence(occ1.id), isNotNull);
      expect(await repository.getOccurrence(occ2.id), isNotNull);

      // Delete parent reminder
      await repository.deleteReminder(reminderId);

      // Confirm cascade deletion
      expect(await repository.getReminder(reminderId), isNull);
      expect(await repository.getRecurrenceRule(reminderId), isNull);
      expect(await repository.getOccurrence(occ1.id), isNull);
      expect(await repository.getOccurrence(occ2.id), isNull);
    });

    test('occurrence queries: getNextOccurrence and getPendingOccurrences', () async {
      final reminderId = uuid.v4();
      final now = DateTime.utc(2026, 11, 4, 10, 0);

      final reminder = Reminder(
        id: reminderId,
        title: 'Daily Journaling',
        status: ReminderStatus.active,
        scheduleType: ScheduleType.interval,
        startLocalDateTime: DateTime(2026, 11, 4, 10, 0),
        timeZoneId: 'UTC',
        createdAtUtc: now,
        updatedAtUtc: now,
      );

      final rule = const IntervalRule(value: 1, unit: IntervalUnit.days);

      final pastOccurrence = ReminderOccurrence(
        id: uuid.v4(),
        reminderId: reminderId,
        scheduleVersion: 1,
        scheduledAtUtc: DateTime.utc(2026, 11, 3, 10, 0),
        scheduledLocalDateTime: DateTime(2026, 11, 3, 10, 0),
        status: OccurrenceStatus.completed,
        notificationId: 301,
        createdAtUtc: now,
        updatedAtUtc: now,
      );

      final nextOccurrence = ReminderOccurrence(
        id: uuid.v4(),
        reminderId: reminderId,
        scheduleVersion: 1,
        scheduledAtUtc: DateTime.utc(2026, 11, 4, 10, 0),
        scheduledLocalDateTime: DateTime(2026, 11, 4, 10, 0),
        status: OccurrenceStatus.scheduled,
        notificationId: 302,
        createdAtUtc: now,
        updatedAtUtc: now,
      );

      final futureOccurrence = ReminderOccurrence(
        id: uuid.v4(),
        reminderId: reminderId,
        scheduleVersion: 1,
        scheduledAtUtc: DateTime.utc(2026, 11, 5, 10, 0),
        scheduledLocalDateTime: DateTime(2026, 11, 5, 10, 0),
        status: OccurrenceStatus.pending,
        notificationId: 303,
        createdAtUtc: now,
        updatedAtUtc: now,
      );

      await repository.saveReminder(reminder: reminder, rule: rule);
      await repository.saveOccurrence(pastOccurrence);
      await repository.saveOccurrence(nextOccurrence);
      await repository.saveOccurrence(futureOccurrence);

      // getNextOccurrence should return nextOccurrence (scheduled)
      final next = await repository.getNextOccurrence(reminderId);
      expect(next, isNotNull);
      expect(next!.id, nextOccurrence.id);

      // getPendingOccurrences should return both nextOccurrence and futureOccurrence, sorted
      final pending = await repository.getPendingOccurrences();
      expect(pending.length, 2);
      expect(pending[0].id, nextOccurrence.id);
      expect(pending[1].id, futureOccurrence.id);

      // Mark nextOccurrence completed
      await repository.updateOccurrenceStatus(nextOccurrence.id, OccurrenceStatus.completed);

      // getNextOccurrence should now advance to futureOccurrence
      final updatedNext = await repository.getNextOccurrence(reminderId);
      expect(updatedNext, isNotNull);
      expect(updatedNext!.id, futureOccurrence.id);
    });

    test('settings key-value store persists and updates', () async {
      expect(await repository.getSetting('last_timezone'), isNull);

      await repository.saveSetting('last_timezone', 'Europe/Paris');
      expect(await repository.getSetting('last_timezone'), 'Europe/Paris');

      await repository.saveSetting('last_timezone', 'Asia/Tokyo');
      expect(await repository.getSetting('last_timezone'), 'Asia/Tokyo');
    });

    test('watchAllReminders streams real-time updates', () async {
      final now = DateTime.utc(2026, 11, 4, 10, 0);
      final emissions = <List<Reminder>>[];
      final sub = repository.watchAllReminders().listen(emissions.add);

      await pumpEventQueue();
      expect(emissions, [isEmpty]);

      final r1 = Reminder(
        id: uuid.v4(),
        title: 'Task 1',
        status: ReminderStatus.active,
        scheduleType: ScheduleType.once,
        startLocalDateTime: DateTime(2026, 11, 4, 10, 0),
        timeZoneId: 'UTC',
        createdAtUtc: now,
        updatedAtUtc: now,
      );
      await repository.saveReminder(
        reminder: r1,
        rule: OnceRule(DateTime(2026, 11, 4, 10, 0)),
      );

      await pumpEventQueue();
      expect(emissions.length, 2);
      expect(emissions.last, hasLength(1));

      final r2 = Reminder(
        id: uuid.v4(),
        title: 'Task 2',
        status: ReminderStatus.active,
        scheduleType: ScheduleType.once,
        startLocalDateTime: DateTime(2026, 11, 4, 11, 0),
        timeZoneId: 'UTC',
        createdAtUtc: now,
        updatedAtUtc: now,
      );
      await repository.saveReminder(
        reminder: r2,
        rule: OnceRule(DateTime(2026, 11, 4, 11, 0)),
      );

      await pumpEventQueue();
      expect(emissions.length, 3);
      expect(emissions.last, hasLength(2));

      await sub.cancel();
    });
  });
}
