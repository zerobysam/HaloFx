/// Simplified educational estimates — not production-grade risk figures.
/// Swap the formulas in futures_calculator_screen.dart for real
/// exchange-specific margin/fee/funding logic before shipping.
class FuturesCalculationResult {
  final double recommendedPositionSize; // in base asset units (e.g. BTC)
  final double positionValue; // USD/USDC
  final double marginRequired;
  final double liquidationPrice;
  final double maxLoss;
  final double maxLossPercent;
  final double potentialProfit;
  final double potentialProfitPercent;
  final double riskRewardRatio;
  final double estFees;
  final double estFunding;
  final String asset;
  final String direction;
  final int leverage;

  const FuturesCalculationResult({
    required this.recommendedPositionSize,
    required this.positionValue,
    required this.marginRequired,
    required this.liquidationPrice,
    required this.maxLoss,
    required this.maxLossPercent,
    required this.potentialProfit,
    required this.potentialProfitPercent,
    required this.riskRewardRatio,
    required this.estFees,
    required this.estFunding,
    required this.asset,
    required this.direction,
    required this.leverage,
  });
}
