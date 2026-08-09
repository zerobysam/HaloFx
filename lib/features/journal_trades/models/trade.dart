enum TradeDirection { buy, sell }

enum TradeStatus { open, closed }

class Trade {
  final String id;
  final String symbol;
  final String market;
  final TradeDirection direction;
  final TradeStatus status;
  final double entryPrice;
  final double exitPrice;
  final double lotSize;
  final double? stopLoss;
  final double? takeProfit;
  final double profit; // dollar P&L, negative if a loss
  final double profitR; // profit expressed in R-multiples
  final DateTime date;
  final Duration duration;
  final String? emotion;
  final String? strategy;
  final String? session;
  final String? notes;
  final List<String> tags;

  const Trade({
    required this.id,
    required this.symbol,
    required this.market,
    required this.direction,
    required this.status,
    required this.entryPrice,
    required this.exitPrice,
    required this.lotSize,
    this.stopLoss,
    this.takeProfit,
    required this.profit,
    required this.profitR,
    required this.date,
    required this.duration,
    this.emotion,
    this.strategy,
    this.session,
    this.notes,
    this.tags = const [],
  });
}
