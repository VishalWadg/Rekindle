import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../data/database.dart';
import 'recurrence_rules.dart';
import 'reminder_models.dart';
import 'reminder_repository.dart';

class DriftReminderRepository implements ReminderRepository {
  final AppDatabase db;
  static const _uuid = Uuid();

  DriftReminderRepository(this.db);

  @override
  Future<void> saveReminder({
    required Reminder reminder,
    required RecurrenceRule rule,
    ReminderOccurrence? initialOccurrence,
  }) async {
    await db.transaction(() async {
      await db.into(db.remindersTable).insertOnConflictUpdate(
            _reminderToCompanion(reminder),
          );

      // Clean up previous rule for this reminder if exists
      await (db.delete(db.recurrenceRulesTable)
            ..where((tbl) => tbl.reminderId.equals(reminder.id)))
          .go();

      await db.into(db.recurrenceRulesTable).insert(
            RecurrenceRulesTableCompanion(
              id: Value(_uuid.v4()),
              reminderId: Value(reminder.id),
              ruleType: Value(rule.scheduleType.name),
              configJson: Value(rule.toSerializedJson()),
              schemaVersion: const Value(1),
            ),
          );

      if (initialOccurrence != null) {
        await (db.delete(db.reminderOccurrencesTable)
              ..where((tbl) =>
                  tbl.reminderId.equals(initialOccurrence.reminderId) &
                  tbl.scheduleVersion.equals(initialOccurrence.scheduleVersion) &
                  tbl.scheduledAtUtc.equals(initialOccurrence.scheduledAtUtc)))
            .go();

        await db.into(db.reminderOccurrencesTable).insert(
              _occurrenceToCompanion(initialOccurrence),
            );
      }
    });
  }

  @override
  Future<Reminder?> getReminder(String id) async {
    final query = db.select(db.remindersTable)..where((tbl) => tbl.id.equals(id));
    final row = await query.getSingleOrNull();
    return row != null ? _mapReminder(row) : null;
  }

  @override
  Future<RecurrenceRule?> getRecurrenceRule(String reminderId) async {
    final query = db.select(db.recurrenceRulesTable)
      ..where((tbl) => tbl.reminderId.equals(reminderId))
      ..limit(1);
    final row = await query.getSingleOrNull();
    if (row == null) return null;
    return RecurrenceRule.fromJson(row.configJson);
  }

  @override
  Future<List<Reminder>> getAllReminders() async {
    final query = db.select(db.remindersTable)
      ..orderBy([
        (tbl) => OrderingTerm(expression: tbl.createdAt, mode: OrderingMode.desc),
      ]);
    final rows = await query.get();
    return rows.map(_mapReminder).toList();
  }

  @override
  Stream<List<Reminder>> watchAllReminders() {
    final query = db.select(db.remindersTable)
      ..orderBy([
        (tbl) => OrderingTerm(expression: tbl.createdAt, mode: OrderingMode.desc),
      ]);
    return query.watch().map((rows) => rows.map(_mapReminder).toList());
  }

  @override
  Future<void> updateReminder(Reminder reminder) async {
    await (db.update(db.remindersTable)..where((tbl) => tbl.id.equals(reminder.id)))
        .write(_reminderToCompanion(reminder));
  }

  @override
  Future<void> updateRecurrenceRule(String reminderId, RecurrenceRule rule) async {
    await db.transaction(() async {
      await (db.delete(db.recurrenceRulesTable)
            ..where((tbl) => tbl.reminderId.equals(reminderId)))
          .go();

      await db.into(db.recurrenceRulesTable).insert(
            RecurrenceRulesTableCompanion(
              id: Value(_uuid.v4()),
              reminderId: Value(reminderId),
              ruleType: Value(rule.scheduleType.name),
              configJson: Value(rule.toSerializedJson()),
              schemaVersion: const Value(1),
            ),
          );
    });
  }

  @override
  Future<void> deleteReminder(String id) async {
    await (db.delete(db.remindersTable)..where((tbl) => tbl.id.equals(id))).go();
  }

  @override
  Future<void> saveOccurrence(ReminderOccurrence occurrence) async {
    await db.transaction(() async {
      await (db.delete(db.reminderOccurrencesTable)
            ..where((tbl) =>
                tbl.reminderId.equals(occurrence.reminderId) &
                tbl.scheduleVersion.equals(occurrence.scheduleVersion) &
                tbl.scheduledAtUtc.equals(occurrence.scheduledAtUtc)))
          .go();

      await db.into(db.reminderOccurrencesTable).insert(
            _occurrenceToCompanion(occurrence),
          );
    });
  }

  @override
  Future<ReminderOccurrence?> getOccurrence(String id) async {
    final query = db.select(db.reminderOccurrencesTable)
      ..where((tbl) => tbl.id.equals(id));
    final row = await query.getSingleOrNull();
    return row != null ? _mapOccurrence(row) : null;
  }

