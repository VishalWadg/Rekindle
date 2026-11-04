import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rekindle_core/rekindle_core.dart';
import '../../app/providers.dart';
import 'reminder_service.dart';

class RemindersListScreen extends ConsumerWidget {
  const RemindersListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remindersAsync = ref.watch(remindersStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'reminders',
          style: TextStyle(fontFamily: 'Lora', fontWeight: FontWeight.w500),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/reminders/new'),
        icon: const Icon(Icons.add),
        label: const Text('New Reminder'),
      ),
      body: remindersAsync.when(
        data: (reminders) {
          if (reminders.isEmpty) {
            return _buildEmptyState(context);
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
            itemCount: reminders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final reminder = reminders[index];
              return _ReminderCard(reminder: reminder);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Text('Failed to load reminders: $err'),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none_outlined,
              size: 56,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No reminders scheduled yet',
              style: theme.textTheme.titleMedium?.copyWith(
                fontFamily: 'Lora',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Set a gentle, recurring or one-time revisit alert for thoughts, books, or ideas you care about.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () => context.push('/reminders/new'),
              icon: const Icon(Icons.add),
              label: const Text('Schedule a reminder'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReminderCard extends ConsumerWidget {
  const _ReminderCard({required this.reminder});

  final Reminder reminder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final service = ref.read(reminderServiceProvider);
    final repo = ref.read(reminderRepositoryProvider);

    return FutureBuilder<RecurrenceRule?>(
      future: repo.getRecurrenceRule(reminder.id),
      builder: (context, snapshot) {
        final rule = snapshot.data;

        return Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        reminder.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    _StatusBadge(status: reminder.status),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, size: 20),
                      padding: EdgeInsets.zero,
                      onSelected: (action) async {
                        switch (action) {
                          case 'toggle_pause':
                            if (reminder.status == ReminderStatus.active) {
                              await service.pauseReminder(reminder.id);
                            } else if (reminder.status == ReminderStatus.paused) {
                              await service.resumeReminder(reminder.id);
                            }
                            break;
                          case 'edit':
                            context.push('/reminders/edit/${reminder.id}');
                            break;
                          case 'delete':
                            _confirmDelete(context, service);
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        if (reminder.status == ReminderStatus.active)
                          const PopupMenuItem(
                            value: 'toggle_pause',
                            child: Row(
                              children: [
                                Icon(Icons.pause, size: 18),
                                SizedBox(width: 8),
                                Text('Pause'),
                              ],
                            ),
                          )
                        else if (reminder.status == ReminderStatus.paused)
                          const PopupMenuItem(
                            value: 'toggle_pause',
                            child: Row(
                              children: [
                                Icon(Icons.play_arrow, size: 18),
                                SizedBox(width: 8),
                                Text('Resume'),
                              ],
                            ),
                          ),
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit_outlined, size: 18),
                              SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete_outline, size: 18, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Delete', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (reminder.description != null && reminder.description!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    reminder.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.repeat,
                      size: 15,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        _describeCadence(reminder, rule),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                if (reminder.nextOccurrenceAtUtc != null) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 15,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Next: ${_formatDateTime(reminder.nextOccurrenceAtUtc!.toLocal())}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, ReminderService service) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete reminder?'),
        content: Text('Are you sure you want to delete "${reminder.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await service.deleteReminder(reminder.id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String _describeCadence(Reminder reminder, RecurrenceRule? rule) {
    if (rule is OnceRule) {
      return 'Once on ${_formatDateTime(rule.localDateTime)}';
    }
    if (rule is IntervalRule) {
      return 'Every ${rule.value} ${rule.unit.name}';
    }
    if (rule is WeeklyRule) {
      const dayNames = {
        1: 'Mon',
        2: 'Tue',
        3: 'Wed',
        4: 'Thu',
        5: 'Fri',
        6: 'Sat',
        7: 'Sun',
      };
      final sortedDays = rule.weekdays.toList()..sort();
      final dayStr = sortedDays.map((d) => dayNames[d] ?? '$d').join(', ');
      return 'Weekly on $dayStr at ${rule.localTime.format()}';
    }
    return reminder.scheduleType.name.toUpperCase();
  }

  String _formatDateTime(DateTime dt) {
    final y = dt.year;
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final h = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '$y-$m-$d $h:$min';
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final ReminderStatus status;

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    String label;

    switch (status) {
      case ReminderStatus.active:
        bg = const Color(0xFFF7E6D3);
        fg = const Color(0xFF8A4B14);
        label = 'Active';
        break;
      case ReminderStatus.paused:
        bg = const Color(0xFFEBE6DF);
        fg = const Color(0xFF6E6862);
        label = 'Paused';
        break;
      case ReminderStatus.completed:
        bg = const Color(0xFFE3F0E6);
        fg = const Color(0xFF2E6B39);
        label = 'Completed';
        break;
      case ReminderStatus.cancelled:
        bg = const Color(0xFFF5E6E6);
        fg = const Color(0xFF8A2E2E);
        label = 'Cancelled';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
