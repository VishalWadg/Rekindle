import 'dart:convert';
import 'package:clock/clock.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../bandit/interest_selector.dart';
import '../data/database.dart' hide AppState;
import '../domain/enums.dart';
import '../domain/models.dart';
import '../governor/delivery_governor.dart';

final class NotificationActionInfo {
  const NotificationActionInfo({
    required this.id,
    required this.label,
    this.showsUserInterface = false,
    this.hasTextInput = false,
  });

  final String id;
  final String label;
  final bool showsUserInterface;
  final bool hasTextInput;
}

abstract interface class NotificationGateway {
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    required String payload,
    required List<NotificationActionInfo> actions,
  });

  Future<void> cancelNotification(int id);
  Future<void> cancelAll();
}

final class PlannedNudge {
  const PlannedNudge({
    required this.exposureId,
    required this.notificationId,
    required this.interestId,
    this.snippetId,
    required this.templateCode,
    required this.scheduledFor,
    required this.title,
    required this.body,
    required this.actions,
  });

  final String exposureId;
  final int notificationId;
  final String interestId;
  final String? snippetId;
  final String templateCode;
  final DateTime scheduledFor;
  final String title;
  final String body;
  final List<NotificationActionInfo> actions;
}

final class NudgePlanner {
  NudgePlanner({
    required this.db,
    required this.selector,
    required this.gateway,
    this.governor = const DeliveryGovernor(),
    this.clock = const Clock(),
    this.uuid = const Uuid(),
  });

  final AppDatabase db;
  final InterestSelector selector;
  final NotificationGateway gateway;
  final DeliveryGovernor governor;
  final Clock clock;
  final Uuid uuid;

