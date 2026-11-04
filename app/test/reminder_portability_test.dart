import 'dart:convert';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rekindle_app/features/reminders/reminder_portability_service.dart';
import 'package:rekindle_app/features/reminders/reminder_scheduler.dart';
import 'package:rekindle_core/rekindle_core.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class FakeLocalNotificationScheduler implements LocalNotificationScheduler {
  final Map<int, Map<String, dynamic>> scheduled = {};

  @override
  Future<bool> requestPermission() async => true;

  @override
  Future<void> schedule({
    required Reminder reminder,
    required ReminderOccurrence occurrence,
  }) async {
    scheduled[occurrence.notificationId] = {
      'reminderId': reminder.id,
      'occurrenceId': occurrence.id,
    };
  }

  @override
  Future<void> cancel(int notificationId) async {
    scheduled.remove(notificationId);
  }

  @override
  Future<List<int>> getPendingNotificationIds() async => scheduled.keys.toList();

  @override
  Future<void> cancelAll() async {
    scheduled.clear();
  }
}

void main() {
  tz_data.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('UTC'));

  late AppDatabase db;
  late DriftReminderRepository repository;
  late FakeLocalNotificationScheduler scheduler;
  late ReminderPortabilityService service;

  setUp(() {
    db = AppDatabase(
      NativeDatabase.memory(
        setup: (rawDb) {
          rawDb.execute('PRAGMA foreign_keys = ON;');
        },
      ),
    );
    repository = DriftReminderRepository(db);
    scheduler = FakeLocalNotificationScheduler();
    service = ReminderPortabilityService(
      repository: repository,
      scheduler: scheduler,
    );
  });

  tearDown(() async {
    await db.close();
  });

  group('ReminderPortabilityService Tests', () {
    test('exports reminders and recurrence rules to valid JSON', () async {
      final now = DateTime.utc(2026, 11, 4, 12, 0);

      final r1 = Reminder(
        id: 'rem-port-1',
        title: 'Study Topology',
        status: ReminderStatus.active,
        scheduleType: ScheduleType.interval,
        startLocalDateTime: now,
        timeZoneId: 'UTC',
        createdAtUtc: now,
        updatedAtUtc: now,
      );

      final r2 = Reminder(
        id: 'rem-port-2',
        title: 'Read Poetry',
        status: ReminderStatus.paused,
        scheduleType: ScheduleType.weekly,
        startLocalDateTime: now,
        timeZoneId: 'UTC',
        createdAtUtc: now,
        updatedAtUtc: now,
      );

      await repository.saveReminder(
        reminder: r1,
        rule: const IntervalRule(value: 3, unit: IntervalUnit.days),
      );

      await repository.saveReminder(
        reminder: r2,
        rule: WeeklyRule(
          weekdays: {6, 7},
          localTime: const ReminderTime(hour: 10, minute: 30),
        ),
      );

      final jsonString = await service.exportRemindersJson();
      expect(jsonString, isNotEmpty);

      final parsed = jsonDecode(jsonString) as Map<String, dynamic>;
      expect(parsed['schema_version'], 1);
      final list = parsed['reminders'] as List;
      expect(list.length, 2);
    });

    test('imports JSON payload, restores rules and enqueues occurrences', () async {
      final now = DateTime.utc(2026, 11, 4, 12, 0);

      final r1 = Reminder(
        id: 'import-rem-1',
        title: 'Learn Rust Concurrency',
        status: ReminderStatus.active,
        scheduleType: ScheduleType.interval,
        startLocalDateTime: now,
        timeZoneId: 'UTC',
        createdAtUtc: now,
        updatedAtUtc: now,
      );

      await repository.saveReminder(
        reminder: r1,
        rule: const IntervalRule(value: 6, unit: IntervalUnit.hours),
      );

      final jsonPayload = await service.exportRemindersJson();

      // Clear repository by creating a new database
      final freshDb = AppDatabase(
        NativeDatabase.memory(
          setup: (rawDb) {
            rawDb.execute('PRAGMA foreign_keys = ON;');
          },
        ),
      );
      final freshRepo = DriftReminderRepository(freshDb);
      final freshScheduler = FakeLocalNotificationScheduler();
      final freshService = ReminderPortabilityService(
        repository: freshRepo,
        scheduler: freshScheduler,
      );

      final count = await freshService.importRemindersJson(jsonPayload);
      expect(count, 1);

      // Verify reminder restored
      final restored = await freshRepo.getReminder('import-rem-1');
      expect(restored, isNotNull);
      expect(restored!.title, 'Learn Rust Concurrency');
      expect(restored.status, ReminderStatus.active);

      // Verify rule restored
      final rule = await freshRepo.getRecurrenceRule('import-rem-1');
      expect(rule, isA<IntervalRule>());
      expect((rule as IntervalRule).value, 6);

      // Verify occurrence was calculated and scheduled
      final occ = await freshRepo.getNextOccurrence('import-rem-1');
      expect(occ, isNotNull);
      expect(freshScheduler.scheduled.containsKey(occ!.notificationId), isTrue);

      await freshDb.close();
    });

    test('throws FormatException on higher unsupported schema version', () async {
      final invalidPayload = jsonEncode({
        'schema_version': 99,
        'reminders': [],
      });

      expect(
        () => service.importRemindersJson(invalidPayload),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
