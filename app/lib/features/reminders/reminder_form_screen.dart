import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:go_router/go_router.dart';
import 'package:rekindle_core/rekindle_core.dart';
import '../../app/providers.dart';

class ReminderFormScreen extends ConsumerStatefulWidget {
  const ReminderFormScreen({super.key, this.reminderId});

  final String? reminderId;

  @override
  ConsumerState<ReminderFormScreen> createState() => _ReminderFormScreenState();
}

class _ReminderFormScreenState extends ConsumerState<ReminderFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  ScheduleType _scheduleType = ScheduleType.interval;
  bool _notificationEnabled = true;
  bool _isLoading = false;
  bool _isInitLoaded = false;

  Reminder? _existingReminder;

  // Once-state
  DateTime _onceDate = DateTime.now().add(const Duration(hours: 1));
  TimeOfDay _onceTime = TimeOfDay.now();

  // Interval-state
  int _intervalValue = 2;
  IntervalUnit _intervalUnit = IntervalUnit.hours;

  // Weekly-state
  Set<int> _weeklyDays = {1, 3, 5}; // Mon, Wed, Fri
  TimeOfDay _weeklyTime = const TimeOfDay(hour: 9, minute: 0);

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();

    if (widget.reminderId != null) {
      _loadExistingReminder(widget.reminderId!);
    } else {
      _isInitLoaded = true;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadExistingReminder(String id) async {
    final repo = ref.read(reminderRepositoryProvider);
    final reminder = await repo.getReminder(id);
    final rule = await repo.getRecurrenceRule(id);

    if (reminder != null && mounted) {
      setState(() {
        _existingReminder = reminder;
        _titleController.text = reminder.title;
        _descriptionController.text = reminder.description ?? '';
        _scheduleType = reminder.scheduleType;
        _notificationEnabled = reminder.notificationEnabled;

        if (rule is OnceRule) {
          _onceDate = rule.localDateTime;
          _onceTime = TimeOfDay(hour: rule.localDateTime.hour, minute: rule.localDateTime.minute);
        } else if (rule is IntervalRule) {
          _intervalValue = rule.value;
          _intervalUnit = rule.unit;
        } else if (rule is WeeklyRule) {
          _weeklyDays = Set.from(rule.weekdays);
          _weeklyTime = TimeOfDay(hour: rule.localTime.hour, minute: rule.localTime.minute);
        }

        _isInitLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.reminderId != null;

    if (!_isInitLoaded) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'edit reminder' : 'new reminder',
          style: const TextStyle(fontFamily: 'Lora', fontWeight: FontWeight.w500),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            // Title
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title *',
                hintText: 'e.g. Read Marcus Aurelius notes',
                border: OutlineInputBorder(),
              ),
              maxLength: 120,
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Please enter a reminder title';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),

            // Description
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Note / Context (optional)',
                hintText: 'Any prompt or detail to spark your memory',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
              maxLength: 300,
            ),
            const SizedBox(height: 16),

            // Recurrence Type Selector
            Text(
              'CADENCE',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            SegmentedButton<ScheduleType>(
              segments: const [
                ButtonSegment(
                  value: ScheduleType.interval,
                  label: Text('Interval'),
                  icon: Icon(Icons.timer_outlined, size: 18),
                ),
                ButtonSegment(
                  value: ScheduleType.weekly,
                  label: Text('Weekly'),
                  icon: Icon(Icons.calendar_view_week, size: 18),
                ),
                ButtonSegment(
                  value: ScheduleType.once,
                  label: Text('Once'),
                  icon: Icon(Icons.alarm, size: 18),
                ),
              ],
              selected: {_scheduleType},
              onSelectionChanged: (selected) {
                setState(() => _scheduleType = selected.first);
              },
            ),
            const SizedBox(height: 20),

            // Dynamic recurrence controls
            if (_scheduleType == ScheduleType.interval) _buildIntervalControls(context),
            if (_scheduleType == ScheduleType.weekly) _buildWeeklyControls(context),
            if (_scheduleType == ScheduleType.once) _buildOnceControls(context),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 8),

            // Notification Switch
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Deliver push notification'),
              subtitle: const Text('Plays sound and displays in notifications bar'),
              value: _notificationEnabled,
              onChanged: (val) => setState(() => _notificationEnabled = val),
            ),
            const SizedBox(height: 32),

            // Submit Button
            FilledButton(
              onPressed: _isLoading ? null : _saveReminder,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Text(isEditing ? 'Save Changes' : 'Create Reminder'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntervalControls(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Repeat Interval',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    initialValue: _intervalValue.toString(),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Every',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) {
                      final n = int.tryParse(val);
                      if (n != null && n > 0) {
                        setState(() => _intervalValue = n);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 3,
                  child: DropdownButtonFormField<IntervalUnit>(
                    initialValue: _intervalUnit,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: IntervalUnit.hours,
                        child: Text('Hours'),
                      ),
                      DropdownMenuItem(
                        value: IntervalUnit.days,
                        child: Text('Days'),
                      ),
                      DropdownMenuItem(
                        value: IntervalUnit.weeks,
                        child: Text('Weeks'),
                      ),
                    ],
                    onChanged: (unit) {
                      if (unit != null) setState(() => _intervalUnit = unit);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyControls(BuildContext context) {
    const dayLabels = {
      1: 'Mon',
      2: 'Tue',
      3: 'Wed',
      4: 'Thu',
      5: 'Fri',
      6: 'Sat',
      7: 'Sun',
    };

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Days & Time',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [1, 2, 3, 4, 5, 6, 7].map((day) {
                final selected = _weeklyDays.contains(day);
                return FilterChip(
                  label: Text(dayLabels[day]!),
                  selected: selected,
                  onSelected: (sel) {
                    setState(() {
                      if (sel) {
                        _weeklyDays.add(day);
                      } else if (_weeklyDays.length > 1) {
                        _weeklyDays.remove(day);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.access_time),
              title: const Text('Time of day'),
              subtitle: Text(_weeklyTime.format(context)),
              trailing: OutlinedButton(
                onPressed: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: _weeklyTime,
                  );
                  if (picked != null) {
                    setState(() => _weeklyTime = picked);
                  }
                },
                child: const Text('Change'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnceControls(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Specific Date & Time',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today_outlined),
              title: const Text('Date'),
              subtitle: Text(
                '${_onceDate.year}-${_onceDate.month.toString().padLeft(2, '0')}-${_onceDate.day.toString().padLeft(2, '0')}',
              ),
              trailing: OutlinedButton(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _onceDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 3650)),
                  );
                  if (picked != null) {
                    setState(() => _onceDate = picked);
                  }
                },
                child: const Text('Select Date'),
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.access_time),
              title: const Text('Time'),
              subtitle: Text(_onceTime.format(context)),
              trailing: OutlinedButton(
                onPressed: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: _onceTime,
                  );
                  if (picked != null) {
                    setState(() => _onceTime = picked);
                  }
                },
                child: const Text('Select Time'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveReminder() async {
    if (!_formKey.currentState!.validate()) return;
    if (_scheduleType == ScheduleType.weekly && _weeklyDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one day of the week')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      String timezoneId;
      try {
        timezoneId = await FlutterTimezone.getLocalTimezone();
      } catch (_) {
        timezoneId = 'UTC';
      }

      final service = ref.read(reminderServiceProvider);

      // Build recurrence rule
      RecurrenceRule rule;
      DateTime startLocal;

      switch (_scheduleType) {
        case ScheduleType.once:
          startLocal = DateTime(
            _onceDate.year,
            _onceDate.month,
            _onceDate.day,
            _onceTime.hour,
            _onceTime.minute,
          );
          rule = OnceRule(startLocal);
          break;
        case ScheduleType.interval:
          startLocal = DateTime.now();
          rule = IntervalRule(value: _intervalValue, unit: _intervalUnit);
          break;
        case ScheduleType.weekly:
          startLocal = DateTime.now();
          rule = WeeklyRule(
            weekdays: _weeklyDays,
            localTime: ReminderTime(
              hour: _weeklyTime.hour,
              minute: _weeklyTime.minute,
            ),
          );
          break;
      }

      if (_existingReminder == null) {
        await service.createReminder(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          scheduleType: _scheduleType,
          startLocalDateTime: startLocal,
          timeZoneId: timezoneId,
          rule: rule,
          notificationEnabled: _notificationEnabled,
        );
      } else {
        await service.updateReminder(
          reminder: _existingReminder!.copyWith(
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
            scheduleType: _scheduleType,
            startLocalDateTime: startLocal,
            timeZoneId: timezoneId,
            notificationEnabled: _notificationEnabled,
          ),
          rule: rule,
        );
      }

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _existingReminder == null
                  ? 'Reminder scheduled'
                  : 'Reminder updated',
            ),
          ),
        );
      }
    } catch (err) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving reminder: $err')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
