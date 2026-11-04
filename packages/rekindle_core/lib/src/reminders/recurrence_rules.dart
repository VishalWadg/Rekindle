import 'dart:convert';
import 'package:meta/meta.dart';
import 'reminder_models.dart';

enum IntervalUnit {
  minutes,
  hours,
  days,
  weeks,
}

@immutable
final class ReminderTime {
  const ReminderTime({required this.hour, required this.minute})
      : assert(hour >= 0 && hour <= 23, 'Hour must be between 0 and 23'),
        assert(minute >= 0 && minute <= 59, 'Minute must be between 0 and 59');

  final int hour;
  final int minute;

  Map<String, dynamic> toJson() => {
        'hour': hour,
        'minute': minute,
      };

  factory ReminderTime.fromJson(Map<String, dynamic> json) => ReminderTime(
        hour: json['hour'] as int,
        minute: json['minute'] as int,
      );

  String format() {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderTime && runtimeType == other.runtimeType && hour == other.hour && minute == other.minute;

  @override
  int get hashCode => Object.hash(hour, minute);

  @override
  String toString() => format();
}

sealed class RecurrenceRule {
  const RecurrenceRule();

  ScheduleType get scheduleType {
    switch (this) {
      case OnceRule():
        return ScheduleType.once;
      case IntervalRule():
        return ScheduleType.interval;
      case WeeklyRule():
        return ScheduleType.weekly;
    }
  }

  Map<String, dynamic> toJson();

  static RecurrenceRule fromJson(String jsonString) {
    final data = jsonDecode(jsonString) as Map<String, dynamic>;
    final type = data['rule_type'] as String;
    final config = data['config'] as Map<String, dynamic>;

    switch (type) {
      case 'ONCE':
        return OnceRule(DateTime.parse(config['local_date_time'] as String));
      case 'INTERVAL':
        return IntervalRule(
          value: config['value'] as int,
          unit: IntervalUnit.values.byName(config['unit'] as String),
        );
      case 'WEEKLY':
        final days = (config['weekdays'] as List).cast<int>().toSet();
        final timeMap = config['local_time'] as Map<String, dynamic>;
        return WeeklyRule(
          weekdays: days,
          localTime: ReminderTime.fromJson(timeMap),
        );
      default:
        throw ArgumentError.value(type, 'rule_type', 'Unsupported recurrence rule type');
    }
  }

  String toSerializedJson({int schemaVersion = 1}) {
    String ruleType;
    Map<String, dynamic> config;

    switch (this) {
      case final OnceRule r:
        ruleType = 'ONCE';
        config = {'local_date_time': r.localDateTime.toIso8601String()};
      case final IntervalRule r:
        ruleType = 'INTERVAL';
        config = {'value': r.value, 'unit': r.unit.name};
      case final WeeklyRule r:
        ruleType = 'WEEKLY';
        config = {
          'weekdays': r.weekdays.toList()..sort(),
          'local_time': r.localTime.toJson(),
        };
    }

    return jsonEncode({
      'schema_version': schemaVersion,
      'rule_type': ruleType,
      'config': config,
    });
  }
}

final class OnceRule extends RecurrenceRule {
  const OnceRule(this.localDateTime);

  final DateTime localDateTime;

  @override
  Map<String, dynamic> toJson() => {
        'local_date_time': localDateTime.toIso8601String(),
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OnceRule && runtimeType == other.runtimeType && localDateTime == other.localDateTime;

  @override
  int get hashCode => localDateTime.hashCode;

  @override
  String toString() => 'OnceRule($localDateTime)';
}

final class IntervalRule extends RecurrenceRule {
  const IntervalRule({
    required this.value,
    required this.unit,
  }) : assert(value > 0, 'Interval value must be positive');

  final int value;
  final IntervalUnit unit;

  Duration toDuration() {
    switch (unit) {
      case IntervalUnit.minutes:
        return Duration(minutes: value);
      case IntervalUnit.hours:
        return Duration(hours: value);
      case IntervalUnit.days:
        return Duration(days: value);
      case IntervalUnit.weeks:
        return Duration(days: value * 7);
    }
  }

  @override
  Map<String, dynamic> toJson() => {
        'value': value,
        'unit': unit.name,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IntervalRule && runtimeType == other.runtimeType && value == other.value && unit == other.unit;

  @override
  int get hashCode => Object.hash(value, unit);

  @override
  String toString() => 'IntervalRule(every $value ${unit.name})';
}

final class WeeklyRule extends RecurrenceRule {
  WeeklyRule({
    required this.weekdays,
    required this.localTime,
  })  : assert(weekdays.isNotEmpty, 'Must select at least one weekday'),
        assert(weekdays.every((d) => d >= 1 && d <= 7), 'Weekdays must be 1 (Monday) through 7 (Sunday)');

  final Set<int> weekdays;
  final ReminderTime localTime;

  @override
  Map<String, dynamic> toJson() => {
        'weekdays': weekdays.toList()..sort(),
        'local_time': localTime.toJson(),
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeeklyRule &&
          runtimeType == other.runtimeType &&
          localTime == other.localTime &&
          weekdays.length == other.weekdays.length &&
          weekdays.containsAll(other.weekdays);

  @override
  int get hashCode => Object.hash(Object.hashAll(weekdays.toList()..sort()), localTime);

  @override
  String toString() => 'WeeklyRule(days: $weekdays at $localTime)';
}
