import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/calculator_access_level.dart';
import '../models/calculator_item.dart';
import '../screens/currency_converter_screen.dart';
import '../screens/drawdown_calculator_screen.dart';
import '../screens/futures_calculator_screen.dart';
import '../screens/margin_calculator_screen.dart' show MarginCalculatorScreen;
import '../screens/pip_value_calculator_screen.dart';
import '../screens/position_size_screen.dart';
import '../screens/profit_loss_calculator_screen.dart' show ProfitLossCalculatorScreen;
import '../screens/risk_reward_calculator_screen.dart' show RiskRewardCalculatorScreen;

final List<CalculatorItem> calculatorItems = [
  CalculatorItem(
    id: 'position_size',
    title: 'Position Size',
    subtitle: 'Calculate ideal position size',
    icon: Icons.straighten_rounded,
    iconColor: AppColors.primaryLight,
    categories: const ['forex', 'futures'],
    isFavorite: true,
    screenBuilder: () => (_) => const PositionSizeScreen(),
  ),
  CalculatorItem(
    id: 'futures_calc',
    title: 'Futures Calc',
    subtitle: 'For perpetual & futures markets',
    icon: Icons.bolt_rounded,
    iconColor: AppColors.gold,
    categories: const ['crypto', 'futures'],
    screenBuilder: () => (_) => const FuturesCalculatorScreen(),
  ),
  CalculatorItem(
    id: 'pip_value',
    title: 'Pip Value',
    subtitle: 'Calculate pip value easily',
    icon: Icons.grain_rounded,
    iconColor: AppColors.textLink,
    categories: const ['forex'],
    screenBuilder: () => (_) => const PipValueCalculatorScreen(),
  ),
  CalculatorItem(
    id: 'profit_loss',
    title: 'Profit & Loss',
    subtitle: 'Calculate P&L instantly',
    icon: Icons.show_chart_rounded,
    iconColor: AppColors.success,
    categories: const ['forex', 'crypto', 'futures'],
    screenBuilder: () => (_) => const ProfitLossCalculatorScreen(),
  ),
  CalculatorItem(
    id: 'converter',
    title: 'Converter',
    subtitle: 'Currency converter',
    icon: Icons.swap_horiz_rounded,
    iconColor: AppColors.primaryLight,
    categories: const ['forex', 'crypto'],
    screenBuilder: () => (_) => const CurrencyConverterScreen(),
  ),
  // Login-required calculators — gated via CalculatorAccessLevel.requiresLogin.
  // Add more here as needed; the Hub and card badge pick it up automatically.
  CalculatorItem(
    id: 'drawdown_rec',
    title: 'Drawdown Rec.',
    subtitle: 'Plan your recovery',
    icon: Icons.trending_down_rounded,
    iconColor: AppColors.danger,
    categories: const ['forex', 'futures', 'crypto', 'stocks'],
    accessLevel: CalculatorAccessLevel.requiresLogin,
    screenBuilder: () => (_) => const DrawdownCalculatorScreen(),
  ),
  CalculatorItem(
    id: 'risk_reward_calc',
    title: 'Risk Reward',
    subtitle: 'Calculate risk-to-reward ratio',
    icon: Icons.balance_rounded,
    iconColor: const Color(0xFF8C7CFF),
    categories: const ['forex', 'crypto', 'stocks', 'futures'],
    accessLevel: CalculatorAccessLevel.requiresLogin,
    screenBuilder: () => (_) => const RiskRewardCalculatorScreen(),
  ),
  CalculatorItem(
    id: 'margin_calc',
    title: 'Margin Calc',
    subtitle: 'Calculate required margin',
    icon: Icons.grid_view_rounded,
    iconColor: AppColors.primaryLight,
    categories: const ['forex', 'futures', 'crypto'],
    screenBuilder: () => (_) => const MarginCalculatorScreen(),
  ),
];
