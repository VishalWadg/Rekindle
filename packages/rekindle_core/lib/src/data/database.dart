import 'package:drift/drift.dart';

part 'database.g.dart';

class AppStates extends Table {
  IntColumn get id => integer().withDefault(const Constant(1)).customConstraint('NOT NULL CHECK (id = 1)')();
  IntColumn get installSeed => integer()();
  TextColumn get timezone => text()();
  DateTimeColumn get onboardingCompletedAt => dateTime().nullable()();
  DateTimeColumn get lastSeenAt => dateTime().nullable()();
  TextColumn get notificationPermission => text().withDefault(const Constant('UNKNOWN'))();
  DateTimeColumn get permissionReaskDueAt => dateTime().nullable()();
  BoolColumn get quietCardPending => boolean().withDefault(const Constant(false))();
  BoolColumn get insightsEnabled => boolean().withDefault(const Constant(true))();
  DateTimeColumn get plannerLastRunAt => dateTime().nullable()();
  TextColumn get appVersion => text().withDefault(const Constant('0.2.0'))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class NotificationSettingsTable extends Table {
  IntColumn get id => integer().withDefault(const Constant(1)).customConstraint('NOT NULL CHECK (id = 1)')();
  TextColumn get level => text().withDefault(const Constant('GENTLE'))();
  IntColumn get windows => integer().withDefault(const Constant(5))(); // morning(1) + evening(4) = 5
  TextColumn get voice => text().withDefault(const Constant('CALM'))();
  BoolColumn get showTextOnLockScreen => boolean().withDefault(const Constant(false))();
  DateTimeColumn get pausedUntil => dateTime().nullable()();
  IntColumn get consecutiveIgnored => integer().withDefault(const Constant(0))();
  IntColumn get backoffStep => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastNudgeAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class InterestsTable extends Table {
  TextColumn get id => text()(); // UUIDv4
  TextColumn get name => text().withLength(min: 1, max: 60)();
  TextColumn get nameKey => text().customConstraint('NOT NULL UNIQUE')();
  RealColumn get alpha => real().withDefault(const Constant(1.0))();
  RealColumn get beta => real().withDefault(const Constant(1.0))();
  DateTimeColumn get pushCooldownUntil => dateTime().nullable()();
  DateTimeColumn get archivedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class SnippetsTable extends Table {
  TextColumn get id => text()(); // UUIDv4
  TextColumn get interestId => text().customConstraint('NOT NULL REFERENCES interests_table(id) ON DELETE CASCADE')();
  TextColumn get content => text().customConstraint('NOT NULL CHECK (length(content) BETWEEN 1 AND 1000)')();
  TextColumn get source => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class ExposuresTable extends Table {
  TextColumn get id => text()(); // UUIDv4
  TextColumn get interestId => text().customConstraint('NOT NULL REFERENCES interests_table(id) ON DELETE CASCADE')();
  TextColumn get snippetId => text().nullable().customConstraint('REFERENCES snippets_table(id) ON DELETE SET NULL')();
  TextColumn get altInterestId => text().nullable()();
  TextColumn get kind => text()();
  TextColumn get templateCode => text()();
  TextColumn get copyVariant => text()();
  TextColumn get voice => text()();
  TextColumn get channel => text()();
  IntColumn get notificationId => integer().nullable()();
  DateTimeColumn get scheduledFor => dateTime().nullable()();
  DateTimeColumn get surfacedAt => dateTime()();
  DateTimeColumn get expiresAt => dateTime().nullable()();
  DateTimeColumn get deliveredAt => dateTime().nullable()();
  DateTimeColumn get respondedAt => dateTime().nullable()();
  TextColumn get reaction => text().withDefault(const Constant('NONE'))();
  TextColumn get respondedVia => text().nullable()();
  TextColumn get responseText => text().nullable()();
  TextColumn get planReason => text().nullable()(); // JSON

  @override
  Set<Column> get primaryKey => {id};
}

class AnalyticsEventsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get ts => dateTime()();
  TextColumn get localDate => text()();
  IntColumn get localHour => integer()();
  TextColumn get type => text()();
  TextColumn get exposureId => text().nullable()();
  TextColumn get interestId => text().nullable()();
  TextColumn get props => text().nullable()(); // JSON <= 512 bytes
}

class AnalyticsDailyTable extends Table {
  TextColumn get localDate => text()();
  TextColumn get metric => text()();
  TextColumn get dimension => text()();
  RealColumn get value => real()();

  @override
  Set<Column> get primaryKey => {localDate, metric, dimension};
}

class ErrorLogsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get ts => dateTime()();
  TextColumn get source => text()();
  TextColumn get message => text().withLength(max: 200)();
  TextColumn get stack => text().nullable().withLength(max: 4096)();
}

class RemindersTable extends Table {
  @override
  String get tableName => 'reminders';

  TextColumn get id => text()(); // UUIDv4
  TextColumn get title => text().withLength(min: 1, max: 200)();
  TextColumn get description => text().nullable()();
  TextColumn get status => text()(); // active, paused, completed, cancelled
  TextColumn get scheduleType => text()(); // once, interval, weekly
  DateTimeColumn get startLocal => dateTime()();
  TextColumn get timezoneId => text()();
  DateTimeColumn get nextOccurrenceUtc => dateTime().nullable()();
  IntColumn get scheduleVersion => integer().withDefault(const Constant(1))();
  BoolColumn get notificationEnabled => boolean().withDefault(const Constant(true))();
  TextColumn get linkedActivityId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class RecurrenceRulesTable extends Table {
  @override
  String get tableName => 'recurrence_rules';

  TextColumn get id => text()(); // UUIDv4
  TextColumn get reminderId => text().customConstraint('NOT NULL REFERENCES reminders(id) ON DELETE CASCADE')();
  TextColumn get ruleType => text()(); // once, interval, weekly
  TextColumn get configJson => text()();
  IntColumn get schemaVersion => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

class ReminderOccurrencesTable extends Table {
  @override
  String get tableName => 'reminder_occurrences';

  TextColumn get id => text()(); // UUIDv4
  TextColumn get reminderId => text().customConstraint('NOT NULL REFERENCES reminders(id) ON DELETE CASCADE')();
  IntColumn get scheduleVersion => integer()();
  DateTimeColumn get scheduledAtUtc => dateTime()();
  DateTimeColumn get scheduledLocal => dateTime()();
  TextColumn get status => text()(); // pending, scheduled, completed, skipped, cancelled, missed
  IntColumn get notificationId => integer()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {reminderId, scheduleVersion, scheduledAtUtc},
  ];
}

class ReminderSettingsTable extends Table {
  @override
  String get tableName => 'reminder_settings';

  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

@DriftDatabase(tables: [
  AppStates,
  NotificationSettingsTable,
  InterestsTable,
  SnippetsTable,
  ExposuresTable,
  AnalyticsEventsTable,
  AnalyticsDailyTable,
  ErrorLogsTable,
  RemindersTable,
  RecurrenceRulesTable,
  ReminderOccurrencesTable,
  ReminderSettingsTable,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON;');
      await customStatement('PRAGMA busy_timeout = 5000;');
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(remindersTable);
        await m.createTable(recurrenceRulesTable);
        await m.createTable(reminderOccurrencesTable);
        await m.createTable(reminderSettingsTable);

        await customStatement('CREATE INDEX IF NOT EXISTS idx_reminders_status_next ON reminders(status, next_occurrence_utc);');
        await customStatement('CREATE INDEX IF NOT EXISTS idx_occurrences_reminder_status ON reminder_occurrences(reminder_id, status);');
        await customStatement('CREATE INDEX IF NOT EXISTS idx_occurrences_scheduled_utc ON reminder_occurrences(scheduled_at_utc);');
      }
    },
    onCreate: (m) async {
      await m.createAll();
      await customStatement('CREATE INDEX IF NOT EXISTS idx_reminders_status_next ON reminders(status, next_occurrence_utc);');
      await customStatement('CREATE INDEX IF NOT EXISTS idx_occurrences_reminder_status ON reminder_occurrences(reminder_id, status);');
      await customStatement('CREATE INDEX IF NOT EXISTS idx_occurrences_scheduled_utc ON reminder_occurrences(scheduled_at_utc);');
    },
  );
}
