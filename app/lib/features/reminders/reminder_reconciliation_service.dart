import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:rekindle_core/rekindle_core.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:uuid/uuid.dart';
import 'reminder_scheduler.dart';

/// Idempotent background reconciliation service ensuring that SQLite database
/// state and the volatile Android OS AlarmManager stay in exact synchronization.
///
/// Responsibilities:
/// 1. Detect device timezone shifts and recalculate future wall-clock occurrences.
/// 2. Detect missed occurrences (phone was powered down when alarm was due) and advance recurring rules.
/// 3. Restore dropped platform alarms upon reboot or app resume.
class ReminderReconciliationService {
  ReminderReconciliationService({
    required this.repository,
    required this.scheduler,
    this.recurrenceEngine = const RecurrenceEngine(),
  });

  final ReminderRepository repository;
  final LocalNotificationScheduler scheduler;
  final RecurrenceEngine recurrenceEngine;
  static const _uuid = Uuid();

  Future<int> _getNextNotificationId() async {
    final currentStr = await repository.getSetting('last_notification_id');
    final current = int.tryParse(currentStr ?? '1000') ?? 1000;
    final next = current >= 2000000000 ? 1000 : current + 1;
    await repository.saveSetting('last_notification_id', next.toString());
    return next;
  }

  Future<String> _detectTimezone() async {
    try {
      return await FlutterTimezone.getLocalTimezone();
    } catch (_) {
      return 'UTC';
    }
  }

  /// Executes idempotent reconciliation against current wall-clock time and timezone.
  Future<void> reconcile({
    DateTime? nowUtc,
    String? currentTimezone,
  }) async {
    final now = nowUtc ?? DateTime.now().toUtc();
    final deviceTz = currentTimezone ?? await _detectTimezone();

    // --- 1. Detect Timezone Shift ---
    final lastTz = await repository.getSetting('last_reconciled_timezone');
    final bool tzShiftDetected = lastTz != null && lastTz != deviceTz;

    if (tzShiftDetected) {
      await _handleTimezoneShift(newTz: deviceTz, nowUtc: now);
    }
    await repository.saveSetting('last_reconciled_timezone', deviceTz);

    // --- 2. Detect Missed Occurrences ---
    final pendingOccurrences = await repository.getPendingOccurrences();
    final missedOccurrences = pendingOccurrences.where(
      (o) => o.scheduledAtUtc.isBefore(now),
    ).toList();

    for (final missed in missedOccurrences) {
      await repository.updateOccurrenceStatus(
        missed.id,
        OccurrenceStatus.missed,
      );

      final reminder = await repository.getReminder(missed.reminderId);
      final rule = await repository.getRecurrenceRule(missed.reminderId);

      if (reminder != null && rule != null && reminder.status == ReminderStatus.active) {
        if (reminder.scheduleType == ScheduleType.once) {
          await repository.updateReminder(
            reminder.copyWith(
              status: ReminderStatus.completed,
              clearNextOccurrence: true,
              updatedAtUtc: now,
            ),
          );
        } else {
          // Recurring schedule: advance to next future occurrence strictly after now
          final nextUtc = recurrenceEngine.calculateNextOccurrence(
            reminder: reminder,
            rule: rule,
            afterUtc: now,
          );

          if (nextUtc != null) {
            final nextNotifId = await _getNextNotificationId();
            tz.Location location;
            try {
              location = tz.getLocation(reminder.timeZoneId);
            } catch (_) {
              location = tz.local;
            }

            final nextOccurrence = ReminderOccurrence(
              id: _uuid.v4(),
              reminderId: reminder.id,
              scheduleVersion: reminder.scheduleVersion,
              scheduledAtUtc: nextUtc,
              scheduledLocalDateTime: tz.TZDateTime.from(nextUtc, location),
              status: OccurrenceStatus.scheduled,
              notificationId: nextNotifId,
              createdAtUtc: now,
              updatedAtUtc: now,
            );

            await repository.saveOccurrence(nextOccurrence);
            await repository.updateReminder(
              reminder.copyWith(
                nextOccurrenceAtUtc: nextUtc,
                updatedAtUtc: now,
              ),
            );

            if (reminder.notificationEnabled) {
              await scheduler.schedule(
                reminder: reminder,
                occurrence: nextOccurrence,
              );
            }
          }
        }
      }
    }

    // --- 3. Restore Dropped Alarms (Reboot / Battery Optimization Recovery) ---
    final currentPending = await repository.getPendingOccurrences();
    final futurePending = currentPending.where(
      (o) => !o.scheduledAtUtc.isBefore(now) && o.status == OccurrenceStatus.scheduled,
    ).toList();

    final activePlatformIds = (await scheduler.getPendingNotificationIds()).toSet();

    for (final occurrence in futurePending) {
      if (!activePlatformIds.contains(occurrence.notificationId)) {
        final reminder = await repository.getReminder(occurrence.reminderId);
        if (reminder != null && reminder.status == ReminderStatus.active && reminder.notificationEnabled) {
          await scheduler.schedule(
            reminder: reminder,
            occurrence: occurrence,
          );
        }
      }
    }
  }

  Future<void> _handleTimezoneShift({
    required String newTz,
    required DateTime nowUtc,
  }) async {
    final allReminders = await repository.getAllReminders();

    for (final reminder in allReminders) {
      if (reminder.status != ReminderStatus.active) continue;

      final rule = await repository.getRecurrenceRule(reminder.id);
      if (rule == null) continue;

      // Update reminder's timezone location
      final updatedReminder = reminder.copyWith(
        timeZoneId: newTz,
        updatedAtUtc: nowUtc,
      );

      // Cancel obsolete pending occurrence
      final pending = await repository.getNextOccurrence(reminder.id);
      if (pending != null) {
        await scheduler.cancel(pending.notificationId);
        await repository.updateOccurrenceStatus(
          pending.id,
          OccurrenceStatus.cancelled,
        );
      }

      // Recalculate occurrence in new timezone
      final nextUtc = recurrenceEngine.calculateNextOccurrence(
        reminder: updatedReminder,
        rule: rule,
        afterUtc: nowUtc,
      );

      if (nextUtc != null) {
        final notifId = await _getNextNotificationId();
        tz.Location location;
        try {
          location = tz.getLocation(newTz);
        } catch (_) {
          location = tz.local;
        }

        final nextOccurrence = ReminderOccurrence(
          id: _uuid.v4(),
          reminderId: reminder.id,
          scheduleVersion: reminder.scheduleVersion,
          scheduledAtUtc: nextUtc,
          scheduledLocalDateTime: tz.TZDateTime.from(nextUtc, location),
          status: OccurrenceStatus.scheduled,
          notificationId: notifId,
          createdAtUtc: nowUtc,
          updatedAtUtc: nowUtc,
        );

        await repository.saveOccurrence(nextOccurrence);
        await repository.updateReminder(
          updatedReminder.copyWith(
            nextOccurrenceAtUtc: nextUtc,
            updatedAtUtc: nowUtc,
          ),
        );

        if (updatedReminder.notificationEnabled) {
          await scheduler.schedule(
            reminder: updatedReminder,
            occurrence: nextOccurrence,
          );
        }
      } else {
        await repository.updateReminder(
          updatedReminder.copyWith(
            clearNextOccurrence: true,
            updatedAtUtc: nowUtc,
          ),
        );
      }
    }
  }
}
