import 'package:flutter/material.dart';
import '../../features/journal/models/trade_entry.dart';

/// Mock trade journal data, same ValueNotifier pattern as
/// AuthStatus/AccountsStore. TODO: back with a real repository once
/// there's a backend — trades would sync per-account.
class JournalStore {
  JournalStore._();

  static final ValueNotifier<List<TradeEntry>> trades =
      ValueNotifier<List<TradeEntry>>(_mockTrades);

  static void add(TradeEntry trade) {
    trades.value = [trade, ...trades.value];
  }

  static double get winRatePercent {
    final closed = trades.value.where((t) => t.status == TradeStatus.closed).toList();
    if (closed.isEmpty) return 0;
    final wins = closed.where((t) => t.profit > 0).length;
    return (wins / closed.length) * 100;
  }

  static double get avgRMultiple {
    final closed = trades.value.where((t) => t.status == TradeStatus.closed).toList();
    if (closed.isEmpty) return 0;
    return closed.fold<double>(0, (sum, t) => sum + t.profitR) / closed.length;
  }

  static final List<TradeEntry> _mockTrades = [
    TradeEntry(
      id: 'trade_1',
      symbol: 'EUR/USD',
      market: 'Forex',
      symbolIcon: Icons.currency_exchange_rounded,
      symbolIconColor: const Color(0xFF3B82F6),
      direction: TradeDirection.buy,
      status: TradeStatus.closed,
      entryPrice: 1.17240,
      exitPrice: 1.17490,
      stopLoss: 1.17000,
      takeProfit: 1.17700,
      lotSize: 0.40,
      profit: 124.50,
      profitR: 1.25,
      date: DateTime(2026, 5, 21, 10, 32),
      duration: '2h 14m',
      aiEmotion: 'Calm',
      aiStrategy: 'Breakout',
      aiSession: 'London',
      aiNotes: 'Clean breakout after news.',
      tags: const ['Breakout', 'News', 'London'],
    ),
    TradeEntry(
      id: 'trade_2',
      symbol: 'BTC/USDT',
      market: 'Crypto',
      symbolIcon: Icons.currency_bitcoin_rounded,
      symbolIconColor: const Color(0xFFF59E0B),
      direction: TradeDirection.sell,
      status: TradeStatus.closed,
      entryPrice: 66210,
      exitPrice: 66780,
      lotSize: 0.10,
      profit: -52.10,
      profitR: -0.6,
      date: DateTime(2026, 5, 21, 9, 15),
      duration: '48m',
      aiEmotion: 'Frustrated',
      aiStrategy: 'Reversal',
      aiSession: 'New York',
      tags: const ['Reversal'],
    ),
    TradeEntry(
      id: 'trade_3',
      symbol: 'XAU/USD',
      market: 'Commodities',
      symbolIcon: Icons.circle,
      symbolIconColor: const Color(0xFFFBBF24),
      direction: TradeDirection.buy,
      status: TradeStatus.closed,
      entryPrice: 2345.10,
      exitPrice: 2351.30,
      lotSize: 0.30,
      profit: 340.22,
      profitR: 2.1,
      date: DateTime(2026, 5, 21, 8, 5),
      duration: '1h 05m',
      aiEmotion: 'Confident',
      aiStrategy: 'Trend Following',
      aiSession: 'London',
      tags: const ['Trend', 'Gold'],
    ),
    TradeEntry(
      id: 'trade_4',
      symbol: 'GBP/USD',
      market: 'Forex',
      symbolIcon: Icons.currency_exchange_rounded,
      symbolIconColor: const Color(0xFF3B82F6),
      direction: TradeDirection.sell,
      status: TradeStatus.closed,
      entryPrice: 1.26900,
      exitPrice: 1.26400,
      lotSize: 0.25,
      profit: -128.40,
      profitR: -1.1,
      date: DateTime(2026, 5, 20, 14, 0),
      duration: '3h 40m',
      aiEmotion: 'Anxious',
      aiStrategy: 'Range',
      aiSession: 'New York',
      tags: const ['Range'],
    ),
  ];
}
