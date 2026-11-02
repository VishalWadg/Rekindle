import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' as drift;
import 'package:rekindle_core/rekindle_core.dart';
import '../../app/providers.dart';

class InterestsScreen extends ConsumerWidget {
  const InterestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final interestsAsync = ref.watch(interestsStreamProvider);
    final db = ref.watch(databaseProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('your interests', style: TextStyle(fontFamily: 'Lora', fontWeight: FontWeight.w500)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add interest',
            onPressed: () => _showAddInterestDialog(context, ref),
          ),
        ],
      ),
      body: interestsAsync.when(
        data: (interests) {
          if (interests.isEmpty) {
            return Center(
              child: Text('No interests yet.', style: theme.textTheme.bodyMedium),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: interests.length,
            separatorBuilder: (_, __) => Divider(height: 1, color: theme.colorScheme.outlineVariant),
            itemBuilder: (ctx, idx) {
              final interest = interests[idx];
              return FutureBuilder<int>(
                future: _getSnippetCount(db, interest.id),
                builder: (context, snapshot) {
                  final count = snapshot.data ?? 0;
                  return ListTile(
                    title: Text(interest.name, style: const TextStyle(fontWeight: FontWeight.w500)),
                    subtitle: Text(
                      count == 0 ? 'add a snippet' : '$count thoughts',
                      style: TextStyle(
                        color: count == 0 ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                        fontSize: 13,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.add_comment_outlined, size: 20),
                          tooltip: 'Add snippet',
                          onPressed: () => _showAddSnippetSheet(context, ref, interest.id, interest.name),
                        ),
                        IconButton(
                          icon: const Icon(Icons.archive_outlined, size: 20),
                          tooltip: 'Archive',
                          onPressed: () async {
                            await (db.update(db.interestsTable)..where((tbl) => tbl.id.equals(interest.id))).write(
                              InterestsTableCompanion(archivedAt: drift.Value(DateTime.now().toUtc())),
                            );
                          },
                        ),
                      ],
                    ),
                    onTap: () => context.push('/explore/${interest.id}'),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator.adaptive()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Future<int> _getSnippetCount(AppDatabase db, String interestId) async {
    final query = db.selectOnly(db.snippetsTable)
      ..addColumns([db.snippetsTable.id.count()])
      ..where(db.snippetsTable.interestId.equals(interestId));
    final count = await query.map((row) => row.read(db.snippetsTable.id.count())).getSingle();
    return count ?? 0;
  }

  void _showAddInterestDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add interest'),
        content: TextField(
          controller: controller,
          maxLength: 60,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'e.g. Astrophysics, Architecture...',
            counterText: '',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                final db = ref.read(databaseProvider);
                await db.into(db.interestsTable).insert(
                      InterestsTableCompanion.insert(
                        id: const Uuid().v4(),
                        name: text,
                        nameKey: text.toLowerCase(),
                        createdAt: DateTime.now().toUtc(),
                      ),
                    );
                if (context.mounted) Navigator.pop(ctx);
              }
            },
            child: const Text('Add'),
          )
        ],
      ),
    );
  }

  void _showAddSnippetSheet(BuildContext context, WidgetRef ref, String interestId, String interestName) {
    final controller = TextEditingController();
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Add thought to $interestName', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              maxLength: 1000,
              maxLines: 4,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Type your note or curiosity...',
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () async {
                  final text = controller.text.trim();
                  if (text.isNotEmpty) {
                    final db = ref.read(databaseProvider);
                    final now = DateTime.now().toUtc();
                    await db.into(db.snippetsTable).insert(
                          SnippetsTableCompanion.insert(
                            id: const Uuid().v4(),
                            interestId: interestId,
                            content: text,
                            source: 'MANUAL',
                            createdAt: now,
                            updatedAt: now,
                          ),
                        );
                    if (context.mounted) Navigator.pop(ctx);
                  }
                },
                child: const Text('Save thought'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
