import 'package:clock/clock.dart';
import 'package:test/test.dart';
import 'package:rekindle_core/src/domain/enums.dart';
import 'package:rekindle_core/src/domain/models.dart';
import 'package:rekindle_core/src/governor/delivery_governor.dart';
import 'package:rekindle_core/src/services/reward_mapper.dart';

void main() {
  group('DeliveryGovernor tests', () {
    final fixedNow = DateTime.utc(2026, 11, 2, 10, 0, 0);

    test('canSchedule returns false when level is OFF or permission DENIED', () {
      withClock(Clock.fixed(fixedNow), () {
        const gov = DeliveryGovernor();

        final baseAppState = AppState(
          installSeed: 1234,
          timezone: 'UTC',
          onboardingCompletedAt: fixedNow.subtract(const Duration(days: 1)),
          notificationPermission: NotificationPermissionState.granted,
          createdAt: fixedNow.subtract(const Duration(days: 1)),
        );

        final baseSettings = NotificationSettings(
          level: NotificationLevel.gentle,
        );

        expect(gov.canSchedule(appState: baseAppState, settings: baseSettings), isTrue);

        // Level OFF
        expect(
          gov.canSchedule(
            appState: baseAppState,
            settings: baseSettings.copyWith(level: NotificationLevel.off),
          ),
          isFalse,
        );

        // Permission DENIED
        final deniedAppState = AppState(
          installSeed: 1234,
          timezone: 'UTC',
          onboardingCompletedAt: fixedNow.subtract(const Duration(days: 1)),
          notificationPermission: NotificationPermissionState.denied,
          createdAt: fixedNow.subtract(const Duration(days: 1)),
        );
        expect(gov.canSchedule(appState: deniedAppState, settings: baseSettings), isFalse);

        // Paused until future
        final pausedSettings = baseSettings.copyWith(
          pausedUntil: fixedNow.add(const Duration(days: 2)),
        );
        expect(gov.canSchedule(appState: baseAppState, settings: pausedSettings), isFalse);
      });
    });

    test('earliestAllowedTime respects 3-hour app use window and 6-hour gap', () {
      withClock(Clock.fixed(fixedNow), () {
        const gov = DeliveryGovernor();

        final appState = AppState(
          installSeed: 1234,
          timezone: 'UTC',
          lastSeenAt: fixedNow.subtract(const Duration(hours: 1)), // seen 1 hour ago
          createdAt: fixedNow.subtract(const Duration(days: 1)),
        );

        final settings = NotificationSettings(
          level: NotificationLevel.gentle,
          lastNudgeAt: fixedNow.subtract(const Duration(hours: 4)), // nudged 4 hours ago
        );

        // Gap buffer: lastNudgeAt (now - 4h) + 6h = now + 2h
        // App use buffer: lastSeenAt (now - 1h) + 3h = now + 2h
        final earliest = gov.earliestAllowedTime(appState: appState, settings: settings);
        expect(earliest, equals(fixedNow.add(const Duration(hours: 2))));
      });
    });

    test('backoff rules after 3 and 6 consecutive ignored nudges', () {
      withClock(Clock.fixed(fixedNow), () {
        const gov = DeliveryGovernor();
        const settings = NotificationSettings(
          level: NotificationLevel.gentle,
        );

        // 3 in a row
        final stepped = gov.evaluateBackoffOnIgnore(
          currentSettings: settings,
          consecutiveIgnoredDelivered: 3,
        );
        expect(stepped.backoffStep, equals(1));
        expect(gov.effectiveLevel(stepped), equals(NotificationLevel.rare));
        expect(gov.minimumGap(stepped), equals(const Duration(hours: 12))); // 6h doubled

        // 6 in a row: pause for 7 days
        final paused = gov.evaluateBackoffOnIgnore(
          currentSettings: settings,
          consecutiveIgnoredDelivered: 6,
        );
        expect(paused.pausedUntil, equals(fixedNow.add(const Duration(days: 7))));

        // Any response resets
        final reset = gov.resetBackoffOnResponse(stepped);
        expect(reset.consecutiveIgnored, equals(0));
        expect(reset.backoffStep, equals(0));
        expect(gov.effectiveLevel(reset), equals(NotificationLevel.gentle));
      });
    });
  });

  group('RewardMapper tests', () {
    test('table driven reactions mapping', () {
      final keepDelta = RewardMapper.forReaction(Reaction.keep);
      expect(keepDelta.dAlpha, equals(1.0));
      expect(keepDelta.dBeta, equals(0.0));

      final skipDelta = RewardMapper.forReaction(Reaction.skip);
      expect(skipDelta.dAlpha, equals(0.0));
      expect(skipDelta.dBeta, equals(1.0));

      final lessDelta = RewardMapper.forReaction(Reaction.less);
      expect(lessDelta.dAlpha, equals(0.0));
      expect(lessDelta.dBeta, equals(1.0));
      expect(lessDelta.cooldownDuration, equals(const Duration(days: 14)));

      final notNowDelta = RewardMapper.forReaction(Reaction.notNow);
      expect(notNowDelta.dAlpha, equals(0.0));
      expect(notNowDelta.dBeta, equals(0.0));
      expect(notNowDelta.cooldownDuration, equals(const Duration(days: 3)));

      final captureDelta = RewardMapper.forReaction(Reaction.captured);
      expect(captureDelta.dAlpha, equals(1.0));
      expect(captureDelta.dBeta, equals(0.0));
      expect(captureDelta.createsSnippet, isTrue);

      final expiredDelta = RewardMapper.forReaction(Reaction.expired);
      expect(expiredDelta.dAlpha, equals(0.0));
      expect(expiredDelta.dBeta, equals(0.0));
    });
  });
}
