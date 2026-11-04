import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rekindle_core/rekindle_core.dart';
import 'package:timezone/timezone.dart' as tz;

/// Abstract platform scheduler interface isolating domain and application layers
/// from direct dependencies on Flutter notification plugins.
abstract interface class LocalNotificationScheduler {
  /// Request notification permission from the user/OS.
  Future<bool> requestPermission();

  /// Schedule a local notification for an upcoming reminder occurrence.
  Future<void> schedule({
    required Reminder reminder,
    required ReminderOccurrence occurrence,
  });

  /// Cancel a specific scheduled notification by notification ID.
  Future<void> cancel(int notificationId);

  /// Retrieve the list of active/pending OS notification request IDs.
  Future<List<int>> getPendingNotificationIds();

  /// Cancel all scheduled reminder notifications.
  Future<void> cancelAll();
}

/// Concrete implementation of [LocalNotificationScheduler] backed by [FlutterLocalNotificationsPlugin].
class FlutterLocalNotificationScheduler implements LocalNotificationScheduler {
  FlutterLocalNotificationScheduler({FlutterLocalNotificationsPlugin? plugin})
      : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;

  static const String channelId = 'rekindle_reminders';
  static const String channelName = 'Reminders';
  static const String channelDescription =
      'Scheduled reminders to revisit saved thoughts and topics.';

  /// Ensures the Android notification channel exists.
  Future<void> initializeChannel() async {
    const androidChannel = AndroidNotificationChannel(
      channelId,
      channelName,
      description: channelDescription,
      importance: Importance.high,
      enableVibration: true,
      playSound: true,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }

  @override
  Future<bool> requestPermission() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return false;

    final granted = await android.requestNotificationsPermission();
    if (granted != null) return granted;

    final areEnabled = await android.areNotificationsEnabled();
    return areEnabled ?? true;
  }

  @override
  Future<void> schedule({
    required Reminder reminder,
    required ReminderOccurrence occurrence,
  }) async {
    // 1. Resolve Timezone location
    tz.Location location;
    try {
      location = tz.getLocation(reminder.timeZoneId);
    } catch (_) {
      location = tz.local;
    }

    // Convert scheduled UTC instant to target TZDateTime
    final tzDate = tz.TZDateTime.from(occurrence.scheduledAtUtc, location);
    var safeTzDate = tzDate;
    final nowTz = tz.TZDateTime.now(location);
    if (!safeTzDate.isAfter(nowTz)) {
      safeTzDate = nowTz.add(const Duration(seconds: 5));
    }

    // 2. Notification payload
    final payload = jsonEncode({
      'type': 'REMINDER',
      'reminderId': reminder.id,
      'occurrenceId': occurrence.id,
      'notificationId': occurrence.notificationId,
      'linkedActivityId': reminder.linkedActivityId,
    });

    // 3. Notification Details & Actions
    final androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      autoCancel: true,
      styleInformation: BigTextStyleInformation(
        reminder.description ?? reminder.title,
        contentTitle: reminder.title,
        summaryText: 'Rekindle Reminder',
      ),
      actions: const [
        AndroidNotificationAction(
          'complete_reminder',
          'Complete',
          showsUserInterface: false,
        ),
        AndroidNotificationAction(
          'skip_reminder',
          'Skip',
          showsUserInterface: false,
        ),
      ],
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    // 4. Check for exact alarm capability (Android 12/13/14+)
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    bool canExact = false;
    try {
      canExact = await android?.canScheduleExactNotifications() ?? false;
    } catch (_) {}

    if (canExact) {
      try {
        await _plugin.zonedSchedule(
          occurrence.notificationId,
          reminder.title,
          reminder.description,
          safeTzDate,
          notificationDetails,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          payload: payload,
        );
        return;
      } catch (_) {
        // Fall back to inexact mode if exact fails or throws SecurityException
      }
    }

    // Fallback mode that works without requiring exact alarm permissions
    await _plugin.zonedSchedule(
      occurrence.notificationId,
      reminder.title,
      reminder.description,
      safeTzDate,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  @override
  Future<void> cancel(int notificationId) async {
    await _plugin.cancel(notificationId);
  }

  @override
  Future<List<int>> getPendingNotificationIds() async {
    final pending = await _plugin.pendingNotificationRequests();
    return pending.map((r) => r.id).toList();
  }

  @override
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}
