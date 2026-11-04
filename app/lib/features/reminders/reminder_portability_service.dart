import 'dart:convert';
import 'package:rekindle_core/rekindle_core.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:uuid/uuid.dart';
import 'reminder_scheduler.dart';

/// Service responsible for local JSON export and import of reminders and recurrence rules,
/// enabling complete user data portability without cloud servers or vendor lock-in.
class ReminderPortabilityService {
  ReminderPortabilityService({
    required this.repository,
    required this.scheduler,
    this.recurrenceEngine = const RecurrenceEngine(),
  });

  final ReminderRepository repository;
  final LocalNotificationScheduler scheduler;
  final RecurrenceEngine recurrenceEngine;
  static const _uuid = Uuid();

  static const int currentSchemaVersion = 1;

  /// Serializes all reminders and recurrence rules into a portable, versioned JSON string.
  Future<String> exportRemindersJson() async {
    final allReminders = await repository.getAllReminders();
    final exportList = <Map<String, dynamic>>[];

    for (final reminder in allReminders) {
      final rule = await repository.getRecurrenceRule(reminder.id);
      if (rule == null) continue;

      exportList.add({
        'reminder': {
          'id': reminder.id,
          'title': reminder.title,
          'description': reminder.description,
          'status': reminder.status.name,
          'schedule_type': reminder.scheduleType.name,
          'start_local': reminder.startLocalDateTime.toIso8601String(),
          'timezone_id': reminder.timeZoneId,
          'schedule_version': reminder.scheduleVersion,
          'notification_enabled': reminder.notificationEnabled,
          'linked_activity_id': reminder.linkedActivityId,
          'created_at_utc': reminder.createdAtUtc.toIso8601String(),
          'updated_at_utc': reminder.updatedAtUtc.toIso8601String(),
        },
        'rule_json': rule.toSerializedJson(),
      });
    }

    final payload = {
      'schema_version': currentSchemaVersion,
      'exported_at': DateTime.now().toUtc().toIso8601String(),
      'reminders': exportList,
    };

    return const JsonEncoder.withIndent('  ').convert(payload);
  }

  /// Deserializes a versioned JSON payload, restoring reminders, rules, and enqueuing upcoming alarms.
  /// Returns the count of successfully imported reminders.
  Future<int> importRemindersJson(String jsonString) async {
    final Map<String, dynamic> data = jsonDecode(jsonString) as Map<String, dynamic>;
    final schemaVersion = data['schema_version'] as int? ?? 1;

    if (schemaVersion > currentSchemaVersion) {
      throw FormatException(
        'Unsupported backup schema version: $schemaVersion (supported: $currentSchemaVersion)',
      );
    }

    final remindersRaw = (data['reminders'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final nowUtc = DateTime.now().toUtc();
    int importedCount = 0;

    for (final item in remindersRaw) {
      final rData = item['reminder'] as Map<String, dynamic>;
      final ruleJson = item['rule_json'] as String;

      final rule = RecurrenceRule.fromJson(ruleJson);

      final reminderSkeleton = Reminder(
        id: rData['id'] as String,
        title: rData['title'] as String,
        description: rData['description'] as String?,
        status: ReminderStatus.values.byName(rData['status'] as String),
        scheduleType: ScheduleType.values.byName(rData['schedule_type'] as String),
        startLocalDateTime: DateTime.parse(rData['start_local'] as String),
        timeZoneId: rData['timezone_id'] as String,
        scheduleVersion: rData['schedule_version'] as int? ?? 1,
        notificationEnabled: rData['notification_enabled'] as bool? ?? true,
        linkedActivityId: rData['linked_activity_id'] as String?,
        createdAtUtc: DateTime.parse(rData['created_at_utc'] as String),
        updatedAtUtc: DateTime.parse(rData['updated_at_utc'] as String),
      );

      DateTime? nextOccurrenceUtc;
      ReminderOccurrence? occurrence;

      if (reminderSkeleton.status == ReminderStatus.active) {
        nextOccurrenceUtc = recurrenceEngine.calculateNextOccurrence(
          reminder: reminderSkeleton,
          rule: rule,
          afterUtc: nowUtc,
        );

        if (nextOccurrenceUtc != null) {
          final notifId = await _getNextNotificationId();
          tz.Location location;
          try {
            location = tz.getLocation(reminderSkeleton.timeZoneId);
          } catch (_) {
            location = tz.local;
          }

          occurrence = ReminderOccurrence(
            id: _uuid.v4(),
            reminderId: reminderSkeleton.id,
            scheduleVersion: reminderSkeleton.scheduleVersion,
            scheduledAtUtc: nextOccurrenceUtc,
            scheduledLocalDateTime: tz.TZDateTime.from(nextOccurrenceUtc, location),
            status: OccurrenceStatus.scheduled,
            notificationId: notifId,
            createdAtUtc: nowUtc,
            updatedAtUtc: nowUtc,
          );
        }
      }

      final finalReminder = reminderSkeleton.copyWith(
        nextOccurrenceAtUtc: nextOccurrenceUtc,
        clearNextOccurrence: nextOccurrenceUtc == null,
      );

      await repository.saveReminder(
        reminder: finalReminder,
        rule: rule,
        initialOccurrence: occurrence,
      );

      if (finalReminder.notificationEnabled && occurrence != null) {
        await scheduler.schedule(
          reminder: finalReminder,
          occurrence: occurrence,
        );
      }

      importedCount++;
    }

    return importedCount;
  }

  Future<int> _getNextNotificationId() async {
    final currentStr = await repository.getSetting('last_notification_id');
    final current = int.tryParse(currentStr ?? '1000') ?? 1000;
    final next = current >= 2000000000 ? 1000 : current + 1;
    await repository.saveSetting('last_notification_id', next.toString());
    return next;
  }
}
