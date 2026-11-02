import 'dart:math';

final class BetaSampler {
  BetaSampler(this._rng);
  final Random _rng;

  double sample(double a, double b) {
    final safeA = max(0.01, a);
    final safeB = max(0.01, b);
    final x = _gamma(safeA);
    final y = _gamma(safeB);
    final s = x + y;
    return s == 0 ? 0.5 : x / s;
  }

  // Marsaglia-Tsang method; shape < 1 uses the boost gamma(k + 1) * u^(1/k)
  double _gamma(double k) {
    if (k < 1) {
      return _gamma(k + 1) * pow(_rng.nextDouble(), 1 / k);
    }
    final d = k - 1 / 3;
    final c = 1 / sqrt(9 * d);
    while (true) {
      double x, v;
      do {
        x = _normal();
        v = 1 + c * x;
      } while (v <= 0);
      v = v * v * v;
      final u = _rng.nextDouble();
      if (u < 1 - 0.0331 * x * x * x * x ||
          log(u) < 0.5 * x * x + d * (1 - v + log(v))) {
        return d * v;
      }
    }
  }

  // Box-Muller transform for standard normal random variable
  double _normal() {
    return sqrt(-2 * log(1 - _rng.nextDouble())) * cos(2 * pi * _rng.nextDouble());
  }
}
