import 'package:flutter/material.dart';
import 'package:halofx/core/widgets/halo_dashboard_cards.dart';
import '../core/theme/app_colors.dart';

// const marketSessions = <MarketSession>[
//   MarketSession('Sydney', 22 * 60, 7 * 60, AppColors.purple),
//   MarketSession('Tokyo', 0, 9 * 60, AppColors.blue),
//   MarketSession('London', 8 * 60, 16 * 60, AppColors.green),
//   MarketSession('New York', 13 * 60, 22 * 60, AppColors.orange),

//   // MarketSession(
//   //   name: 'London',
//   //   startHourUtc: 8,
//   //   endHourUtc: 16,
//   //   color: Color(0xFF20D987),
//   // ),
//   // MarketSession(
//   //   name: 'New York',
//   //   startHourUtc: 13,
//   //   endHourUtc: 22,
//   //   color: Color(0xFFFF9A16),
//   // ),
// ];

class PlannerPreview {
  const PlannerPreview({
    required this.name,
    required this.subtitle,
    required this.timeLabel,
    required this.assets,
  });

  final String name;
  final String subtitle;
  final String timeLabel;
  final List<String> assets;
}

const nextPlanner = PlannerPreview(
  name: 'London Breakout Plan',
  subtitle: '15 min After Open',
  timeLabel: '08:31',
  assets: ['EURUSD', 'GBPUSD', 'XAUUSD', '+1'],
);

class CalculatorPreview {
  const CalculatorPreview({
    required this.name,
    required this.details,
  });

  final String name;
  final String details;
}

const lastCalculator = CalculatorPreview(
  name: 'Dynamic Position Size',
  details: 'BTCUSDT  •  Long  •  20x',
);
