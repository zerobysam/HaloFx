class RiskRewardResult {
  final double riskPips;
  final double rewardPips;
  final double ratio;

  const RiskRewardResult({
    required this.riskPips,
    required this.rewardPips,
    required this.ratio,
  });

  String get formattedRatio => '1 : ${ratio.toStringAsFixed(2)}';
}
