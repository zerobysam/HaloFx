import 'package:flutter/material.dart';
import '../../features/journal_trades/models/trade.dart';

/// Mock journal data. In-memory for now — TODO: back with a real
/// TradeRepository (local persistence first, then sync) once
/// available, same pattern as every other store in this app.
class TradeJournalStore {
  TradeJournalStore._();

  static final ValueNotifier<List<Trade>> trades = ValueNotifier<List<Trade>>(_mockTrades);

  static void addTrade(Trade trade) {
    trades.value = [trade, ...trades.value];
  }

  static double get winRatePercent {
    final closed = trades.value.where((t) => t.status == TradeStatus.closed).toList();
    if (closed.isEmpty) return 0;
    final wins = closed.where((t) => t.profit > 0).length;
    return (wins / closed.length) * 100;
  }

  static double get averageR {
    final closed = trades.value.where((t) => t.status == TradeStatus.closed).toList();
    if (closed.isEmpty) return 0;
    return closed.map((t) => t.profitR).reduce((a, b) => a + b) / closed.length;
  }

  static final List<double> balanceHistory = const [
    99655, 99820, 99640, 100100, 100450, 100280, 100900, 101300, 101050, 101800, 102200, 101950, 102483,
  ];

  static const List<String> balanceHistoryDateLabels = ['May 15', 'May 17', 'May 19', 'May 21'];

  static final List<Trade> _mockTrades = [
    Trade(
      id: 'trade_1',
      symbol: 'EUR/USD',
      market: 'Forex',
      direction: TradeDirection.buy,
      status: TradeStatus.closed,
      entryPrice: 1.17240,
      exitPrice: 1.17490,
      lotSize: 0.40,
      stopLoss: 1.17000,
      takeProfit: 1.17700,
      profit: 124.50,
      profitR: 1.25,
      date: DateTime(2026, 5, 21, 10, 32),
      duration: const Duration(hours: 2, minutes: 14),
      emotion: 'Calm',
      strategy: 'Breakout',
      session: 'London',
      notes: 'Clean breakout after news.',
      tags: const ['Breakout', 'News', 'London'],
    ),
    Trade(
      id: 'trade_2',
      symbol: 'BTC/USDT',
      market: 'Crypto',
      direction: TradeDirection.sell,
      status: TradeStatus.closed,
      entryPrice: 66210,
      exitPrice: 66780,
      lotSize: 0.10,
      profit: -52.10,
      profitR: -0.62,
      date: DateTime(2026, 5, 21, 9, 15),
      duration: const Duration(hours: 1, minutes: 5),
      strategy: 'Reversal',
      session: 'New York',
    ),
    Trade(
      id: 'trade_3',
      symbol: 'XAU/USD',
      market: 'Commodities',
      direction: TradeDirection.buy,
      status: TradeStatus.closed,
      entryPrice: 2345.10,
      exitPrice: 2351.30,
      lotSize: 0.30,
      profit: 340.22,
      profitR: 2.10,
      date: DateTime(2026, 5, 21, 8, 5),
      duration: const Duration(minutes: 48),
      strategy: 'Trend',
      session: 'London',
    ),
  ];
}
