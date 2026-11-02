import '../domain/models.dart';
import 'beta_sampler.dart';

abstract interface class InterestSelector {
  Interest pick(List<Interest> eligible);
}

final class ThompsonInterestSelector implements InterestSelector {
  ThompsonInterestSelector(this._sampler);

  final BetaSampler _sampler;

  @override
  Interest pick(List<Interest> eligible) {
    if (eligible.isEmpty) {
      throw ArgumentError('Cannot pick from an empty list of eligible interests');
    }

    Interest? best;
    var bestDraw = -1.0;
    for (final interest in eligible) {
      // Draw exactly once per interest per decision
      final draw = _sampler.sample(interest.alpha, interest.beta);
      if (draw > bestDraw) {
        bestDraw = draw;
        best = interest;
      }
    }
    return best!;
  }
}
