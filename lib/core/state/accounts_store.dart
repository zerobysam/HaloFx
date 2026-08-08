import 'package:flutter/material.dart';
import '../../features/accounts/models/trading_account.dart';

/// Mock account data + selection state. In-memory for now, same
/// ValueNotifier pattern as AuthStatus/PremiumStatus — TODO: back
/// with AccountsRepository once there's a real backend.
class AccountsStore {
  AccountsStore._();

  static final ValueNotifier<List<TradingAccount>> accounts =
      ValueNotifier<List<TradingAccount>>(_mockAccounts);

  static final ValueNotifier<TradingAccount> selectedAccount =
      ValueNotifier<TradingAccount>(_mockAccounts.first);

  static void select(TradingAccount account) => selectedAccount.value = account;

  static final List<TradingAccount> _mockAccounts = [
    TradingAccount(
      id: 'ftmo_challenge',
      name: 'FTMO Challenge',
      badgeLabel: 'FTMO',
      badgeColor: const Color(0xFF7C5CFC),
      category: AccountCategory.propFirm,
      cardStatsVariant: CardStatsVariant.dailyLossLimit,
      balance: 10542.00,
      equity: 10652.75,
      currency: 'USD',
      changePercent: 6.24,
      dailyPnl: 110.75,
      drawdownPercent: 2.34,
      maxDrawdownPercent: 10.0,
      dailyLossLimit: 1000.0,
      riskLeftToday: 432.50,
      riskUsedPercent: 0.82,
      leverage: '1:100',
      profitTargetAmount: 10000.0,
      profitTargetPercent: 62.0,
      daysLeft: 18,
      minDays: 10,
      phaseLabel: 'Challenge Phase',
      statusLabel: 'Active',
      sparkline: const [10200, 10250, 10180, 10300, 10420, 10380, 10480, 10542],
      equityCurve: const [9000, 9200, 9050, 9400, 9700, 9550, 9900, 10100, 9950, 10300, 10500, 10652],
      equityCurveDateLabels: const ['May 1', 'May 8', 'May 15', 'May 22', 'May 29'],
    ),
    TradingAccount(
      id: 'personal',
      name: 'Personal Account',
      badgeLabel: 'PERSONAL',
      badgeColor: const Color(0xFF22C55E),
      category: AccountCategory.personal,
      cardStatsVariant: CardStatsVariant.riskUsed,
      balance: 3241.75,
      equity: 3185.30,
      currency: 'USD',
      changePercent: -1.73,
      dailyPnl: -56.45,
      drawdownPercent: 4.12,
      maxDrawdownPercent: 15.0,
      dailyLossLimit: 500.0,
      riskLeftToday: 250.0,
      riskUsedPercent: 0.65,
      leverage: '1:50',
      profitTargetAmount: 0,
      profitTargetPercent: 0,
      daysLeft: 0,
      minDays: 0,
      phaseLabel: 'Live Account',
      statusLabel: 'Active',
      sparkline: const [3400, 3350, 3300, 3250, 3280, 3220, 3200, 3241],
      equityCurve: const [3600, 3500, 3400, 3450, 3300, 3350, 3250, 3200, 3150, 3185],
      equityCurveDateLabels: const ['May 1', 'May 8', 'May 15', 'May 22', 'May 29'],
    ),
    TradingAccount(
      id: 'fundednext',
      name: 'FundedNext Eval',
      badgeLabel: 'FUNDEDNEXT',
      badgeColor: const Color(0xFFF59E0B),
      category: AccountCategory.propFirm,
      cardStatsVariant: CardStatsVariant.profitTarget,
      balance: 25000.00,
      equity: 25420.80,
      currency: 'USD',
      changePercent: 2.45,
      dailyPnl: 420.80,
      drawdownPercent: 1.28,
      maxDrawdownPercent: 8.0,
      dailyLossLimit: 1250.0,
      riskLeftToday: 980.0,
      riskUsedPercent: 0.35,
      leverage: '1:100',
      profitTargetAmount: 25000.0,
      profitTargetPercent: 62.0,
      daysLeft: 18,
      minDays: 5,
      phaseLabel: 'Evaluation Phase',
      statusLabel: 'Active',
      sparkline: const [24200, 24350, 24300, 24500, 24700, 24900, 25100, 25000],
      equityCurve: const [23000, 23400, 23200, 23800, 24100, 24000, 24500, 24800, 24600, 25000, 25200, 25420],
      equityCurveDateLabels: const ['May 1', 'May 8', 'May 15', 'May 22', 'May 29'],
    ),
  ];
}
