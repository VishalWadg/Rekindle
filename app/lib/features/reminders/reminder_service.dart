import 'package:rekindle_core/rekindle_core.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:uuid/uuid.dart';
import 'reminder_scheduler.dart';

/// Application service orchestrating reminder CRUD, lifecycle transitions,
/// recurrence progression, and platform notification dispatch.
class ReminderService {
  ReminderService({
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

  /// Creates a new reminder, calculates its initial occurrence, persists both in Drift,
  /// and schedules the local OS notification alarm.
  Future<Reminder> createReminder({
    required String title,
    String? description,
    required ScheduleType scheduleType,
    required DateTime startLocalDateTime,
    required String timeZoneId,
    required RecurrenceRule rule,
    String? linkedActivityId,
    bool notificationEnabled = true,
  }) async {
    final nowUtc = DateTime.now().toUtc();
    final reminderId = _uuid.v4();

    final reminderSkeleton = Reminder(
      id: reminderId,
      title: title.trim(),
      description: description?.trim().isEmpty == true ? null : description?.trim(),
      status: ReminderStatus.active,
      scheduleType: scheduleType,
      startLocalDateTime: startLocalDateTime,
      timeZoneId: timeZoneId,
      scheduleVersion: 1,
      notificationEnabled: notificationEnabled,
      linkedActivityId: linkedActivityId,
      createdAtUtc: nowUtc,
      updatedAtUtc: nowUtc,
    );

    final nextOccurrenceUtc = recurrenceEngine.calculateNextOccurrence(
      reminder: reminderSkeleton,
      rule: rule,
      afterUtc: nowUtc,
    );

    final reminder = reminderSkeleton.copyWith(
      nextOccurrenceAtUtc: nextOccurrenceUtc,
    );

    ReminderOccurrence? occurrence;
    if (nextOccurrenceUtc != null) {
      final notifId = await _getNextNotificationId();
      tz.Location location;
      try {
        location = tz.getLocation(timeZoneId);
      } catch (_) {
        location = tz.local;
      }
      final localScheduled = tz.TZDateTime.from(nextOccurrenceUtc, location);

      occurrence = ReminderOccurrence(
        id: _uuid.v4(),
        reminderId: reminderId,
        scheduleVersion: 1,
        scheduledAtUtc: nextOccurrenceUtc,
        scheduledLocalDateTime: localScheduled,
        status: OccurrenceStatus.scheduled,
        notificationId: notifId,
        createdAtUtc: nowUtc,
        updatedAtUtc: nowUtc,
      );
    }

    await repository.saveReminder(
      reminder: reminder,
      rule: rule,
      initialOccurrence: occurrence,
    );

    if (notificationEnabled && occurrence != null) {
      await scheduler.schedule(
        reminder: reminder,
        occurrence: occurrence,
      );
    }

    return reminder;
  }

  /// Updates a reminder and its recurrence rule, cancelling obsolete alarms
  /// and scheduling the newly calculated occurrence.
  Future<void> updateReminder({
    required Reminder reminder,
    required RecurrenceRule rule,
  }) async {
    final nowUtc = DateTime.now().toUtc();

    // Cancel pending notification for previous occurrence
    final currentPending = await repository.getNextOccurrence(reminder.id);
    if (currentPending != null) {
      await scheduler.cancel(currentPending.notificationId);
      await repository.updateOccurrenceStatus(
        currentPending.id,
        OccurrenceStatus.cancelled,
      );
    }

    final newScheduleVersion = reminder.scheduleVersion + 1;
    final updatedSkeleton = reminder.copyWith(
      scheduleVersion: newScheduleVersion,
      updatedAtUtc: nowUtc,
    );

    final nextOccurrenceUtc = recurrenceEngine.calculateNextOccurrence(
      reminder: updatedSkeleton,
      rule: rule,
      afterUtc: nowUtc,
    );

    final finalReminder = updatedSkeleton.copyWith(
      nextOccurrenceAtUtc: nextOccurrenceUtc,
      clearNextOccurrence: nextOccurrenceUtc == null,
    );

    ReminderOccurrence? occurrence;
    if (nextOccurrenceUtc != null) {
      final notifId = await _getNextNotificationId();
      tz.Location location;
      try {
        location = tz.getLocation(finalReminder.timeZoneId);
      } catch (_) {
        location = tz.local;
      }
      final localScheduled = tz.TZDateTime.from(nextOccurrenceUtc, location);

      occurrence = ReminderOccurrence(
        id: _uuid.v4(),
        reminderId: finalReminder.id,
        scheduleVersion: newScheduleVersion,
        scheduledAtUtc: nextOccurrenceUtc,
        scheduledLocalDateTime: localScheduled,
        status: OccurrenceStatus.scheduled,
        notificationId: notifId,
        createdAtUtc: nowUtc,
        updatedAtUtc: nowUtc,
      );
    }

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
  }

  /// Pauses a reminder, cancelling pending alarms and marking occurrences cancelled.
  Future<void> pauseReminder(String reminderId) async {
    final reminder = await repository.getReminder(reminderId);
    if (reminder == null || reminder.status == ReminderStatus.paused) return;

    final pending = await repository.getNextOccurrence(reminderId);
    if (pending != null) {
      await scheduler.cancel(pending.notificationId);
      await repository.updateOccurrenceStatus(
        pending.id,
        OccurrenceStatus.cancelled,
      );
    }

    final updated = reminder.copyWith(
      status: ReminderStatus.paused,
      clearNextOccurrence: true,
      updatedAtUtc: DateTime.now().toUtc(),
    );
    await repository.updateReminder(updated);
  }

  /// Resumes a paused reminder, calculating and scheduling its next occurrence.
  Future<void> resumeReminder(String reminderId) async {
    final reminder = await repository.getReminder(reminderId);
    final rule = await repository.getRecurrenceRule(reminderId);
    if (reminder == null || rule == null || reminder.status == ReminderStatus.active) return;

    final nowUtc = DateTime.now().toUtc();
    final nextOccurrenceUtc = recurrenceEngine.calculateNextOccurrence(
      reminder: reminder,
      rule: rule,
      afterUtc: nowUtc,
    );

    ReminderOccurrence? occurrence;
    if (nextOccurrenceUtc != null) {
      final notifId = await _getNextNotificationId();
      tz.Location location;
      try {
        location = tz.getLocation(reminder.timeZoneId);
      } catch (_) {
        location = tz.local;
      }
      final localScheduled = tz.TZDateTime.from(nextOccurrenceUtc, location);

      occurrence = ReminderOccurrence(
        id: _uuid.v4(),
        reminderId: reminderId,
        scheduleVersion: reminder.scheduleVersion,
        scheduledAtUtc: nextOccurrenceUtc,
        scheduledLocalDateTime: localScheduled,
        status: OccurrenceStatus.scheduled,
        notificationId: notifId,
        createdAtUtc: nowUtc,
        updatedAtUtc: nowUtc,
      );

      await repository.saveOccurrence(occurrence);

      if (reminder.notificationEnabled) {
        await scheduler.schedule(
          reminder: reminder,
          occurrence: occurrence,
        );
      }
    }

    final updated = reminder.copyWith(
      status: ReminderStatus.active,
      nextOccurrenceAtUtc: nextOccurrenceUtc,
      clearNextOccurrence: nextOccurrenceUtc == null,
      updatedAtUtc: nowUtc,
    );
    await repository.updateReminder(updated);
  }

  /// Deletes a reminder, cancelling OS alarms and relying on Drift SQLite cascade deletion.
  Future<void> deleteReminder(String reminderId) async {
    final pending = await repository.getNextOccurrence(reminderId);
    if (pending != null) {
      await scheduler.cancel(pending.notificationId);
    }
    await repository.deleteReminder(reminderId);
  }

  /// Marks an occurrence completed, and advances recurring schedules to the next occurrence.
  Future<void> completeOccurrence(String occurrenceId) async {
    final occurrence = await repository.getOccurrence(occurrenceId);
    if (occurrence == null) return;

    final nowUtc = DateTime.now().toUtc();
    await repository.updateOccurrenceStatus(occurrenceId, OccurrenceStatus.completed);
    await scheduler.cancel(occurrence.notificationId);

    final reminder = await repository.getReminder(occurrence.reminderId);
    final rule = await repository.getRecurrenceRule(occurrence.reminderId);
    if (reminder == null || rule == null) return;

    if (reminder.scheduleType == ScheduleType.once) {
      await repository.updateReminder(
        reminder.copyWith(
          status: ReminderStatus.completed,
          clearNextOccurrence: true,
          updatedAtUtc: nowUtc,
        ),
      );
      return;
    }

    // Advance recurring rule
    final afterInstant = occurrence.scheduledAtUtc.isAfter(nowUtc)
        ? occurrence.scheduledAtUtc
        : nowUtc;
    final nextOccurrenceUtc = recurrenceEngine.calculateNextOccurrence(
      reminder: reminder,
      rule: rule,
      afterUtc: afterInstant,
    );

    if (nextOccurrenceUtc != null) {
      final notifId = await _getNextNotificationId();
      tz.Location location;
      try {
        location = tz.getLocation(reminder.timeZoneId);
      } catch (_) {
        location = tz.local;
      }
      final localScheduled = tz.TZDateTime.from(nextOccurrenceUtc, location);

      final nextOccurrence = ReminderOccurrence(
        id: _uuid.v4(),
        reminderId: reminder.id,
        scheduleVersion: reminder.scheduleVersion,
        scheduledAtUtc: nextOccurrenceUtc,
        scheduledLocalDateTime: localScheduled,
        status: OccurrenceStatus.scheduled,
        notificationId: notifId,
        createdAtUtc: nowUtc,
        updatedAtUtc: nowUtc,
      );

      await repository.saveOccurrence(nextOccurrence);
      await repository.updateReminder(
        reminder.copyWith(
          nextOccurrenceAtUtc: nextOccurrenceUtc,
          updatedAtUtc: nowUtc,
        ),
      );

      if (reminder.notificationEnabled) {
        await scheduler.schedule(
          reminder: reminder,
          occurrence: nextOccurrence,
        );
      }
    } else {
      await repository.updateReminder(
        reminder.copyWith(
          status: ReminderStatus.completed,
          clearNextOccurrence: true,
          updatedAtUtc: nowUtc,
        ),
      );
    }
  }

  /// Marks an occurrence skipped and advances recurring schedules.
  Future<void> skipOccurrence(String occurrenceId) async {
    final occurrence = await repository.getOccurrence(occurrenceId);
    if (occurrence == null) return;

    final nowUtc = DateTime.now().toUtc();
    await repository.updateOccurrenceStatus(occurrenceId, OccurrenceStatus.skipped);
    await scheduler.cancel(occurrence.notificationId);

    final reminder = await repository.getReminder(occurrence.reminderId);
    final rule = await repository.getRecurrenceRule(occurrence.reminderId);
    if (reminder == null || rule == null) return;

    if (reminder.scheduleType == ScheduleType.once) {
      await repository.updateReminder(
        reminder.copyWith(
          status: ReminderStatus.completed,
          clearNextOccurrence: true,
          updatedAtUtc: nowUtc,
        ),
      );
      return;
    }

    final afterInstant = occurrence.scheduledAtUtc.isAfter(nowUtc)
        ? occurrence.scheduledAtUtc
        : nowUtc;
    final nextOccurrenceUtc = recurrenceEngine.calculateNextOccurrence(
      reminder: reminder,
      rule: rule,
      afterUtc: afterInstant,
    );

    if (nextOccurrenceUtc != null) {
      final notifId = await _getNextNotificationId();
      tz.Location location;
      try {
        location = tz.getLocation(reminder.timeZoneId);
      } catch (_) {
        location = tz.local;
      }
      final localScheduled = tz.TZDateTime.from(nextOccurrenceUtc, location);

      final nextOccurrence = ReminderOccurrence(
        id: _uuid.v4(),
        reminderId: reminder.id,
        scheduleVersion: reminder.scheduleVersion,
        scheduledAtUtc: nextOccurrenceUtc,
        scheduledLocalDateTime: localScheduled,
        status: OccurrenceStatus.scheduled,
        notificationId: notifId,
        createdAtUtc: nowUtc,
        updatedAtUtc: nowUtc,
      );

      await repository.saveOccurrence(nextOccurrence);
      await repository.updateReminder(
        reminder.copyWith(
          nextOccurrenceAtUtc: nextOccurrenceUtc,
          updatedAtUtc: nowUtc,
        ),
      );

      if (reminder.notificationEnabled) {
        await scheduler.schedule(
          reminder: reminder,
          occurrence: nextOccurrence,
        );
      }
    } else {
      await repository.updateReminder(
        reminder.copyWith(
          status: ReminderStatus.completed,
          clearNextOccurrence: true,
          updatedAtUtc: nowUtc,
        ),
      );
    }
  }
}
