import 'dart:io';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:rekindle_core/rekindle_core.dart';
import '../features/nudges/local_notification_gateway.dart';
import '../features/reminders/reminder_scheduler.dart';
import '../features/reminders/reminder_service.dart';
import '../features/reminders/reminder_reconciliation_service.dart';
import '../features/reminders/reminder_portability_service.dart';

/// Database provider providing singleton AppDatabase instance.
final databaseProvider = Provider<AppDatabase>((ref) {
  final executor = LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'rekindle.sqlite'));
    return NativeDatabase.createInBackground(
      file,
      setup: (rawDb) {
        rawDb.execute('PRAGMA foreign_keys = ON;');
        rawDb.execute('PRAGMA journal_mode = WAL;');
        rawDb.execute('PRAGMA synchronous = NORMAL;');
        rawDb.execute('PRAGMA busy_timeout = 5000;');
      },
    );
  });

  final db = AppDatabase(executor);
  ref.onDispose(() => db.close());
  return db;
});

/// Interest selector provider.
final interestSelectorProvider = Provider<InterestSelector>((ref) {
  return ThompsonInterestSelector(BetaSampler(Random()));
});

/// Notification gateway provider.
final notificationGatewayProvider = Provider<NotificationGateway>((ref) {
  return LocalNotificationGateway.instance;
});

/// Nudge planner provider.
final nudgePlannerProvider = Provider<NudgePlanner>((ref) {
  final db = ref.watch(databaseProvider);
  final selector = ref.watch(interestSelectorProvider);
  final gateway = ref.watch(notificationGatewayProvider);
  return NudgePlanner(
    db: db,
    selector: selector,
    gateway: gateway,
  );
});

/// Surface service provider.
final surfaceServiceProvider = Provider<SurfaceService>((ref) {
  final db = ref.watch(databaseProvider);
  final selector = ref.watch(interestSelectorProvider);
  return SurfaceService(db: db, selector: selector);
});

/// Response service provider.
final responseServiceProvider = Provider<ResponseService>((ref) {
  final db = ref.watch(databaseProvider);
  return ResponseService(db: db);
});

/// Onboarding service provider.
final onboardingServiceProvider = Provider<OnboardingService>((ref) {
  final db = ref.watch(databaseProvider);
  return OnboardingService(db: db);
});

/// Watch whether onboarding is completed.
final onboardingCompletedProvider = StreamProvider<bool>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.appStates)..where((tbl) => tbl.id.equals(1)))
      .watchSingleOrNull()
      .map((state) => state?.onboardingCompletedAt != null);
});

/// Watch non-archived interests stream.
final interestsStreamProvider = StreamProvider<List<InterestsTableData>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.interestsTable)..where((tbl) => tbl.archivedAt.isNull())).watch();
});

/// Reminder repository provider.
final reminderRepositoryProvider = Provider<ReminderRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return DriftReminderRepository(db);
});

/// Reminder scheduler provider.
final reminderSchedulerProvider = Provider<LocalNotificationScheduler>((ref) {
  return FlutterLocalNotificationScheduler();
});

/// Watch all reminders stream.
final remindersStreamProvider = StreamProvider<List<Reminder>>((ref) {
  final repository = ref.watch(reminderRepositoryProvider);
  return repository.watchAllReminders();
});

/// Reminder service provider.
final reminderServiceProvider = Provider<ReminderService>((ref) {
  final repository = ref.watch(reminderRepositoryProvider);
  final scheduler = ref.watch(reminderSchedulerProvider);
  return ReminderService(
    repository: repository,
    scheduler: scheduler,
  );
});

/// Reminder reconciliation service provider.
final reminderReconciliationServiceProvider =
    Provider<ReminderReconciliationService>((ref) {
  final repository = ref.watch(reminderRepositoryProvider);
  final scheduler = ref.watch(reminderSchedulerProvider);
  return ReminderReconciliationService(
    repository: repository,
    scheduler: scheduler,
  );
});

/// Reminder data portability service provider.
final reminderPortabilityServiceProvider =
    Provider<ReminderPortabilityService>((ref) {
  final repository = ref.watch(reminderRepositoryProvider);
  final scheduler = ref.watch(reminderSchedulerProvider);
  return ReminderPortabilityService(
    repository: repository,
    scheduler: scheduler,
  );
});
