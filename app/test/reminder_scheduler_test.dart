import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:rekindle_app/features/reminders/reminder_scheduler.dart';
import 'package:rekindle_core/rekindle_core.dart';

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
  group('LocalNotificationScheduler Tests', () {
    late FakeLocalNotificationScheduler scheduler;

    setUp(() {
      scheduler = FakeLocalNotificationScheduler();
    });

    test('scheduler tracks scheduled occurrences and cancellations', () async {
      final now = DateTime.utc(2026, 11, 4, 12, 0);
      final reminder = Reminder(
        id: 'rem-101',
        title: 'Review Machine Learning Notes',
        description: 'Focus on bias-variance tradeoff',
        status: ReminderStatus.active,
        scheduleType: ScheduleType.once,
        startLocalDateTime: DateTime(2026, 11, 4, 12, 0),
        timeZoneId: 'UTC',
        createdAtUtc: now,
        updatedAtUtc: now,
      );

      final occ1 = ReminderOccurrence(
        id: 'occ-201',
        reminderId: reminder.id,
        scheduleVersion: 1,
        scheduledAtUtc: now.add(const Duration(hours: 2)),
        scheduledLocalDateTime: now.add(const Duration(hours: 2)),
        status: OccurrenceStatus.scheduled,
        notificationId: 501,
        createdAtUtc: now,
        updatedAtUtc: now,
      );

      final occ2 = ReminderOccurrence(
        id: 'occ-202',
        reminderId: reminder.id,
        scheduleVersion: 1,
        scheduledAtUtc: now.add(const Duration(hours: 4)),
        scheduledLocalDateTime: now.add(const Duration(hours: 4)),
        status: OccurrenceStatus.scheduled,
        notificationId: 502,
        createdAtUtc: now,
        updatedAtUtc: now,
      );

      // Schedule both
      await scheduler.schedule(reminder: reminder, occurrence: occ1);
      await scheduler.schedule(reminder: reminder, occurrence: occ2);

      var pending = await scheduler.getPendingNotificationIds();
      expect(pending, containsAll([501, 502]));

      // Cancel one
      await scheduler.cancel(501);
      pending = await scheduler.getPendingNotificationIds();
      expect(pending, [502]);

      // Cancel all
      await scheduler.cancelAll();
      pending = await scheduler.getPendingNotificationIds();
      expect(pending, isEmpty);
    });

    test('notification payload encodes correct fields', () {
      final payloadJson = jsonEncode({
        'type': 'REMINDER',
        'reminderId': 'rem-abc',
        'occurrenceId': 'occ-xyz',
        'notificationId': 999,
        'linkedActivityId': 'act-1',
      });

      final decoded = jsonDecode(payloadJson) as Map<String, dynamic>;
      expect(decoded['type'], 'REMINDER');
      expect(decoded['reminderId'], 'rem-abc');
      expect(decoded['occurrenceId'], 'occ-xyz');
      expect(decoded['notificationId'], 999);
      expect(decoded['linkedActivityId'], 'act-1');
    });
  });
}
