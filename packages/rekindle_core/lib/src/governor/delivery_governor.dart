import 'dart:math';
import 'package:clock/clock.dart' as pclock;
import '../domain/enums.dart';
import '../domain/models.dart';

final class DeliveryGovernor {
  const DeliveryGovernor({pclock.Clock? clock}) : _clock = clock;

  final pclock.Clock? _clock;

  DateTime get _now => (_clock ?? pclock.clock).now();

  /// Effective minimum gap between nudges based on settings and backoff step.
  Duration minimumGap(NotificationSettings settings) {
    var baseGap = settings.level == NotificationLevel.more
        ? const Duration(hours: 4)
        : const Duration(hours: 6);

    if (settings.backoffStep > 0) {
      baseGap = baseGap * 2;
    }
    return baseGap;
  }

  /// Effective notification level considering backoff step.
  /// (User's chosen level is never overwritten in settings, but backoff drops by one level).
  NotificationLevel effectiveLevel(NotificationSettings settings) {
    if (settings.level == NotificationLevel.off) return NotificationLevel.off;
    if (settings.backoffStep == 0) return settings.level;

    return switch (settings.level) {
      NotificationLevel.more => NotificationLevel.gentle,
      NotificationLevel.gentle => NotificationLevel.rare,
      NotificationLevel.rare => NotificationLevel.rare,
      NotificationLevel.off => NotificationLevel.off,
    };
  }

  /// Determines if nudges can be scheduled at all right now.
  bool canSchedule({
    required AppState appState,
    required NotificationSettings settings,
  }) {
    if (!appState.isOnboardingCompleted) return false;
    if (appState.notificationPermission == NotificationPermissionState.denied) return false;
    if (settings.level == NotificationLevel.off) return false;

    final now = _now;
    if (settings.pausedUntil != null && settings.pausedUntil!.isAfter(now)) {
      return false;
    }

    return true;
  }

  /// Earliest allowed time for the next nudge.
  DateTime earliestAllowedTime({
    required AppState appState,
    required NotificationSettings settings,
  }) {
    final now = _now;
    var earliest = now;

    // Must not be within 3 hours of recent app usage
    if (appState.lastSeenAt != null) {
      final appUseBuffer = appState.lastSeenAt!.add(const Duration(hours: 3));
      if (appUseBuffer.isAfter(earliest)) {
        earliest = appUseBuffer;
      }
    }

    // Must respect minimum gap from last nudge
    if (settings.lastNudgeAt != null) {
      final gapBuffer = settings.lastNudgeAt!.add(minimumGap(settings));
      if (gapBuffer.isAfter(earliest)) {
        earliest = gapBuffer;
      }
    }

    // Must respect pause duration
    if (settings.pausedUntil != null && settings.pausedUntil!.isAfter(earliest)) {
      earliest = settings.pausedUntil!;
    }

    return earliest;
  }

  /// Target number of nudges for a given local day.
  int targetDailyCount({
    required int installSeed,
    required String localDate, // YYYY-MM-DD
    required NotificationLevel effectiveLevel,
  }) {
    switch (effectiveLevel) {
      case NotificationLevel.off:
        return 0;
      case NotificationLevel.rare:
        // Probability 2/7, seeded by hash(install_seed, localDate)
        final seed = installSeed ^ localDate.hashCode;
        final rng = Random(seed);
        return rng.nextDouble() < (2.0 / 7.0) ? 1 : 0;
      case NotificationLevel.gentle:
        return 1;
      case NotificationLevel.more:
        // 20% for 1, 40% for 2, 40% for 3
        final seed = installSeed ^ localDate.hashCode;
        final rng = Random(seed);
        final roll = rng.nextDouble();
        if (roll < 0.20) return 1;
        if (roll < 0.60) return 2;
        return 3;
    }
  }

  /// Evaluates backoff rules after consecutive ignored delivered nudges.
  NotificationSettings evaluateBackoffOnIgnore({
    required NotificationSettings currentSettings,
    required int consecutiveIgnoredDelivered,
  }) {
    final now = _now;
    if (consecutiveIgnoredDelivered >= 6) {
      // 6 in a row: pause for 7 days and trigger quiet card
      return currentSettings.copyWith(
        consecutiveIgnored: consecutiveIgnoredDelivered,
        backoffStep: 1,
        pausedUntil: now.add(const Duration(days: 7)),
      );
    } else if (consecutiveIgnoredDelivered >= 3) {
      // 3 in a row: drop one level and double gap
      return currentSettings.copyWith(
        consecutiveIgnored: consecutiveIgnoredDelivered,
        backoffStep: 1,
      );
    }
    return currentSettings.copyWith(
      consecutiveIgnored: consecutiveIgnoredDelivered,
    );
  }

  /// Resets backoff state on any response.
  NotificationSettings resetBackoffOnResponse(NotificationSettings currentSettings) {
    return currentSettings.copyWith(
      consecutiveIgnored: 0,
      backoffStep: 0,
    );
  }
}
