import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rekindle_app/features/reminders/reminder_reconciliation_service.dart';
import 'package:rekindle_app/features/reminders/reminder_scheduler.dart';
import 'package:rekindle_app/features/reminders/reminder_service.dart';
import 'package:rekindle_core/rekindle_core.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class FakeLocalNotificationScheduler implements LocalNotificationScheduler {
  bool permissionGranted = true;
  final Map<int, Map<String, dynamic>> scheduled = {};

  @override
  Future<bool> requestPermission() async => permissionGranted;

  @override
  Future<void> schedule({
    required Reminder reminder,
    required ReminderOccurrence occurrence,
  }) async {
    scheduled[occurrence.notificationId] = {
      'reminderId': reminder.id,
      'occurrenceId': occurrence.id,
      'title': reminder.title,
      'body': reminder.description,
      'scheduledAtUtc': occurrence.scheduledAtUtc,
    };
  }

  @override
  Future<void> cancel(int notificationId) async {
    scheduled.remove(notificationId);
  }

  @override
  Future<List<int>> getPendingNotificationIds() async {
    return scheduled.keys.toList();
  }

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
  late ReminderService service;
  late ReminderReconciliationService reconciliationService;

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
    service = ReminderService(
      repository: repository,
      scheduler: scheduler,
    );
    reconciliationService = ReminderReconciliationService(
      repository: repository,
      scheduler: scheduler,
    );
  });

  tearDown(() async {
    await db.close();
  });

  group('ReminderService CRUD & Lifecycle Tests', () {
    test('createReminder schedules one-time reminder in future', () async {
      final futureDate = DateTime.now().toUtc().add(const Duration(hours: 3));

      final reminder = await service.createReminder(
        title: 'Review Physics paper',
        description: 'Read thermodynamics section',
        scheduleType: ScheduleType.once,
        startLocalDateTime: futureDate,
        timeZoneId: 'UTC',
        rule: OnceRule(futureDate),
      );

      expect(reminder.title, 'Review Physics paper');
      expect(reminder.status, ReminderStatus.active);
      expect(reminder.nextOccurrenceAtUtc, isNotNull);

      final nextOcc = await repository.getNextOccurrence(reminder.id);
      expect(nextOcc, isNotNull);
      expect(nextOcc!.status, OccurrenceStatus.scheduled);
      expect(scheduler.scheduled.containsKey(nextOcc.notificationId), isTrue);
    });

    test('updateReminder bumps version, cancels previous, schedules new', () async {
      final initialDate = DateTime.now().toUtc().add(const Duration(hours: 2));
      final updatedDate = DateTime.now().toUtc().add(const Duration(hours: 5));

      final created = await service.createReminder(
        title: 'Study Calculus',
        scheduleType: ScheduleType.once,
        startLocalDateTime: initialDate,
        timeZoneId: 'UTC',
        rule: OnceRule(initialDate),
      );

      final initialOcc = await repository.getNextOccurrence(created.id);
      expect(initialOcc, isNotNull);
      final initialNotifId = initialOcc!.notificationId;
      expect(scheduler.scheduled.containsKey(initialNotifId), isTrue);

      // Update reminder to 5 hours in future
      await service.updateReminder(
        reminder: created.copyWith(
          title: 'Study Advanced Calculus',
          startLocalDateTime: updatedDate,
        ),
        rule: OnceRule(updatedDate),
      );

      // Previous notification should be cancelled
      expect(scheduler.scheduled.containsKey(initialNotifId), isFalse);

      final updatedReminder = await repository.getReminder(created.id);
      expect(updatedReminder!.scheduleVersion, 2);
      expect(updatedReminder.title, 'Study Advanced Calculus');

      final newOcc = await repository.getNextOccurrence(created.id);
      expect(newOcc, isNotNull);
      expect(newOcc!.scheduleVersion, 2);
      expect(scheduler.scheduled.containsKey(newOcc.notificationId), isTrue);
    });

    test('pauseReminder cancels active alarm and marks reminder paused', () async {
      final futureDate = DateTime.now().toUtc().add(const Duration(hours: 2));

      final reminder = await service.createReminder(
        title: 'Meditation',
        scheduleType: ScheduleType.interval,
        startLocalDateTime: futureDate,
        timeZoneId: 'UTC',
        rule: const IntervalRule(value: 4, unit: IntervalUnit.hours),
      );

      final occ = await repository.getNextOccurrence(reminder.id);
      expect(scheduler.scheduled.containsKey(occ!.notificationId), isTrue);

      await service.pauseReminder(reminder.id);

      final paused = await repository.getReminder(reminder.id);
      expect(paused!.status, ReminderStatus.paused);
      expect(paused.nextOccurrenceAtUtc, isNull);
      expect(scheduler.scheduled.containsKey(occ.notificationId), isFalse);

      // Resume reminder
      await service.resumeReminder(reminder.id);
      final resumed = await repository.getReminder(reminder.id);
      expect(resumed!.status, ReminderStatus.active);
      expect(resumed.nextOccurrenceAtUtc, isNotNull);

      final resumedOcc = await repository.getNextOccurrence(reminder.id);
      expect(scheduler.scheduled.containsKey(resumedOcc!.notificationId), isTrue);
    });

    test('completeOccurrence completes one-time reminder or advances recurring rule', () async {
      // 1. One-time reminder
      final oneTimeDate = DateTime.now().toUtc().add(const Duration(hours: 1));
      final oneTime = await service.createReminder(
        title: 'Call mentor',
        scheduleType: ScheduleType.once,
        startLocalDateTime: oneTimeDate,
        timeZoneId: 'UTC',
        rule: OnceRule(oneTimeDate),
      );

      final oneTimeOcc = await repository.getNextOccurrence(oneTime.id);
      await service.completeOccurrence(oneTimeOcc!.id);

      final completedOneTime = await repository.getReminder(oneTime.id);
      expect(completedOneTime!.status, ReminderStatus.completed);
      expect(completedOneTime.nextOccurrenceAtUtc, isNull);

      // 2. Interval recurring reminder
      final recurringDate = DateTime.now().toUtc().add(const Duration(hours: 1));
      final recurring = await service.createReminder(
        title: 'Hydration break',
        scheduleType: ScheduleType.interval,
        startLocalDateTime: recurringDate,
        timeZoneId: 'UTC',
        rule: const IntervalRule(value: 2, unit: IntervalUnit.hours),
      );

      final firstOcc = await repository.getNextOccurrence(recurring.id);
      await service.completeOccurrence(firstOcc!.id);

      final completedFirstOcc = await repository.getOccurrence(firstOcc.id);
      expect(completedFirstOcc!.status, OccurrenceStatus.completed);

      final nextOcc = await repository.getNextOccurrence(recurring.id);
      expect(nextOcc, isNotNull);
      expect(nextOcc!.id, isNot(firstOcc.id));
      expect(scheduler.scheduled.containsKey(nextOcc.notificationId), isTrue);
    });
  });

  group('ReminderReconciliationService Tests', () {
    test('detects missed occurrences when app is opened after scheduled time', () async {
      final nowUtc = DateTime.utc(2026, 11, 4, 12, 0);

      // Create a reminder that was due 2 hours ago
      final pastDate = nowUtc.subtract(const Duration(hours: 2));
      final reminder = Reminder(
        id: 'rem-past',
        title: 'Morning Yoga',
        status: ReminderStatus.active,
        scheduleType: ScheduleType.interval,
        startLocalDateTime: pastDate,
        timeZoneId: 'UTC',
        nextOccurrenceAtUtc: pastDate,
        scheduleVersion: 1,
        notificationEnabled: true,
        createdAtUtc: pastDate,
        updatedAtUtc: pastDate,
      );

      final pastOcc = ReminderOccurrence(
        id: 'occ-past',
        reminderId: reminder.id,
        scheduleVersion: 1,
        scheduledAtUtc: pastDate,
        scheduledLocalDateTime: pastDate,
        status: OccurrenceStatus.scheduled,
        notificationId: 901,
        createdAtUtc: pastDate,
        updatedAtUtc: pastDate,
      );

      await repository.saveReminder(
        reminder: reminder,
        rule: const IntervalRule(value: 4, unit: IntervalUnit.hours),
        initialOccurrence: pastOcc,
      );

      // Run reconciliation at current time
      await reconciliationService.reconcile(
        nowUtc: nowUtc,
        currentTimezone: 'UTC',
      );

      // Past occurrence should be marked missed
      final resolvedPastOcc = await repository.getOccurrence(pastOcc.id);
      expect(resolvedPastOcc!.status, OccurrenceStatus.missed);

      // Next future occurrence should be scheduled strictly after nowUtc
      final nextOcc = await repository.getNextOccurrence(reminder.id);
      expect(nextOcc, isNotNull);
      expect(nextOcc!.scheduledAtUtc.isAfter(nowUtc), isTrue);
      expect(scheduler.scheduled.containsKey(nextOcc.notificationId), isTrue);
    });

    test('restores dropped alarms after device reboot', () async {
      final nowUtc = DateTime.utc(2026, 11, 4, 12, 0);
      final futureDate = nowUtc.add(const Duration(hours: 3));

      final reminder = Reminder(
        id: 'rem-future',
        title: 'Review Books',
        status: ReminderStatus.active,
        scheduleType: ScheduleType.once,
        startLocalDateTime: futureDate,
        timeZoneId: 'UTC',
        nextOccurrenceAtUtc: futureDate,
        scheduleVersion: 1,
        notificationEnabled: true,
        createdAtUtc: nowUtc,
        updatedAtUtc: nowUtc,
      );

      final occ = ReminderOccurrence(
        id: 'occ-future',
        reminderId: reminder.id,
        scheduleVersion: 1,
        scheduledAtUtc: futureDate,
        scheduledLocalDateTime: futureDate,
        status: OccurrenceStatus.scheduled,
        notificationId: 902,
        createdAtUtc: nowUtc,
        updatedAtUtc: nowUtc,
      );

      await repository.saveReminder(
        reminder: reminder,
        rule: OnceRule(futureDate),
        initialOccurrence: occ,
      );

      // Simulate reboot: scheduler has 0 pending notifications
      expect(scheduler.scheduled.isEmpty, isTrue);

      // Reconcile
      await reconciliationService.reconcile(
        nowUtc: nowUtc,
        currentTimezone: 'UTC',
      );

      // Alarm should be restored into scheduler
      expect(scheduler.scheduled.containsKey(902), isTrue);
    });
  });
}
