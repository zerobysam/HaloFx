class ProfitLossResult {
  final double grossProfit;
  final double netProfit;
  final double commission;
  final double swap;
  final double pips;
  final double roi;
  final double entryPrice;
  final double exitPrice;
  final double lotSize;
  final String direction; // 'Long' or 'Short'
  final String accountCurrency;

  const ProfitLossResult({
    required this.grossProfit,
    required this.netProfit,
    required this.commission,
    required this.swap,
    required this.pips,
    required this.roi,
    required this.entryPrice,
    required this.exitPrice,
    required this.lotSize,
    required this.direction,
    required this.accountCurrency,
  });

  bool get isProfit => netProfit >= 0;

  String get performanceLabel {
    if (netProfit > 300) return 'Excellent';
    if (netProfit > 0) return 'Good';
    if (netProfit == 0) return 'Break Even';
    return 'Loss';
  }
}
