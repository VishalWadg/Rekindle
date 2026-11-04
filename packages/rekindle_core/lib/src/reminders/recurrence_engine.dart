import 'package:timezone/timezone.dart' as tz;
import 'recurrence_rules.dart';
import 'reminder_models.dart';

final class RecurrenceEngine {
  const RecurrenceEngine();

  /// Calculates the next occurrence timestamp in UTC strictly after [afterUtc].
  ///
  /// Returns `null` if no future occurrence exists (e.g. past one-time reminder).
  DateTime? calculateNextOccurrence({
    required Reminder reminder,
    required RecurrenceRule rule,
    required DateTime afterUtc,
    tz.Location? customLocation,
  }) {
    final location = customLocation ?? tz.getLocation(reminder.timeZoneId);
    final startUtc = _resolveLocalToUtc(reminder.startLocalDateTime, location);

    switch (rule) {
      case final OnceRule r:
        return _calculateOnce(r, afterUtc, startUtc, location);
      case final IntervalRule r:
        return _calculateInterval(r, afterUtc, startUtc);
      case final WeeklyRule r:
        return _calculateWeekly(r, afterUtc, startUtc, location);
    }
  }

  DateTime? _calculateOnce(
    OnceRule rule,
    DateTime afterUtc,
    DateTime startUtc,
    tz.Location location,
  ) {
    final scheduledUtc = _resolveLocalToUtc(rule.localDateTime, location);

    // One-time reminder must be in the future relative to afterUtc and at or after its start
    if (scheduledUtc.isAfter(afterUtc) && !scheduledUtc.isBefore(startUtc)) {
      return scheduledUtc;
    }
    return null;
  }

  DateTime? _calculateInterval(
    IntervalRule rule,
    DateTime afterUtc,
    DateTime startUtc,
  ) {
    final interval = rule.toDuration();
    if (interval.inSeconds <= 0) return null;

    if (startUtc.isAfter(afterUtc)) {
      return startUtc;
    }

    final elapsedMicros = afterUtc.difference(startUtc).inMicroseconds;
    final intervalMicros = interval.inMicroseconds;
    final steps = (elapsedMicros / intervalMicros).floor() + 1;

    return startUtc.add(interval * steps);
  }

  DateTime? _calculateWeekly(
    WeeklyRule rule,
    DateTime afterUtc,
    DateTime startUtc,
    tz.Location location,
  ) {
    if (rule.weekdays.isEmpty) return null;

    final afterLocal = tz.TZDateTime.from(afterUtc, location);

    // Search up to 14 days forward to find the next matching weekday
    for (var dayOffset = 0; dayOffset <= 14; dayOffset++) {
      final candidateDate = afterLocal.add(Duration(days: dayOffset));
      final weekday = candidateDate.weekday; // 1 (Mon) .. 7 (Sun)

      if (rule.weekdays.contains(weekday)) {
        final candidateLocal = _createSafeTzDateTime(
          location: location,
          year: candidateDate.year,
          month: candidateDate.month,
          day: candidateDate.day,
          hour: rule.localTime.hour,
          minute: rule.localTime.minute,
        );

        final candidateUtc = candidateLocal.toUtc();

        if (candidateUtc.isAfter(afterUtc) && !candidateUtc.isBefore(startUtc)) {
          return candidateUtc;
        }
      }
    }

    return null;
  }

  /// Converts a naive local DateTime to a UTC DateTime using the given timezone location.
  /// Handles DST gap and repeat transition safety.
  DateTime _resolveLocalToUtc(DateTime local, tz.Location location) {
    final tzDt = _createSafeTzDateTime(
      location: location,
      year: local.year,
      month: local.month,
      day: local.day,
      hour: local.hour,
      minute: local.minute,
      second: local.second,
      millisecond: local.millisecond,
    );
    return tzDt.toUtc();
  }

  /// Creates a TZDateTime safely handling DST:
  /// - Nonexistent local time (gap / spring forward): package:timezone adjusts forward to the next valid instant.
  /// - Repeated local time (fold / fall back): package:timezone defaults to the earlier valid transition instant.
  tz.TZDateTime _createSafeTzDateTime({
    required tz.Location location,
    required int year,
    required int month,
    required int day,
    required int hour,
    required int minute,
    int second = 0,
    int millisecond = 0,
  }) {
    try {
      return tz.TZDateTime(
        location,
        year,
        month,
        day,
        hour,
        minute,
        second,
        millisecond,
      );
    } catch (_) {
      // Fallback: construct in UTC and map to timezone
      final fallbackUtc = DateTime.utc(year, month, day, hour, minute, second, millisecond);
      return tz.TZDateTime.from(fallbackUtc, location);
    }
  }
}
