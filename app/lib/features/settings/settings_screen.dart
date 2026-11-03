import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' as drift;
import 'package:rekindle_core/rekindle_core.dart';
import '../../app/providers.dart';
import '../nudges/local_notification_gateway.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final db = ref.watch(databaseProvider);

    final settingsStream = (db.select(db.notificationSettingsTable)..where((tbl) => tbl.id.equals(1))).watchSingleOrNull();

    return Scaffold(
      appBar: AppBar(
        title: const Text('settings', style: TextStyle(fontFamily: 'Lora', fontWeight: FontWeight.w500)),
      ),
      body: StreamBuilder<NotificationSettingsTableData?>(
        stream: settingsStream,
        builder: (context, snapshot) {
          final settings = snapshot.data;

          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 12),
            children: [
              // Nudge Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text('NUDGES', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.primary)),
              ),
              ListTile(
                title: const Text('Nudge frequency'),
                subtitle: Text(settings?.level ?? 'GENTLE'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showFrequencyDialog(context, ref, settings?.level ?? 'GENTLE'),
              ),
              ListTile(
                title: const Text('Voice and tone'),
                subtitle: Text(settings?.voice ?? 'CALM'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showVoiceDialog(context, ref, settings?.voice ?? 'CALM'),
              ),
              SwitchListTile(
                title: const Text('Show text on lock screen'),
                subtitle: const Text('Hides note content on lock screen when disabled'),
                value: settings?.showTextOnLockScreen ?? false,
                onChanged: (val) async {
                  await (db.update(db.notificationSettingsTable)..where((tbl) => tbl.id.equals(1))).write(
                    NotificationSettingsTableCompanion(showTextOnLockScreen: drift.Value(val)),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.flash_on_outlined, color: Colors.amber),
                title: const Text('Send test nudge instantly'),
                subtitle: const Text('Fires immediately to verify shade and sounds'),
                onTap: () async {
                  await LocalNotificationGateway.instance.showInstantTestNotification(
                    title: 'Rekindle · Instant Test Nudge',
                    body: 'Notification delivery and actions are fully operational!',
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Test nudge fired! Check your notification shade.')),
                    );
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.alarm_outlined),
                title: const Text('Schedule test nudge in 10s'),
                subtitle: const Text('Tests exact alarm background delivery'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  final gateway = ref.read(notificationGatewayProvider);
                  await gateway.scheduleNotification(
                    id: 999999,
                    title: 'Rekindle Test Nudge',
                    body: 'Gentle notification delivery is working properly on this device.',
                    scheduledDate: DateTime.now().add(const Duration(seconds: 10)),
                    payload: '{"test":true}',
                    actions: const [
                      NotificationActionInfo(id: 'ok', label: 'Received'),
                    ],
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Test nudge scheduled for 10 seconds from now.')),
                    );
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.refresh_outlined),
                title: const Text('Re-plan all nudges'),
                subtitle: const Text('Schedules 72h nudges (with quick 2-min nudge)'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  final planner = ref.read(nudgePlannerProvider);
                  await planner.replan(DateTime.now(), scheduleFirstNudgeQuickly: true);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Nudges replanned! First nudge scheduled in 2 minutes.')),
                    );
                  }
                },
              ),
              const Divider(height: 32),

              // Insights Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text('INSIGHTS', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.primary)),
              ),
              ListTile(
                title: const Text('View insights'),
                subtitle: const Text('Library patterns and rediscovery health'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/insights'),
              ),
              const Divider(height: 32),

              // Data Management
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text('YOUR DATA', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.primary)),
              ),
              ListTile(
                title: const Text('Export my notes'),
                subtitle: const Text('Creates a portable JSON backup'),
                trailing: const Icon(Icons.download_outlined),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Exporting notes to local JSON...')),
                  );
                },
              ),
              ListTile(
                title: const Text('Delete everything', style: TextStyle(color: Colors.redAccent)),
                subtitle: const Text('Empties all tables and resets the app locally'),
                trailing: const Icon(Icons.delete_forever_outlined, color: Colors.redAccent),
                onTap: () => _showDeleteEverythingDialog(context, ref),
              ),
              const Divider(height: 32),

              // About Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text('ABOUT', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.primary)),
              ),
              ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset('assets/images/logo.png', width: 36, height: 36),
                ),
                title: const Text('Rekindle v0.2.0 (Offline)'),
                subtitle: const Text('100% on-device. Zero network calls. Nothing leaves this phone.\nLong-press to view bandit debug info.'),
                onLongPress: () => _showDebugBanditSheet(context, ref),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showFrequencyDialog(BuildContext context, WidgetRef ref, String current) {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Nudge frequency'),
        children: ['RARE', 'GENTLE', 'MORE', 'OFF'].map((level) {
          return SimpleDialogOption(
            onPressed: () async {
              final db = ref.read(databaseProvider);
              await (db.update(db.notificationSettingsTable)..where((tbl) => tbl.id.equals(1))).write(
                NotificationSettingsTableCompanion(level: drift.Value(level)),
              );
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: Text(level, style: TextStyle(fontWeight: level == current ? FontWeight.bold : FontWeight.normal)),
          );
        }).toList(),
      ),
    );
  }

  void _showVoiceDialog(BuildContext context, WidgetRef ref, String current) {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Voice'),
        children: ['CALM', 'PLAYFUL'].map((v) {
          return SimpleDialogOption(
            onPressed: () async {
              final db = ref.read(databaseProvider);
              await (db.update(db.notificationSettingsTable)..where((tbl) => tbl.id.equals(1))).write(
                NotificationSettingsTableCompanion(voice: drift.Value(v)),
              );
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: Text(v, style: TextStyle(fontWeight: v == current ? FontWeight.bold : FontWeight.normal)),
          );
        }).toList(),
      ),
    );
  }

  void _showDeleteEverythingDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete everything?'),
        content: const Text(
          'This will permanently delete all your interests, thoughts, and nudge history from this phone. This action cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              final db = ref.read(databaseProvider);
              await db.delete(db.snippetsTable).go();
              await db.delete(db.exposuresTable).go();
              await db.delete(db.interestsTable).go();
              await db.delete(db.analyticsEventsTable).go();
              await db.delete(db.appStates).go();
              await db.delete(db.notificationSettingsTable).go();

              final gateway = ref.read(notificationGatewayProvider);
              await gateway.cancelAll();

              if (ctx.mounted) {
                Navigator.pop(ctx);
                context.go('/onboarding');
              }
            },
            child: const Text('Delete permanently', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  void _showDebugBanditSheet(BuildContext context, WidgetRef ref) async {
    final db = ref.read(databaseProvider);
    final interests = await db.select(db.interestsTable).get();

    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Bandit Belief Counters (α / β)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: interests.length,
                itemBuilder: (_, idx) {
                  final i = interests[idx];
                  final total = i.alpha + i.beta;
                  final mean = total > 0 ? (i.alpha / total) : 0.5;
                  return ListTile(
                    dense: true,
                    title: Text(i.name),
                    subtitle: Text('α: ${i.alpha.toStringAsFixed(1)} · β: ${i.beta.toStringAsFixed(1)}'),
                    trailing: Text('Mean: ${(mean * 100).toStringAsFixed(0)}%'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
