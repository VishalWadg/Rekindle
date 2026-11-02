import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:rekindle_core/rekindle_core.dart';
import '../../app/providers.dart';

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key, required this.interestId});

  final String interestId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final db = ref.watch(databaseProvider);

    final interestFuture = (db.select(db.interestsTable)..where((tbl) => tbl.id.equals(interestId))).getSingleOrNull();
    final snippetsStream = (db.select(db.snippetsTable)..where((tbl) => tbl.interestId.equals(interestId))).watch();

    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<InterestsTableData?>(
          future: interestFuture,
          builder: (ctx, snap) => Text(
            snap.data?.name ?? 'explore',
            style: const TextStyle(fontFamily: 'Lora', fontWeight: FontWeight.w500),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add thought',
            onPressed: () => _showAddSnippetSheet(context, ref),
          ),
        ],
      ),
      body: StreamBuilder<List<SnippetsTableData>>(
        stream: snippetsStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          final snippets = snapshot.data!;
          if (snippets.isEmpty) {
            return Center(
              child: Text(
                'No thoughts in this interest yet.',
                style: theme.textTheme.bodyMedium,
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: snippets.length,
            separatorBuilder: (_, __) => Divider(height: 1, color: theme.colorScheme.outlineVariant),
            itemBuilder: (ctx, idx) {
              final snippet = snippets[idx];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snippet.content,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontFamily: 'Lora',
                        fontSize: 17,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          snippet.source,
                          style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 18),
                          tooltip: 'Delete thought',
                          onPressed: () async {
                            await (db.delete(db.snippetsTable)..where((tbl) => tbl.id.equals(snippet.id))).go();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showAddSnippetSheet(BuildContext context, WidgetRef ref) {
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
            Text('Add thought', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              maxLength: 1000,
              maxLines: 4,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Type your thought...',
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
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
