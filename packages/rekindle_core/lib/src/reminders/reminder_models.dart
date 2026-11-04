import 'package:meta/meta.dart';

enum ReminderStatus {
  active,
  paused,
  completed,
  cancelled,
}

enum ScheduleType {
  once,
  interval,
  weekly,
}

enum OccurrenceStatus {
  pending,
  scheduled,
  completed,
  skipped,
  cancelled,
  missed,
}

@immutable
final class Reminder {
  const Reminder({
    required this.id,
    required this.title,
    this.description,
    required this.status,
    required this.scheduleType,
    required this.startLocalDateTime,
    required this.timeZoneId,
    this.nextOccurrenceAtUtc,
    this.scheduleVersion = 1,
    this.notificationEnabled = true,
    this.linkedActivityId,
    required this.createdAtUtc,
    required this.updatedAtUtc,
  });

  final String id;
  final String title;
  final String? description;

  final ReminderStatus status;
  final ScheduleType scheduleType;

  final DateTime startLocalDateTime;
  final String timeZoneId;

  final DateTime? nextOccurrenceAtUtc;
  final int scheduleVersion;

  final bool notificationEnabled;
  final String? linkedActivityId;

  final DateTime createdAtUtc;
  final DateTime updatedAtUtc;

  Reminder copyWith({
    String? id,
    String? title,
    String? description,
    ReminderStatus? status,
    ScheduleType? scheduleType,
    DateTime? startLocalDateTime,
    String? timeZoneId,
    DateTime? nextOccurrenceAtUtc,
    bool clearNextOccurrence = false,
    int? scheduleVersion,
    bool? notificationEnabled,
    String? linkedActivityId,
    bool clearLinkedActivity = false,
    DateTime? createdAtUtc,
    DateTime? updatedAtUtc,
  }) {
    return Reminder(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      scheduleType: scheduleType ?? this.scheduleType,
      startLocalDateTime: startLocalDateTime ?? this.startLocalDateTime,
      timeZoneId: timeZoneId ?? this.timeZoneId,
      nextOccurrenceAtUtc: clearNextOccurrence ? null : (nextOccurrenceAtUtc ?? this.nextOccurrenceAtUtc),
      scheduleVersion: scheduleVersion ?? this.scheduleVersion,
      notificationEnabled: notificationEnabled ?? this.notificationEnabled,
      linkedActivityId: clearLinkedActivity ? null : (linkedActivityId ?? this.linkedActivityId),
      createdAtUtc: createdAtUtc ?? this.createdAtUtc,
      updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Reminder &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          scheduleVersion == other.scheduleVersion &&
          status == other.status &&
          nextOccurrenceAtUtc == other.nextOccurrenceAtUtc;

  @override
  int get hashCode => Object.hash(id, scheduleVersion, status, nextOccurrenceAtUtc);

  @override
  String toString() =>
      'Reminder(id: $id, title: $title, status: ${status.name}, scheduleVersion: $scheduleVersion, next: $nextOccurrenceAtUtc)';
}

@immutable
final class ReminderOccurrence {
  const ReminderOccurrence({
    required this.id,
    required this.reminderId,
    required this.scheduleVersion,
    required this.scheduledAtUtc,
    required this.scheduledLocalDateTime,
    required this.status,
    required this.notificationId,
    required this.createdAtUtc,
    required this.updatedAtUtc,
  });

  final String id;
  final String reminderId;
  final int scheduleVersion;

  final DateTime scheduledAtUtc;
  final DateTime scheduledLocalDateTime;

  final OccurrenceStatus status;
  final int notificationId;

  final DateTime createdAtUtc;
  final DateTime updatedAtUtc;

  ReminderOccurrence copyWith({
    String? id,
    String? reminderId,
    int? scheduleVersion,
    DateTime? scheduledAtUtc,
    DateTime? scheduledLocalDateTime,
    OccurrenceStatus? status,
    int? notificationId,
    DateTime? createdAtUtc,
    DateTime? updatedAtUtc,
  }) {
    return ReminderOccurrence(
      id: id ?? this.id,
      reminderId: reminderId ?? this.reminderId,
      scheduleVersion: scheduleVersion ?? this.scheduleVersion,
      scheduledAtUtc: scheduledAtUtc ?? this.scheduledAtUtc,
      scheduledLocalDateTime: scheduledLocalDateTime ?? this.scheduledLocalDateTime,
      status: status ?? this.status,
      notificationId: notificationId ?? this.notificationId,
      createdAtUtc: createdAtUtc ?? this.createdAtUtc,
      updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderOccurrence &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          status == other.status &&
          notificationId == other.notificationId;

  @override
  int get hashCode => Object.hash(id, status, notificationId);

  @override
  String toString() =>
      'ReminderOccurrence(id: $id, reminderId: $reminderId, v: $scheduleVersion, status: ${status.name}, utc: $scheduledAtUtc)';
}
