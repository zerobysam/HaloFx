/// Simplified educational estimates — not production-grade risk figures.
/// riskAmount is derived from balance × risk%; potentialProfit assumes a
/// default 1:2.5 reward multiple since this calculator doesn't collect a
/// take-profit price (only stop-loss/risk%). Swap in a real broker-specific
/// pip-value/margin model before shipping.
class PositionSizeResult {
  final double lots;
  final double positionValue;
  final double requiredMargin;
  final double potentialLoss;
  final double potentialProfit;
  final double riskRewardMultiple;
  final String pair;
  final String market;

  const PositionSizeResult({
    required this.lots,
    required this.positionValue,
    required this.requiredMargin,
    required this.potentialLoss,
    required this.potentialProfit,
    required this.riskRewardMultiple,
    required this.pair,
    required this.market,
  });
}