  @override
  Future<ReminderOccurrence?> getNextOccurrence(String reminderId) async {
    final query = db.select(db.reminderOccurrencesTable)
      ..where((tbl) =>
          tbl.reminderId.equals(reminderId) &
          tbl.status.isIn(['pending', 'scheduled']))
      ..orderBy([
        (tbl) => OrderingTerm(expression: tbl.scheduledAtUtc, mode: OrderingMode.asc),
      ])
      ..limit(1);
    final row = await query.getSingleOrNull();
    return row != null ? _mapOccurrence(row) : null;
  }

  @override
  Future<List<ReminderOccurrence>> getPendingOccurrences() async {
    final query = db.select(db.reminderOccurrencesTable)
      ..where((tbl) => tbl.status.isIn(['pending', 'scheduled']))
      ..orderBy([
        (tbl) => OrderingTerm(expression: tbl.scheduledAtUtc, mode: OrderingMode.asc),
      ]);
    final rows = await query.get();
    return rows.map(_mapOccurrence).toList();
  }

  @override
  Future<void> updateOccurrenceStatus(String id, OccurrenceStatus status) async {
    await (db.update(db.reminderOccurrencesTable)..where((tbl) => tbl.id.equals(id)))
        .write(
      ReminderOccurrencesTableCompanion(
        status: Value(status.name),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  @override
  Future<void> saveSetting(String key, String value) async {
    await db.into(db.reminderSettingsTable).insertOnConflictUpdate(
          ReminderSettingsTableCompanion(
            key: Value(key),
            value: Value(value),
          ),
        );
  }

  @override
  Future<String?> getSetting(String key) async {
    final query = db.select(db.reminderSettingsTable)
      ..where((tbl) => tbl.key.equals(key));
    final row = await query.getSingleOrNull();
    return row?.value;
  }

  // --- Mappers ---

  Reminder _mapReminder(RemindersTableData data) {
    return Reminder(
      id: data.id,
      title: data.title,
      description: data.description,
      status: ReminderStatus.values.byName(data.status),
      scheduleType: ScheduleType.values.byName(data.scheduleType),
      startLocalDateTime: data.startLocal,
      timeZoneId: data.timezoneId,
      nextOccurrenceAtUtc: data.nextOccurrenceUtc?.toUtc(),
      scheduleVersion: data.scheduleVersion,
      notificationEnabled: data.notificationEnabled,
      linkedActivityId: data.linkedActivityId,
      createdAtUtc: data.createdAt.toUtc(),
      updatedAtUtc: data.updatedAt.toUtc(),
    );
  }

  RemindersTableCompanion _reminderToCompanion(Reminder reminder) {
    return RemindersTableCompanion(
      id: Value(reminder.id),
      title: Value(reminder.title),
      description: Value(reminder.description),
      status: Value(reminder.status.name),
      scheduleType: Value(reminder.scheduleType.name),
      startLocal: Value(reminder.startLocalDateTime),
      timezoneId: Value(reminder.timeZoneId),
      nextOccurrenceUtc: Value(reminder.nextOccurrenceAtUtc?.toUtc()),
      scheduleVersion: Value(reminder.scheduleVersion),
      notificationEnabled: Value(reminder.notificationEnabled),
      linkedActivityId: Value(reminder.linkedActivityId),
      createdAt: Value(reminder.createdAtUtc.toUtc()),
      updatedAt: Value(reminder.updatedAtUtc.toUtc()),
    );
  }

  ReminderOccurrence _mapOccurrence(ReminderOccurrencesTableData data) {
    return ReminderOccurrence(
      id: data.id,
      reminderId: data.reminderId,
      scheduleVersion: data.scheduleVersion,
      scheduledAtUtc: data.scheduledAtUtc.toUtc(),
      scheduledLocalDateTime: data.scheduledLocal,
      status: OccurrenceStatus.values.byName(data.status),
      notificationId: data.notificationId,
      createdAtUtc: data.createdAt.toUtc(),
      updatedAtUtc: data.updatedAt.toUtc(),
    );
  }

  ReminderOccurrencesTableCompanion _occurrenceToCompanion(
    ReminderOccurrence occurrence,
  ) {
    return ReminderOccurrencesTableCompanion(
      id: Value(occurrence.id),
      reminderId: Value(occurrence.reminderId),
      scheduleVersion: Value(occurrence.scheduleVersion),
      scheduledAtUtc: Value(occurrence.scheduledAtUtc.toUtc()),
      scheduledLocal: Value(occurrence.scheduledLocalDateTime),
      status: Value(occurrence.status.name),
      notificationId: Value(occurrence.notificationId),
      createdAt: Value(occurrence.createdAtUtc.toUtc()),
      updatedAt: Value(occurrence.updatedAtUtc.toUtc()),
    );
  }
}
