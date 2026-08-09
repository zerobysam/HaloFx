import 'package:flutter/material.dart';

enum TradeDirection { buy, sell }
enum TradeStatus { open, closed }

class TradeEntry {
  final String id;
  final String symbol;
  final String market;
  final IconData symbolIcon;
  final Color symbolIconColor;
  final TradeDirection direction;
  final TradeStatus status;
  final double entryPrice;
  final double exitPrice;
  final double? stopLoss;
  final double? takeProfit;
  final double lotSize;
  final double profit;
  final double profitR; // R-multiple
  final DateTime date;
  final String? duration;
  final String? aiEmotion;
  final String? aiStrategy;
  final String? aiSession;
  final String? aiNotes;
  final List<String> tags;

  const TradeEntry({
    required this.id,
    required this.symbol,
    required this.market,
    required this.symbolIcon,
    required this.symbolIconColor,
    required this.direction,
    required this.status,
    required this.entryPrice,
    required this.exitPrice,
    this.stopLoss,
    this.takeProfit,
    required this.lotSize,
    required this.profit,
    required this.profitR,
    required this.date,
    this.duration,
    this.aiEmotion,
    this.aiStrategy,
    this.aiSession,
    this.aiNotes,
    this.tags = const [],
  });
}
