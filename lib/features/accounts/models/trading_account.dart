import 'package:flutter/material.dart';

enum AccountCategory { propFirm, personal, archived }

/// Which 3rd/4th stat pair the account card shows (mockup varies this
/// per account: FTMO shows daily-loss-limit + risk-left gauge;
/// FundedNext shows profit-target + days-left; Personal shows
/// risk-used + leverage).
enum CardStatsVariant { dailyLossLimit, profitTarget, riskUsed }

class TradingAccount {
  final String id;
  final String name;
  final String badgeLabel; // 'FTMO', 'PERSONAL', 'FUNDEDNEXT'
  final Color badgeColor;
  final AccountCategory category;
  final CardStatsVariant cardStatsVariant;
  final double balance;
  final double equity;
  final String currency;
  final double changePercent; // shown as the top-right pill on the card
  final double dailyPnl;
  final double drawdownPercent;
  final double maxDrawdownPercent;
  final double dailyLossLimit;
  final double riskLeftToday; // dollar amount
  final double riskUsedPercent; // for Personal-style cards
  final String leverage; // '1:50'
  final double profitTargetAmount;
  final double profitTargetPercent; // 0-100 progress
  final int daysLeft;
  final int minDays;
  final String phaseLabel; // 'Challenge Phase'
  final String statusLabel; // 'Active'
  final List<double> sparkline; // small card chart
  final List<double> equityCurve; // detail screen chart
  final List<String> equityCurveDateLabels;

  const TradingAccount({
    required this.id,
    required this.name,
    required this.badgeLabel,
    required this.badgeColor,
    required this.category,
    required this.cardStatsVariant,
    required this.balance,
    required this.equity,
    required this.currency,
    required this.changePercent,
    required this.dailyPnl,
    required this.drawdownPercent,
    required this.maxDrawdownPercent,
    required this.dailyLossLimit,
    required this.riskLeftToday,
    required this.riskUsedPercent,
    required this.leverage,
    required this.profitTargetAmount,
    required this.profitTargetPercent,
    required this.daysLeft,
    required this.minDays,
    required this.phaseLabel,
    required this.statusLabel,
    required this.sparkline,
    required this.equityCurve,
    required this.equityCurveDateLabels,
  });
}
