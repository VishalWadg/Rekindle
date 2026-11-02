import 'dart:convert';
import 'dart:math';
import 'package:clock/clock.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../bandit/interest_selector.dart';
import '../data/database.dart';
import '../domain/models.dart';

final class SurfaceItem {
  const SurfaceItem({
    required this.exposure,
    required this.interest,
    required this.snippet,
  });

  final ExposuresTableData exposure;
  final InterestsTableData interest;
  final SnippetsTableData snippet;
}

final class SurfaceService {
  SurfaceService({
    required this.db,
    required this.selector,
    this.clock = const Clock(),
    this.uuid = const Uuid(),
    Random? rng,
  }) : _rng = rng ?? Random();

  final AppDatabase db;
  final InterestSelector selector;
  final Clock clock;
  final Uuid uuid;
  final Random _rng;

  /// Returns the next thought to surface on the main screen,
  /// using Thompson Sampling for interest selection and 24h SQLite recency suppression.
  Future<SurfaceItem?> next({String? interestId}) async {
    final now = clock.now().toUtc();

    // 1. Query non-archived interests that have at least one snippet
    final query = db.select(db.interestsTable)..where((tbl) => tbl.archivedAt.isNull());
    if (interestId != null) {
      query.where((tbl) => tbl.id.equals(interestId));
    }
    final nonArchived = await query.get();

    if (nonArchived.isEmpty) return null;

    // Filter to interests having at least one snippet
    final eligible = <InterestsTableData>[];
    for (final item in nonArchived) {
      final snippetCountQuery = db.selectOnly(db.snippetsTable)
        ..addColumns([db.snippetsTable.id.count()])
        ..where(db.snippetsTable.interestId.equals(item.id));
      final count = await snippetCountQuery.map((row) => row.read(db.snippetsTable.id.count())).getSingle();
      if ((count ?? 0) > 0) {
        eligible.add(item);
      }
    }

    if (eligible.isEmpty) return null;

    // 2. Thompson draw to pick the interest
    final domainInterests = eligible
        .map(
          (e) => Interest(
            id: e.id,
            name: e.name,
            nameKey: e.nameKey,
            alpha: e.alpha,
            beta: e.beta,
            pushCooldownUntil: e.pushCooldownUntil,
            archivedAt: e.archivedAt,
            createdAt: e.createdAt,
          ),
        )
        .toList();

    final chosenDomainInterest = selector.pick(domainInterests);
    final chosenInterest = eligible.firstWhere((i) => i.id == chosenDomainInterest.id);

    // 3. Query all snippets for chosen interest
    final allSnippets = await (db.select(db.snippetsTable)
          ..where((tbl) => tbl.interestId.equals(chosenInterest.id)))
        .get();

    if (allSnippets.isEmpty) return null;

    // 4. Recency suppression: exclude snippets surfaced within the last 24 hours
    // (surfaced_at >= now - 24 hours, or scheduled_for within next 24 hours)
    final recencyCutoff = now.subtract(const Duration(hours: 24));
    final future24h = now.add(const Duration(hours: 24));

    final recentExposures = await (db.select(db.exposuresTable)
          ..where(
            (tbl) =>
                tbl.interestId.equals(chosenInterest.id) &
                tbl.snippetId.isNotNull() &
                (tbl.surfacedAt.isBiggerOrEqualValue(recencyCutoff) |
                    (tbl.scheduledFor.isNotNull() &
                        tbl.scheduledFor.isSmallerOrEqualValue(future24h))),
          ))
        .get();

    final recentSnippetIds = recentExposures.map((e) => e.snippetId!).toSet();
    final freshSnippets = allSnippets.where((s) => !recentSnippetIds.contains(s.id)).toList();

    SnippetsTableData chosenSnippet;
    if (freshSnippets.isNotEmpty) {
      // Pick random among fresh snippets
      chosenSnippet = freshSnippets[_rng.nextInt(freshSnippets.length)];
    } else {
      // All are suppressed: pick the one surfaced longest ago
      // Query snippet exposures sorted by surfacedAt ascending
      final exposureHistory = await (db.select(db.exposuresTable)
            ..where((tbl) => tbl.interestId.equals(chosenInterest.id) & tbl.snippetId.isNotNull())
            ..orderBy([(tbl) => OrderingTerm.asc(tbl.surfacedAt)]))
          .get();

      final surfacedSnippetIds = exposureHistory.map((e) => e.snippetId!).toList();
      // Look for any snippet that was never surfaced first
      final neverSurfaced = allSnippets.where((s) => !surfacedSnippetIds.contains(s.id)).toList();
      if (neverSurfaced.isNotEmpty) {
        chosenSnippet = neverSurfaced.first;
      } else {
        // Find the snippet with oldest surfaced exposure
        final oldestSnippetId = surfacedSnippetIds.first;
        chosenSnippet = allSnippets.firstWhere(
          (s) => s.id == oldestSnippetId,
          orElse: () => allSnippets.first,
        );
      }
    }

    // 5. Persist exposure
    final exposureId = uuid.v4();
    final planReasonMap = {
      'pipeline': 'IN_APP',
      'chosenInterest': chosenInterest.id,
      'alpha': chosenInterest.alpha,
      'beta': chosenInterest.beta,
    };

    await db.into(db.exposuresTable).insert(
          ExposuresTableCompanion.insert(
            id: exposureId,
            interestId: chosenInterest.id,
            snippetId: Value(chosenSnippet.id),
            kind: 'SNIPPET',
            templateCode: 'IN_APP',
            copyVariant: 'STANDARD',
            voice: 'CALM',
            channel: 'IN_APP',
            surfacedAt: now,
            planReason: Value(jsonEncode(planReasonMap)),
          ),
        );

    // Record analytics event
    final localDate = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    await db.into(db.analyticsEventsTable).insert(
          AnalyticsEventsTableCompanion.insert(
            ts: now,
            localDate: localDate,
            localHour: now.hour,
            type: 'exposure_created',
            exposureId: Value(exposureId),
            interestId: Value(chosenInterest.id),
            props: const Value('{"channel":"IN_APP","kind":"SNIPPET"}'),
          ),
        );

    final exposureData = await (db.select(db.exposuresTable)..where((tbl) => tbl.id.equals(exposureId))).getSingle();

    return SurfaceItem(
      exposure: exposureData,
      interest: chosenInterest,
      snippet: chosenSnippet,
    );
  }
}
