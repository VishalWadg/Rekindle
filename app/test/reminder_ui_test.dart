import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rekindle_app/app/providers.dart';
import 'package:rekindle_app/features/reminders/reminder_form_screen.dart';
import 'package:rekindle_app/features/reminders/reminder_scheduler.dart';
import 'package:rekindle_app/features/reminders/reminders_list_screen.dart';
import 'package:rekindle_core/rekindle_core.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class FakeLocalNotificationScheduler implements LocalNotificationScheduler {
  @override
  Future<bool> requestPermission() async => true;

  @override
  Future<void> schedule({
    required Reminder reminder,
    required ReminderOccurrence occurrence,
  }) async {}

  @override
  Future<void> cancel(int notificationId) async {}

  @override
  Future<List<int>> getPendingNotificationIds() async => [];

  @override
  Future<void> cancelAll() async {}
}

void main() {
  tz_data.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('UTC'));

  late AppDatabase db;
  late DriftReminderRepository repository;
  late FakeLocalNotificationScheduler scheduler;

  setUp(() {
    db = AppDatabase(
      NativeDatabase.memory(
        setup: (rawDb) {
          rawDb.execute('PRAGMA foreign_keys = ON;');
        },
      ),
    );
    repository = DriftReminderRepository(db);
    scheduler = FakeLocalNotificationScheduler();
  });

  tearDown(() async {
    await db.close();
  });

  Widget createWidgetUnderTest(
    Widget child, {
    List<Reminder> initialReminders = const [],
  }) {
    return ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        reminderRepositoryProvider.overrideWithValue(repository),
        reminderSchedulerProvider.overrideWithValue(scheduler),
        remindersStreamProvider.overrideWith(
          (ref) => Stream.value(initialReminders),
        ),
      ],
      child: MaterialApp(
        home: child,
      ),
    );
  }

  group('Reminder UI Widget Tests', () {
    testWidgets('RemindersListScreen renders empty state when database is empty', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(const RemindersListScreen()));
      await tester.pumpAndSettle();

      expect(find.text('reminders'), findsOneWidget);
      expect(find.text('No reminders scheduled yet'), findsOneWidget);
      expect(find.text('Schedule a reminder'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('RemindersListScreen renders cards for active reminders', (tester) async {
      final now = DateTime.utc(2026, 11, 4, 12, 0);
      final reminder = Reminder(
        id: 'rem-card-1',
        title: 'Review Quantum Mechanics',
        description: 'Schrodinger equation derivation',
        status: ReminderStatus.active,
        scheduleType: ScheduleType.once,
        startLocalDateTime: now,
        timeZoneId: 'UTC',
        createdAtUtc: now,
        updatedAtUtc: now,
      );

      await repository.saveReminder(
        reminder: reminder,
        rule: OnceRule(now),
      );

      await tester.pumpWidget(createWidgetUnderTest(
        const RemindersListScreen(),
        initialReminders: [reminder],
      ));
      await tester.pumpAndSettle();

      expect(find.text('Review Quantum Mechanics'), findsOneWidget);
      expect(find.text('Schrodinger equation derivation'), findsOneWidget);
      expect(find.text('Active'), findsOneWidget);
    });

    testWidgets('ReminderFormScreen renders title field, cadence selector, and validates', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(const ReminderFormScreen()));
      await tester.pumpAndSettle();

      expect(find.text('new reminder'), findsOneWidget);
      expect(find.text('Title *'), findsOneWidget);
      expect(find.text('CADENCE'), findsOneWidget);
      expect(find.text('Interval'), findsOneWidget);
      expect(find.text('Weekly'), findsOneWidget);
      expect(find.text('Once'), findsOneWidget);

      // Scroll down to reveal button and tap submit with empty title to verify validation message
      await tester.drag(find.byType(ListView), const Offset(0, -600));
      await tester.pumpAndSettle();

      final buttonFinder = find.text('Create Reminder');
      expect(buttonFinder, findsOneWidget);
      await tester.tap(buttonFinder);
      await tester.pumpAndSettle();

      // Scroll back up to inspect the title field validation error
      await tester.drag(find.byType(ListView), const Offset(0, 600));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a reminder title'), findsOneWidget);
    });
  });
}
