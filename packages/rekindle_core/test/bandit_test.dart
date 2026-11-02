import 'dart:math';
import 'package:test/test.dart';
import 'package:rekindle_core/src/bandit/beta_sampler.dart';
import 'package:rekindle_core/src/bandit/interest_selector.dart';
import 'package:rekindle_core/src/domain/models.dart';

void main() {
  group('BetaSampler statistical tests', () {
    test('Beta(1, 1) uniform distribution matches theory', () {
      final rng = Random(42);
      final sampler = BetaSampler(rng);

      const n = 10000;
      var sum = 0.0;
      var sumSq = 0.0;

      for (var i = 0; i < n; i++) {
        final val = sampler.sample(1.0, 1.0);
        sum += val;
        sumSq += val * val;
      }

      final mean = sum / n;
      final variance = (sumSq / n) - (mean * mean);

      // Theoretical mean for Beta(1, 1) is 0.5
      // Theoretical variance for Beta(1, 1) is 1/12 ~= 0.0833
      expect(mean, closeTo(0.5, 0.02));
      expect(variance, closeTo(1.0 / 12.0, 0.02));
    });

    test('Beta(20, 2) heavily skewed towards 1', () {
      final rng = Random(123);
      final sampler = BetaSampler(rng);

      const n = 10000;
      var sum = 0.0;

      for (var i = 0; i < n; i++) {
        sum += sampler.sample(20.0, 2.0);
      }

      final mean = sum / n;
      // Theoretical mean = 20 / (20 + 2) = 20 / 22 ~= 0.909
      expect(mean, closeTo(20.0 / 22.0, 0.02));
    });

    test('Beta(2, 20) heavily skewed towards 0', () {
      final rng = Random(456);
      final sampler = BetaSampler(rng);

      const n = 10000;
      var sum = 0.0;

      for (var i = 0; i < n; i++) {
        sum += sampler.sample(2.0, 20.0);
      }

      final mean = sum / n;
      // Theoretical mean = 2 / (2 + 20) = 2 / 22 ~= 0.0909
      expect(mean, closeTo(2.0 / 22.0, 0.02));
    });
  });

  group('ThompsonInterestSelector arm selection', () {
    test('arm near Beta(20, 2) beats Beta(2, 20) at least 85% of time and fresh arm still gets picked', () {
      final rng = Random(789);
      final selector = ThompsonInterestSelector(BetaSampler(rng));

      final strongArm = Interest(
        id: '1',
        name: 'Strong',
        nameKey: 'strong',
        alpha: 20.0,
        beta: 2.0,
        createdAt: DateTime.now(),
      );

      final weakArm = Interest(
        id: '2',
        name: 'Weak',
        nameKey: 'weak',
        alpha: 2.0,
        beta: 20.0,
        createdAt: DateTime.now(),
      );

      final freshArm = Interest(
        id: '3',
        name: 'Fresh',
        nameKey: 'fresh',
        alpha: 1.0,
        beta: 1.0,
        createdAt: DateTime.now(),
      );

      var strongWins = 0;
      var weakWins = 0;
      var freshWins = 0;
      const n = 10000;

      for (var i = 0; i < n; i++) {
        final chosen = selector.pick([strongArm, weakArm, freshArm]);
        if (chosen.id == strongArm.id) strongWins++;
        if (chosen.id == weakArm.id) weakWins++;
        if (chosen.id == freshArm.id) freshWins++;
      }

      // Must beat weak arm at least 85% of decisions
      expect(strongWins / n, greaterThan(0.85));
      // Fresh Beta(1, 1) arm is still explored sometimes
      expect(freshWins, greaterThan(0));
      expect(weakWins, lessThan(100));
    });
  });
}
