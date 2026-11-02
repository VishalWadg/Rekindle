import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rekindle_core/rekindle_core.dart';
import '../../app/providers.dart';

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final db = ref.watch(databaseProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('your insights', style: TextStyle(fontFamily: 'Lora', fontWeight: FontWeight.w500)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Header note
          Text(
            'Worked out on this phone. Nothing is sent anywhere.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 20),

          // Card 1: Library
          _buildLibraryCard(theme, db),
          const SizedBox(height: 16),

          // Card 2: Reactions
          _buildReactionsCard(theme, db),
          const SizedBox(height: 16),

          // Card 3: What Rekindle Believes
          _buildBanditBeliefsCard(theme, db),
        ],
      ),
    );
  }

  Widget _buildLibraryCard(ThemeData theme, AppDatabase db) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<Map<String, int>>(
          future: _getLibraryCounts(db),
          builder: (ctx, snap) {
            final interests = snap.data?['interests'] ?? 0;
            final thoughts = snap.data?['thoughts'] ?? 0;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Library Size', style: theme.textTheme.titleMedium),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCol(theme, '$interests', 'Interests'),
                    Container(height: 32, width: 1, color: theme.colorScheme.outlineVariant),
                    _buildStatCol(theme, '$thoughts', 'Saved Thoughts'),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildReactionsCard(ThemeData theme, AppDatabase db) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<Map<String, int>>(
          future: _getReactionCounts(db),
          builder: (ctx, snap) {
            final keeps = snap.data?['KEEP'] ?? 0;
            final skips = snap.data?['SKIP'] ?? 0;
            final explores = snap.data?['EXPLORE'] ?? 0;
            final total = keeps + skips + explores;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('What You Keep', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(
                  total == 0
                      ? 'Insights appear after a few days of use.'
                      : '$keeps kept · $explores explored · $skips skipped',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (total > 0) ...[
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: SizedBox(
                      height: 8,
                      child: Row(
                        children: [
                          Expanded(
                            flex: keeps > 0 ? keeps : 1,
                            child: Container(color: theme.colorScheme.primary),
                          ),
                          Expanded(
                            flex: explores > 0 ? explores : 1,
                            child: Container(color: theme.colorScheme.primaryContainer),
                          ),
                          Expanded(
                            flex: skips > 0 ? skips : 1,
                            child: Container(color: theme.colorScheme.outlineVariant),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBanditBeliefsCard(ThemeData theme, AppDatabase db) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<List<InterestsTableData>>(
          future: db.select(db.interestsTable).get(),
          builder: (ctx, snap) {
            final interests = snap.data ?? [];
            if (interests.isEmpty) {
              return const SizedBox();
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('What Rekindle Believes', style: theme.textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  'How the recommendation engine views your interest resonance.',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                ...interests.take(5).map((interest) {
                  final total = interest.alpha + interest.beta;
                  final share = total > 0 ? (interest.alpha / total) : 0.5;
                  final label = share > 0.6
                      ? 'leaning your way'
                      : (share < 0.4 ? 'quieter lately' : 'still learning');

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(interest.name, style: const TextStyle(fontWeight: FontWeight.w500)),
                        Text(label, style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 13)),
                      ],
                    ),
                  );
                }),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatCol(ThemeData theme, String count, String label) {
    return Column(
      children: [
        Text(count, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.primary)),
        const SizedBox(height: 2),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }

  Future<Map<String, int>> _getLibraryCounts(AppDatabase db) async {
    final interestList = await (db.select(db.interestsTable)..where((tbl) => tbl.archivedAt.isNull())).get();
    final snippetList = await db.select(db.snippetsTable).get();
    return {
      'interests': interestList.length,
      'thoughts': snippetList.length,
    };
  }

  Future<Map<String, int>> _getReactionCounts(AppDatabase db) async {
    final exposures = await db.select(db.exposuresTable).get();
    final map = <String, int>{};
    for (final exp in exposures) {
      map[exp.reaction] = (map[exp.reaction] ?? 0) + 1;
    }
    return map;
  }
}
