import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rekindle_core/rekindle_core.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import '../../app/database_factory.dart';
import 'reminder_scheduler.dart';
import 'reminder_service.dart';

/// Processes notification action responses (`complete_reminder`, `skip_reminder`)
/// against [service] so recurring interval/weekly reminders advance immediately.
Future<void> handleReminderNotificationResponse(
  NotificationResponse response,
  ReminderService service,
) async {
  final payloadStr = response.payload;
  if (payloadStr == null || payloadStr.isEmpty) return;

  Map<String, dynamic> payload;
  try {
    final decoded = jsonDecode(payloadStr);
    if (decoded is! Map<String, dynamic>) return;
    payload = decoded;
  } catch (_) {
    return;
  }

  if (payload['type'] != 'REMINDER') return;
  final occurrenceId = payload['occurrenceId'] as String?;
  if (occurrenceId == null || occurrenceId.isEmpty) return;

  switch (response.actionId) {
    case 'complete_reminder':
      await service.completeOccurrence(occurrenceId);
      break;
    case 'skip_reminder':
      await service.skipOccurrence(occurrenceId);
      break;
  }
}

/// Top-level background notification callback invoked by Android when an action
/// with `showsUserInterface: false` is tapped while the main UI isolate is absent.
@pragma('vm:entry-point')
Future<void> reminderBackgroundNotificationHandler(
  NotificationResponse response,
) async {
  WidgetsFlutterBinding.ensureInitialized();
  tz_data.initializeTimeZones();

  final db = openRekindleDatabase();
  try {
    final repository = DriftReminderRepository(db);
    final scheduler = FlutterLocalNotificationScheduler();
    await scheduler.initializeChannel();
    final service = ReminderService(
      repository: repository,
      scheduler: scheduler,
    );
    await handleReminderNotificationResponse(response, service);
  } finally {
    await db.close();
  }
}
