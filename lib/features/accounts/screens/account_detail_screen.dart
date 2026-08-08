import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/circular_gauge.dart';
import '../../../core/widgets/equity_curve_chart.dart';
import '../../calculators/screens/risk_calculator_screen.dart';
import '../models/trading_account.dart';

class AccountDetailScreen extends StatefulWidget {
  final TradingAccount account;

  const AccountDetailScreen({super.key, required this.account});

  @override
  State<AccountDetailScreen> createState() => _AccountDetailScreenState();
}

class _AccountDetailScreenState extends State<AccountDetailScreen> {
  static const _tabs = ['Overview', 'Performance', 'Trades', 'Rules'];
  int _tabIndex = 0;

  String _fmt(double v) {
    final isNeg = v < 0;
    final parts = v.abs().toStringAsFixed(2).split('.');
    final intPart = parts[0].replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',');
    return '${isNeg ? '-' : ''}\$$intPart.${parts[1]}';
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.account;
    final changeUp = a.changePercent >= 0;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 20, 4),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
                  ),
                  Expanded(
                    child: Text(a.name, textAlign: TextAlign.center, style: AppTypography.headlineSmall.copyWith(fontSize: 17)),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_horiz_rounded, color: AppColors.textSecondary, size: 22),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badges
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: a.badgeColor, borderRadius: BorderRadius.circular(6)),
                          child: Text(a.badgeLabel, style: AppTypography.caption.copyWith(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 10)),
                        ),
                        const SizedBox(width: 8),
                        Text(a.phaseLabel, style: AppTypography.bodySmall.copyWith(fontSize: 12.5)),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: AppColors.success.withOpacity(0.15), borderRadius: BorderRadius.circular(100)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle)),
                              const SizedBox(width: 5),
                              Text(a.statusLabel, style: AppTypography.bodySmall.copyWith(fontSize: 12, color: AppColors.success, fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(_fmt(a.balance), style: AppTypography.numberLarge.copyWith(fontSize: 32)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Equity', style: AppTypography.caption),
                              const SizedBox(height: 2),
                              Text(_fmt(a.equity), style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600, fontSize: 15)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Account Currency', style: AppTypography.caption),
                              const SizedBox(height: 2),
                              Text(a.currency, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w700, fontSize: 15)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Tabs
                    Row(
                      children: List.generate(_tabs.length, (i) {
                        final isActive = i == _tabIndex;
                        return Padding(
                          padding: const EdgeInsets.only(right: 22),
                          child: GestureDetector(
                            onTap: () => setState(() => _tabIndex = i),
                            child: Column(
                              children: [
                                Text(
                                  _tabs[i],
                                  style: AppTypography.bodyMedium.copyWith(
                                    fontSize: 14,
                                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                                    color: isActive ? AppColors.primaryLight : AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  height: 2.5,
                                  width: 20,
                                  color: isActive ? AppColors.primaryLight : Colors.transparent,
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                    Divider(color: AppColors.divider, height: 1),
                    const SizedBox(height: 18),

                    if (_tabIndex == 0) ..._buildOverview(a, changeUp) else _buildPlaceholderTab(_tabs[_tabIndex]),

                    const SizedBox(height: 100), // room for the fixed bottom bar
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomActions(context),
    );
  }

  List<Widget> _buildOverview(TradingAccount a, bool changeUp) {
    return [
      // Equity curve card
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.bgElevated, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Equity Curve', style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w700, fontSize: 15)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(color: AppColors.bgInput, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.border)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('30D', style: AppTypography.bodySmall.copyWith(fontSize: 12.5)),
                      const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textTertiary, size: 16),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '+\$${(a.equity - a.equityCurve.first).toStringAsFixed(2)} (${a.changePercent.toStringAsFixed(2)}%)',
              style: AppTypography.bodyMedium.copyWith(color: changeUp ? AppColors.success : AppColors.danger, fontWeight: FontWeight.w700, fontSize: 14),
            ),
            const SizedBox(height: 14),
            EquityCurveChart(
              data: a.equityCurve,
              dateLabels: a.equityCurveDateLabels,
              lineColor: changeUp ? AppColors.primaryLight : AppColors.danger,
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),

      // Stats grid
      Row(
        children: [
          Expanded(child: _StatBox(icon: Icons.account_balance_wallet_rounded, iconColor: AppColors.primaryLight, label: 'Balance', value: _fmt(a.balance))),
          const SizedBox(width: 10),
          Expanded(child: _StatBox(icon: Icons.show_chart_rounded, iconColor: AppColors.textLink, label: 'Equity', value: _fmt(a.equity))),
          const SizedBox(width: 10),
          Expanded(child: _StatBox(icon: Icons.bolt_rounded, iconColor: AppColors.success, label: 'Daily PnL', value: '${a.dailyPnl >= 0 ? '+' : ''}${_fmt(a.dailyPnl)}', valueColor: a.dailyPnl >= 0 ? AppColors.success : AppColors.danger)),
        ],
      ),
      const SizedBox(height: 10),
      Row(
        children: [
          Expanded(child: _StatBox(label: 'Drawdown', value: '${a.drawdownPercent.toStringAsFixed(2)}%', progress: a.drawdownPercent / a.maxDrawdownPercent, progressColor: AppColors.primaryLight)),
          const SizedBox(width: 10),
          Expanded(child: _StatBox(label: 'Max Drawdown', value: '${a.maxDrawdownPercent.toStringAsFixed(2)}%')),
          const SizedBox(width: 10),
          Expanded(child: _StatBox(label: 'Daily Loss Limit', value: _fmt(a.dailyLossLimit))),
        ],
      ),
      const SizedBox(height: 10),
      Row(
        children: [
          Expanded(child: _StatBox(label: 'Profit Target', value: _fmt(a.profitTargetAmount), sublabel: '${a.profitTargetPercent.toStringAsFixed(0)}%', progress: a.profitTargetPercent / 100, progressColor: AppColors.success)),
          const SizedBox(width: 10),
          Expanded(child: _StatBox(label: 'Days Left', value: '${a.daysLeft}', sublabel: 'Min. ${a.minDays} days')),
          const SizedBox(width: 10),
          Expanded(child: _StatBox(label: 'Leverage', value: a.leverage)),
        ],
      ),
      const SizedBox(height: 16),

      // Risk summary
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.bgElevated, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Risk Summary', style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w700, fontSize: 15)),
            const SizedBox(height: 14),
            Row(
              children: [
                CircularGauge(
                  progress: 1 - a.riskUsedPercent,
                  size: 46,
                  strokeWidth: 5,
                  color: AppColors.success,
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Risk Left Today', style: AppTypography.caption),
                    Text('${(a.riskUsedPercent * 100).toStringAsFixed(2)}%', style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w700, fontSize: 15)),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(_fmt(a.riskLeftToday), style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.textPrimary)),
                    Text('of ${_fmt(a.dailyLossLimit)}', style: AppTypography.caption),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ];
  }

  Widget _buildPlaceholderTab(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.construction_rounded, color: AppColors.textTertiary, size: 32),
            const SizedBox(height: 10),
            Text('$label coming soon', style: AppTypography.bodyMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: const BoxDecoration(
        color: AppColors.bgSecondary,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add_rounded, color: Colors.white, size: 18),
                label: Text('Add Trade', style: AppTypography.buttonText.copyWith(fontSize: 14)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const RiskCalculatorScreen()),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.border),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Calculator', style: AppTypography.bodyMedium.copyWith(fontSize: 13, fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.border),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Deposit', style: AppTypography.bodyMedium.copyWith(fontSize: 13, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final IconData? icon;
  final Color? iconColor;
  final String label;
  final String? sublabel;
  final String value;
  final Color? valueColor;
  final double? progress;
  final Color? progressColor;

  const _StatBox({
    this.icon,
    this.iconColor,
    required this.label,
    this.sublabel,
    required this.value,
    this.valueColor,
    this.progress,
    this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.bgElevated, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, color: iconColor ?? AppColors.textSecondary, size: 16),
            const SizedBox(height: 6),
          ],
          Text(label, style: AppTypography.caption),
          const SizedBox(height: 4),
          Text(value, style: AppTypography.bodyMedium.copyWith(fontSize: 13.5, fontWeight: FontWeight.w700, color: valueColor ?? AppColors.textPrimary)),
          if (sublabel != null) ...[
            const SizedBox(height: 2),
            Text(sublabel!, style: AppTypography.caption),
          ],
          if (progress != null) ...[
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress!.clamp(0, 1),
                minHeight: 4,
                backgroundColor: AppColors.divider,
                valueColor: AlwaysStoppedAnimation(progressColor ?? AppColors.primaryLight),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
