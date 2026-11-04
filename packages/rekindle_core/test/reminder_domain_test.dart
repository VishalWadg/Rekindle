import 'package:test/test.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:rekindle_core/rekindle_core.dart';

void main() {
  tz_data.initializeTimeZones();

  group('Domain Models & Invariants', () {
    test('Reminder copyWith and equality', () {
      final now = DateTime.utc(2026, 11, 4, 10, 0);
      final reminder = Reminder(
        id: 'rem-1',
        title: 'Read paper',
        description: 'Read attention paper',
        status: ReminderStatus.active,
        scheduleType: ScheduleType.once,
        startLocalDateTime: DateTime(2026, 11, 4, 15, 30),
        timeZoneId: 'UTC',
        nextOccurrenceAtUtc: DateTime.utc(2026, 11, 4, 15, 30),
        scheduleVersion: 1,
        notificationEnabled: true,
        linkedActivityId: 'act-1',
        createdAtUtc: now,
        updatedAtUtc: now,
      );

      expect(reminder.title, 'Read paper');
      expect(reminder.status, ReminderStatus.active);

      final paused = reminder.copyWith(
        status: ReminderStatus.paused,
        scheduleVersion: 2,
        clearNextOccurrence: true,
      );

      expect(paused.status, ReminderStatus.paused);
      expect(paused.scheduleVersion, 2);
      expect(paused.nextOccurrenceAtUtc, isNull);
      expect(paused.title, 'Read paper');
    });

    test('ReminderOccurrence copyWith and status transitions', () {
      final now = DateTime.utc(2026, 11, 4, 10, 0);
      final occurrence = ReminderOccurrence(
        id: 'occ-1',
        reminderId: 'rem-1',
        scheduleVersion: 1,
        scheduledAtUtc: DateTime.utc(2026, 11, 4, 15, 30),
        scheduledLocalDateTime: DateTime(2026, 11, 4, 15, 30),
        status: OccurrenceStatus.scheduled,
        notificationId: 1001,
        createdAtUtc: now,
        updatedAtUtc: now,
      );

      expect(occurrence.status, OccurrenceStatus.scheduled);

      final completed = occurrence.copyWith(status: OccurrenceStatus.completed);
      expect(completed.status, OccurrenceStatus.completed);
    });
  });

  group('RecurrenceRule Validation & Serialization', () {
    test('OnceRule serialization round-trip', () {
      final rule = OnceRule(DateTime(2026, 11, 10, 9, 30));
      final serialized = rule.toSerializedJson();

      final parsed = RecurrenceRule.fromJson(serialized);
      expect(parsed, isA<OnceRule>());
      expect((parsed as OnceRule).localDateTime, rule.localDateTime);
    });

    test('IntervalRule serialization round-trip and duration', () {
      const rule = IntervalRule(value: 2, unit: IntervalUnit.hours);
      expect(rule.toDuration(), const Duration(hours: 2));

      final serialized = rule.toSerializedJson();
      final parsed = RecurrenceRule.fromJson(serialized);
      expect(parsed, isA<IntervalRule>());
      final parsedInterval = parsed as IntervalRule;
      expect(parsedInterval.value, 2);
      expect(parsedInterval.unit, IntervalUnit.hours);
    });

    test('WeeklyRule serialization round-trip and validation', () {
      final rule = WeeklyRule(
        weekdays: {1, 3, 5},
        localTime: const ReminderTime(hour: 14, minute: 30),
      );

      final serialized = rule.toSerializedJson();
      final parsed = RecurrenceRule.fromJson(serialized);
      expect(parsed, isA<WeeklyRule>());
      final parsedWeekly = parsed as WeeklyRule;
      expect(parsedWeekly.weekdays, {1, 3, 5});
      expect(parsedWeekly.localTime.hour, 14);
      expect(parsedWeekly.localTime.minute, 30);
      expect(parsedWeekly.localTime.format(), '14:30');
    });

    test('Invalid rule parameters throw AssertionErrors', () {
      expect(
        () => IntervalRule(value: 0, unit: IntervalUnit.hours),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => WeeklyRule(weekdays: {}, localTime: const ReminderTime(hour: 9, minute: 0)),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => ReminderTime(hour: 25, minute: 0),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group('RecurrenceEngine Calculations', () {
    const engine = RecurrenceEngine();
    final utc = tz.getLocation('UTC');
    final ny = tz.getLocation('America/New_York');
    final kolkata = tz.getLocation('Asia/Kolkata');

    Reminder createReminder({
      required DateTime startLocal,
      required String timeZoneId,
    }) {
      return Reminder(
        id: 'rem-test',
        title: 'Test',
        status: ReminderStatus.active,
        scheduleType: ScheduleType.once,
        startLocalDateTime: startLocal,
        timeZoneId: timeZoneId,
        scheduleVersion: 1,
        notificationEnabled: true,
        createdAtUtc: DateTime.utc(2026, 1, 1),
        updatedAtUtc: DateTime.utc(2026, 1, 1),
      );
    }

    test('OnceRule: returns future date, null if past', () {
      final reminder = createReminder(
        startLocal: DateTime(2026, 11, 4, 12, 0),
        timeZoneId: 'UTC',
      );
      final rule = OnceRule(DateTime(2026, 11, 4, 12, 0));

      // Before scheduled date
      final next1 = engine.calculateNextOccurrence(
        reminder: reminder,
        rule: rule,
        afterUtc: DateTime.utc(2026, 11, 4, 10, 0),
        customLocation: utc,
      );
      expect(next1, DateTime.utc(2026, 11, 4, 12, 0));

      // After scheduled date
      final next2 = engine.calculateNextOccurrence(
        reminder: reminder,
        rule: rule,
        afterUtc: DateTime.utc(2026, 11, 4, 12, 0),
        customLocation: utc,
      );
      expect(next2, isNull);
    });

    test('IntervalRule: 2 elapsed hours steps forward cleanly', () {
      final reminder = createReminder(
        startLocal: DateTime(2026, 11, 4, 8, 0),
        timeZoneId: 'UTC',
      );
      const rule = IntervalRule(value: 2, unit: IntervalUnit.hours);

      // 1. Right at start -> returns start
      final first = engine.calculateNextOccurrence(
        reminder: reminder,
        rule: rule,
        afterUtc: DateTime.utc(2026, 11, 4, 7, 59),
        customLocation: utc,
      );
      expect(first, DateTime.utc(2026, 11, 4, 8, 0));

      // 2. Just after start -> returns start + 2h = 10:00
      final second = engine.calculateNextOccurrence(
        reminder: reminder,
        rule: rule,
        afterUtc: DateTime.utc(2026, 11, 4, 8, 0),
        customLocation: utc,
      );
      expect(second, DateTime.utc(2026, 11, 4, 10, 0));

      // 3. Jump forward 5 hours (at 13:30) -> next is 8:00 + 3*2h = 14:00
      final jumped = engine.calculateNextOccurrence(
        reminder: reminder,
        rule: rule,
        afterUtc: DateTime.utc(2026, 11, 4, 13, 30),
        customLocation: utc,
      );
      expect(jumped, DateTime.utc(2026, 11, 4, 14, 0));
    });

    test('WeeklyRule: picks next matching weekday and time', () {
      // 2026-11-04 is Wednesday (weekday 3)
      final reminder = createReminder(
        startLocal: DateTime(2026, 11, 4, 8, 0),
        timeZoneId: 'UTC',
      );

      // Every Wednesday and Friday at 15:00 UTC
      final rule = WeeklyRule(
        weekdays: {3, 5},
        localTime: const ReminderTime(hour: 15, minute: 0),
      );

      // On Wednesday 10:00 UTC -> next is today Wednesday 15:00 UTC
      final next1 = engine.calculateNextOccurrence(
        reminder: reminder,
        rule: rule,
        afterUtc: DateTime.utc(2026, 11, 4, 10, 0),
        customLocation: utc,
      );
      expect(next1, DateTime.utc(2026, 11, 4, 15, 0));

      // On Wednesday 15:00 UTC -> next is Friday 2026-11-06 15:00 UTC
      final next2 = engine.calculateNextOccurrence(
        reminder: reminder,
        rule: rule,
        afterUtc: DateTime.utc(2026, 11, 4, 15, 0),
        customLocation: utc,
      );
      expect(next2, DateTime.utc(2026, 11, 6, 15, 0));
    });

    test('Timezone DST transition (America/New_York Spring Forward gap safety)', () {
      // In America/New_York, DST starts 2026-03-08: 2:00 AM jumps to 3:00 AM.
      // 2:30 AM does not exist on that date.
      final reminder = createReminder(
        startLocal: DateTime(2026, 3, 1, 9, 0),
        timeZoneId: 'America/New_York',
      );

      // Weekly on Sunday at 2:30 AM
      final rule = WeeklyRule(
        weekdays: {DateTime.sunday},
        localTime: const ReminderTime(hour: 2, minute: 30),
      );

      final next = engine.calculateNextOccurrence(
        reminder: reminder,
        rule: rule,
        afterUtc: DateTime.utc(2026, 3, 7, 12, 0),
        customLocation: ny,
      );

      expect(next, isNotNull);
      // Verify result converts cleanly back to New York local time without crashing
      final localResult = tz.TZDateTime.from(next!, ny);
      expect(localResult.day, 8);
      expect(localResult.month, 3);
      expect(localResult.year, 2026);
    });

    test('Fixed timezone without DST (Asia/Kolkata)', () {
      final reminder = createReminder(
        startLocal: DateTime(2026, 11, 4, 7, 0),
        timeZoneId: 'Asia/Kolkata',
      );

      // Daily at 07:00 IST (01:30 UTC)
      final rule = WeeklyRule(
        weekdays: {1, 2, 3, 4, 5, 6, 7},
        localTime: const ReminderTime(hour: 7, minute: 0),
      );

      // Current time is 2026-11-04 05:00 IST (2026-11-03 23:30 UTC)
      final next = engine.calculateNextOccurrence(
        reminder: reminder,
        rule: rule,
        afterUtc: DateTime.utc(2026, 11, 3, 23, 30),
        customLocation: kolkata,
      );

      expect(next, DateTime.utc(2026, 11, 4, 1, 30));
    });
  });
}
