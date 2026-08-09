import 'package:flutter/material.dart';
import '../../../core/state/accounts_store.dart';
import '../../../core/state/trade_journal_store.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/equity_curve_chart.dart';
import '../widgets/journal_bottom_nav.dart';

class BalanceHistoryScreen extends StatefulWidget {
  const BalanceHistoryScreen({super.key});

  @override
  State<BalanceHistoryScreen> createState() => _BalanceHistoryScreenState();
}

class _BalanceHistoryScreenState extends State<BalanceHistoryScreen> {
  static const _timeframes = ['1W', '1M', '3M', '1Y', 'All'];
  String _timeframe = '1W';

  @override
  Widget build(BuildContext context) {
    final account = AccountsStore.selectedAccount.value;
    final history = TradeJournalStore.balanceHistory;
    final startingBalance = history.first;
    final netProfit = account.balance - startingBalance;
    final netProfitPercent = (netProfit / startingBalance) * 100;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 20, 4),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
                  ),
                  Text('Balance History', style: AppTypography.headlineSmall.copyWith(fontSize: 17)),
                  const Spacer(),
                  const Icon(Icons.filter_list_rounded, color: AppColors.textSecondary, size: 20),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(account.name, style: AppTypography.caption),
                    const SizedBox(height: 4),
                    Text('\$${account.balance.toStringAsFixed(2)}', style: AppTypography.numberLarge.copyWith(fontSize: 28)),
                    const SizedBox(height: 4),
                    Text(
                      '${netProfit >= 0 ? '+' : ''}${netProfitPercent.toStringAsFixed(2)}% (${netProfit >= 0 ? '+' : ''}\$${netProfit.toStringAsFixed(2)})',
                      style: AppTypography.bodyMedium.copyWith(color: netProfit >= 0 ? AppColors.success : AppColors.danger, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: AppColors.bgElevated, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
                      child: EquityCurveChart(
                        data: history,
                        dateLabels: TradeJournalStore.balanceHistoryDateLabels,
                        lineColor: netProfit >= 0 ? AppColors.primaryLight : AppColors.danger,
                      ),
                    ),
                    const SizedBox(height: 14),

                    Row(
                      children: _timeframes.map((tf) {
                        final isActive = tf == _timeframe;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _timeframe = tf),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              padding: const EdgeInsets.symmetric(vertical: 9),
                              decoration: BoxDecoration(color: isActive ? AppColors.primary : AppColors.bgElevated, borderRadius: BorderRadius.circular(9), border: Border.all(color: isActive ? AppColors.primary : AppColors.border)),
                              alignment: Alignment.center,
                              child: Text(tf, style: AppTypography.bodySmall.copyWith(fontSize: 12.5, fontWeight: FontWeight.w700, color: isActive ? Colors.white : AppColors.textSecondary)),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(child: _statBox('Starting Balance', '\$${startingBalance.toStringAsFixed(2)}')),
                        const SizedBox(width: 10),
                        Expanded(child: _statBox('Net Profit', '${netProfit >= 0 ? '+' : ''}\$${netProfit.toStringAsFixed(2)}', valueColor: netProfit >= 0 ? AppColors.success : AppColors.danger)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: _statBox('Max Drawdown', '${account.maxDrawdownPercent.toStringAsFixed(2)}%')),
                        const SizedBox(width: 10),
                        Expanded(child: _statBox('Avg Daily Risk', '${account.riskUsedPercent.toStringAsFixed(2)}%')),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const JournalBottomNav(current: JournalTab.analytics),
    );
  }

  Widget _statBox(String label, String value, {Color? valueColor}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.bgElevated, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.caption),
          const SizedBox(height: 4),
          Text(value, style: AppTypography.bodyLarge.copyWith(fontSize: 15, fontWeight: FontWeight.w700, color: valueColor ?? AppColors.textPrimary)),
        ],
      ),
    );
  }
}
