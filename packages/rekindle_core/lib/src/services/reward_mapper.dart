import '../domain/enums.dart';

final class RewardDelta {
  const RewardDelta({
    required this.dAlpha,
    required this.dBeta,
    this.cooldownDuration,
    this.createsSnippet = false,
  });

  final double dAlpha;
  final double dBeta;
  final Duration? cooldownDuration;
  final bool createsSnippet;
}

final class RewardMapper {
  const RewardMapper();

  static RewardDelta forReaction(Reaction reaction) {
    return switch (reaction) {
      Reaction.keep => const RewardDelta(dAlpha: 1.0, dBeta: 0.0),
      Reaction.explore => const RewardDelta(dAlpha: 1.0, dBeta: 0.0),
      Reaction.yes => const RewardDelta(dAlpha: 1.0, dBeta: 0.0),
      Reaction.captured => const RewardDelta(
          dAlpha: 1.0,
          dBeta: 0.0,
          createsSnippet: true,
        ),
      Reaction.pickA || Reaction.pickB => const RewardDelta(dAlpha: 1.0, dBeta: 0.0),
      Reaction.skip => const RewardDelta(dAlpha: 0.0, dBeta: 1.0),
      Reaction.less => const RewardDelta(
          dAlpha: 0.0,
          dBeta: 1.0,
          cooldownDuration: Duration(days: 14),
        ),
      Reaction.notNow => const RewardDelta(
          dAlpha: 0.0,
          dBeta: 0.0,
          cooldownDuration: Duration(days: 3),
        ),
      Reaction.neither => const RewardDelta(dAlpha: 0.0, dBeta: 0.0),
      Reaction.expired || Reaction.none => const RewardDelta(dAlpha: 0.0, dBeta: 0.0),
    };
  }
}
