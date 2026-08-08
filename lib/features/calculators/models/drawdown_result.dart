class DrawdownResult {
  final double peakBalance;
  final double currentBalance;
  final double drawdownPercentage;
  final double moneyLost;
  final double recoveryNeededPercentage;
  final double recoveryAmount;
  final double breakEvenBalance;
  final String currency;
  final String currencySymbol;

  const DrawdownResult({
    required this.peakBalance,
    required this.currentBalance,
    required this.drawdownPercentage,
    required this.moneyLost,
    required this.recoveryNeededPercentage,
    required this.recoveryAmount,
    required this.breakEvenBalance,
    required this.currency,
    required this.currencySymbol,
  });

  String get riskLevel {
    if (drawdownPercentage <= 10) return 'Low';
    if (drawdownPercentage <= 25) return 'Moderate';
    if (drawdownPercentage <= 50) return 'High';
    return 'Critical';
  }
}
