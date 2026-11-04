import 'reminder_models.dart';
import 'recurrence_rules.dart';

abstract interface class ReminderRepository {
  Future<void> saveReminder({
    required Reminder reminder,
    required RecurrenceRule rule,
    ReminderOccurrence? initialOccurrence,
  });

  Future<Reminder?> getReminder(String id);

  Future<RecurrenceRule?> getRecurrenceRule(String reminderId);

  Future<List<Reminder>> getAllReminders();

  Stream<List<Reminder>> watchAllReminders();

  Future<void> updateReminder(Reminder reminder);

  Future<void> updateRecurrenceRule(String reminderId, RecurrenceRule rule);

  Future<void> deleteReminder(String id);

  Future<void> saveOccurrence(ReminderOccurrence occurrence);

  Future<ReminderOccurrence?> getOccurrence(String id);

  Future<ReminderOccurrence?> getNextOccurrence(String reminderId);

  Future<List<ReminderOccurrence>> getPendingOccurrences();

  Future<void> updateOccurrenceStatus(String id, OccurrenceStatus status);

  Future<void> saveSetting(String key, String value);

  Future<String?> getSetting(String key);
}
