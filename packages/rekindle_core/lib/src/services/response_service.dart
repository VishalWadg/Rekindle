import 'package:clock/clock.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../data/database.dart';
import '../domain/enums.dart';
import '../domain/models.dart';
import 'reward_mapper.dart';

final class ResponseService {
  ResponseService({
    required this.db,
    this.clock = const Clock(),
    this.uuid = const Uuid(),
  });

  final AppDatabase db;
  final Clock clock;
  final Uuid uuid;

  Reaction _parseReaction(String str) {
    for (final r in Reaction.values) {
      if (r.name.toLowerCase() == str.toLowerCase()) {
        return r;
      }
    }
    return Reaction.none;
  }

  String _reactionToSql(Reaction reaction) {
    return switch (reaction) {
      Reaction.none => 'NONE',
      Reaction.keep => 'KEEP',
      Reaction.skip => 'SKIP',
      Reaction.explore => 'EXPLORE',
      Reaction.yes => 'YES',
      Reaction.notNow => 'NOT_NOW',
      Reaction.less => 'LESS',
      Reaction.captured => 'CAPTURED',
      Reaction.pickA => 'PICK_A',
      Reaction.pickB => 'PICK_B',
      Reaction.neither => 'NEITHER',
      Reaction.expired => 'EXPIRED',
    };
  }

  String _viaToSql(RespondedVia via) {
    return switch (via) {
      RespondedVia.notificationAction => 'NOTIFICATION_ACTION',
      RespondedVia.notificationTap => 'NOTIFICATION_TAP',
      RespondedVia.inApp => 'IN_APP',
    };
  }

  /// Applies a response exactly once within a SQLite transaction.
  /// Returns [ResponseResult] with applied=true if this call transitioned the state,
  /// or applied=false with the existing reaction if already answered or expired.
  Future<ResponseResult> apply(ResponseCommand command) async {
    final now = clock.now().toUtc();
    final reactionSql = _reactionToSql(command.reaction);
    final viaSql = _viaToSql(command.via);

    return db.transaction(() async {
      // 1. Exactly-once conditional update
      final count = await (db.update(db.exposuresTable)
            ..where((tbl) => tbl.id.equals(command.exposureId) & tbl.reaction.equals('NONE')))
          .write(
        ExposuresTableCompanion(
          reaction: Value(reactionSql),
          respondedAt: Value(now),
          respondedVia: Value(viaSql),
          responseText: Value(command.text),
        ),
      );

      if (count == 0) {
        // Already answered or expired
        final existing = await (db.select(db.exposuresTable)
              ..where((tbl) => tbl.id.equals(command.exposureId)))
            .getSingleOrNull();
        final currentReaction =
            existing != null ? _parseReaction(existing.reaction) : Reaction.none;
        return ResponseResult(applied: false, reaction: currentReaction);
      }

      // 2. Fetch the exposure to apply bandit and cooldown side-effects
      final exposure = await (db.select(db.exposuresTable)
            ..where((tbl) => tbl.id.equals(command.exposureId)))
          .getSingle();

      final delta = RewardMapper.forReaction(command.reaction);

      // 3. Update interest alpha & beta
      final interest = await (db.select(db.interestsTable)
            ..where((tbl) => tbl.id.equals(exposure.interestId)))
          .getSingle();

      DateTime? newCooldown = interest.pushCooldownUntil;
      if (delta.cooldownDuration != null) {
        newCooldown = now.add(delta.cooldownDuration!);
      }

      await (db.update(db.interestsTable)
            ..where((tbl) => tbl.id.equals(exposure.interestId)))
          .write(
        InterestsTableCompanion(
          alpha: Value(interest.alpha + delta.dAlpha),
          beta: Value(interest.beta + delta.dBeta),
          pushCooldownUntil: Value(newCooldown),
        ),
      );

      // 4. If CAPTURED, insert snippet from notification inline reply
      if (delta.createsSnippet && command.text != null && command.text!.trim().isNotEmpty) {
        final snippetContent = command.text!.trim();
        final boundedContent =
            snippetContent.length > 1000 ? snippetContent.substring(0, 1000) : snippetContent;

        await db.into(db.snippetsTable).insert(
              SnippetsTableCompanion.insert(
                id: uuid.v4(),
                interestId: exposure.interestId,
                content: boundedContent,
                source: 'NOTIFICATION_REPLY',
                createdAt: now,
                updatedAt: now,
              ),
            );
      }

      // 5. Reset governor backoff counters on any response
      await (db.update(db.notificationSettingsTable)..where((tbl) => tbl.id.equals(1))).write(
        const NotificationSettingsTableCompanion(
          consecutiveIgnored: Value(0),
          backoffStep: Value(0),
        ),
      );

      // 6. Record analytics event
      final localDate = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      await db.into(db.analyticsEventsTable).insert(
            AnalyticsEventsTableCompanion.insert(
              ts: now,
              localDate: localDate,
              localHour: now.hour,
              type: 'exposure_responded',
              exposureId: Value(exposure.id),
              interestId: Value(exposure.interestId),
              props: Value('{"reaction":"$reactionSql","via":"$viaSql"}'),
            ),
          );

      return ResponseResult(applied: true, reaction: command.reaction);
    });
  }
}