  /// Re-plans up to 6 nudges over the 72-hour horizon deterministically.
  Future<List<PlannedNudge>> replan(DateTime now) async {
    final utcNow = now.toUtc();

    // 1. Fetch current AppState and NotificationSettings
    final appStateRow = await (db.select(db.appStates)..where((tbl) => tbl.id.equals(1))).getSingleOrNull();
    final settingsRow = await (db.select(db.notificationSettingsTable)..where((tbl) => tbl.id.equals(1))).getSingleOrNull();

    if (appStateRow == null || settingsRow == null) {
      return [];
    }

    final permission = appStateRow.notificationPermission == 'GRANTED'
        ? NotificationPermissionState.granted
        : (appStateRow.notificationPermission == 'DENIED'
            ? NotificationPermissionState.denied
            : NotificationPermissionState.unknown);

    final domainAppState = AppState(
      installSeed: appStateRow.installSeed,
      timezone: appStateRow.timezone,
      onboardingCompletedAt: appStateRow.onboardingCompletedAt,
      lastSeenAt: appStateRow.lastSeenAt,
      notificationPermission: permission,
      createdAt: appStateRow.createdAt,
    );

    final domainSettings = NotificationSettings(
      level: NotificationLevel.values.firstWhere(
        (l) => l.name.toUpperCase() == settingsRow.level,
        orElse: () => NotificationLevel.gentle,
      ),
      consecutiveIgnored: settingsRow.consecutiveIgnored,
      backoffStep: settingsRow.backoffStep,
      pausedUntil: settingsRow.pausedUntil,
      lastNudgeAt: settingsRow.lastNudgeAt,
    );

    // 2. Precondition check
    if (!governor.canSchedule(appState: domainAppState, settings: domainSettings)) {
      await _clearFuturePlanned(utcNow);
      return [];
    }

    // 3. Clear existing unfired future planned nudges
    await _clearFuturePlanned(utcNow);

    // 4. Determine earliest allowed time and effective parameters
    final earliest = governor.earliestAllowedTime(
      appState: domainAppState,
      settings: domainSettings,
    );
    final minGap = governor.minimumGap(domainSettings);
    final effectiveLevel = governor.effectiveLevel(domainSettings);

    // 5. Query candidate interests
    final candidateInterests = await (db.select(db.interestsTable)
          ..where((tbl) => tbl.archivedAt.isNull() & (tbl.pushCooldownUntil.isNull() | tbl.pushCooldownUntil.isSmallerThanValue(utcNow))))
        .get();

    if (candidateInterests.isEmpty) return [];

    final domainCandidateInterests = candidateInterests
        .map(
          (i) => Interest(
            id: i.id,
            name: i.name,
            nameKey: i.nameKey,
            alpha: i.alpha,
            beta: i.beta,
            pushCooldownUntil: i.pushCooldownUntil,
            createdAt: i.createdAt,
          ),
        )
        .toList();

    final planned = <PlannedNudge>[];
    var lastPlannedTime = earliest;

    // 72-hour planning horizon across local days
    for (var dayOffset = 0; dayOffset < 3; dayOffset++) {
      if (planned.length >= 6) break;

      final targetDay = utcNow.add(Duration(days: dayOffset));
      final localDate = '${targetDay.year}-${targetDay.month.toString().padLeft(2, '0')}-${targetDay.day.toString().padLeft(2, '0')}';

      final dailyCount = governor.targetDailyCount(
        installSeed: domainAppState.installSeed,
        localDate: localDate,
        effectiveLevel: effectiveLevel,
      );

      for (var slot = 0; slot < dailyCount; slot++) {
        if (planned.length >= 6) break;

        // Deterministic candidate time within delivery windows (afternoon ~ 14:00 default)
        var candidateTime = DateTime.utc(targetDay.year, targetDay.month, targetDay.day, 14, 0);
        if (candidateTime.isBefore(lastPlannedTime.add(minGap))) {
          candidateTime = lastPlannedTime.add(minGap);
        }

        if (candidateTime.isBefore(earliest)) {
          candidateTime = earliest.add(Duration(hours: slot * 6));
        }

        // Draw interest
        final chosen = selector.pick(domainCandidateInterests);
        final interestData = candidateInterests.firstWhere((i) => i.id == chosen.id);

        // Fetch snippets
        final snippets = await (db.select(db.snippetsTable)..where((tbl) => tbl.interestId.equals(chosen.id))).get();

        String templateCode;
        String? snippetId;
        String title;
        String body;
        List<NotificationActionInfo> actions;

        if (snippets.isEmpty) {
          templateCode = 'T5_JOT_IT_DOWN';
          title = 'One thing you remember about ${interestData.name}?';
          body = 'A fact, a question, anything. Type it here.';
          actions = const [
            NotificationActionInfo(id: 'jot', label: 'Jot down', hasTextInput: true),
            NotificationActionInfo(id: 'skip', label: 'Skip'),
          ];
        } else {
          templateCode = 'T1_SPARK';
          final snippet = snippets.first;
          snippetId = snippet.id;
          title = 'A thought from ${interestData.name}';
          final excerpt = snippet.content.length > 100
              ? '${snippet.content.substring(0, 100)}...'
              : snippet.content;
          body = excerpt;
          actions = const [
            NotificationActionInfo(id: 'keep', label: 'Keep'),
            NotificationActionInfo(id: 'skip', label: 'Skip'),
            NotificationActionInfo(id: 'more', label: 'Tell me more', showsUserInterface: true),
          ];
        }

        final exposureId = uuid.v4();
        // Generate stable 31-bit positive int
        final notifId = (domainAppState.installSeed ^ candidateTime.millisecondsSinceEpoch).abs() & 0x7FFFFFFF;

        // Persist exposure
        await db.into(db.exposuresTable).insert(
              ExposuresTableCompanion.insert(
                id: exposureId,
                interestId: chosen.id,
                snippetId: Value(snippetId),
                kind: snippets.isEmpty ? 'CAPTURE_PROMPT' : 'SNIPPET',
                templateCode: templateCode,
                copyVariant: 'CALM',
                voice: 'CALM',
                channel: 'PUSH',
                notificationId: Value(notifId),
                scheduledFor: Value(candidateTime),
                surfacedAt: candidateTime,
                planReason: Value(jsonEncode({'slot': slot, 'level': effectiveLevel.name})),
              ),
            );

        // Schedule with notification gateway
        final payload = jsonEncode({'v': 1, 'exposureId': exposureId, 'template': templateCode});
        await gateway.scheduleNotification(
          id: notifId,
          title: title,
          body: body,
          scheduledDate: candidateTime,
          payload: payload,
          actions: actions,
        );

        final nudge = PlannedNudge(
          exposureId: exposureId,
          notificationId: notifId,
          interestId: chosen.id,
          snippetId: snippetId,
          templateCode: templateCode,
          scheduledFor: candidateTime,
          title: title,
          body: body,
          actions: actions,
        );

        planned.add(nudge);
        lastPlannedTime = candidateTime;
      }
    }

    return planned;
  }

  Future<void> _clearFuturePlanned(DateTime now) async {
    final futureExposures = await (db.select(db.exposuresTable)
          ..where(
            (tbl) =>
                tbl.channel.equals('PUSH') &
                tbl.reaction.equals('NONE') &
                tbl.deliveredAt.isNull() &
                tbl.scheduledFor.isBiggerThanValue(now),
          ))
        .get();

    for (final exp in futureExposures) {
      if (exp.notificationId != null) {
        await gateway.cancelNotification(exp.notificationId!);
      }
    }

    await (db.delete(db.exposuresTable)
          ..where(
            (tbl) =>
                tbl.channel.equals('PUSH') &
                tbl.reaction.equals('NONE') &
                tbl.deliveredAt.isNull() &
                tbl.scheduledFor.isBiggerThanValue(now),
          ))
        .go();
  }
}
