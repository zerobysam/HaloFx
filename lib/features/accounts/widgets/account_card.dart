import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/circular_gauge.dart';
import '../../../core/widgets/sparkline_chart.dart';
import '../models/trading_account.dart';

class AccountCard extends StatelessWidget {
  final TradingAccount account;
  final VoidCallback onTap;

  const AccountCard({super.key, required this.account, required this.onTap});

  String _fmt(double v) {
    final isNeg = v < 0;
    final parts = v.abs().toStringAsFixed(2).split('.');
    final intPart = parts[0].replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',');
    return '${isNeg ? '-' : ''}\$$intPart.${parts[1]}';
  }

  @override
  Widget build(BuildContext context) {
    final a = account;
    final isPositive = a.changePercent >= 0;
    final sparklineColor = isPositive ? AppColors.success : AppColors.danger;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: a.badgeColor.withOpacity(0.35)),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [a.badgeColor.withOpacity(0.16), AppColors.bgElevated],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Badge + change pill
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: a.badgeColor, borderRadius: BorderRadius.circular(6)),
                  child: Text(a.badgeLabel, style: AppTypography.caption.copyWith(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 10)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: (isPositive ? AppColors.success : AppColors.danger).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    '${isPositive ? '+' : ''}${a.changePercent.toStringAsFixed(2)}%',
                    style: AppTypography.bodySmall.copyWith(fontSize: 12, fontWeight: FontWeight.w700, color: isPositive ? AppColors.success : AppColors.danger),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Name + balance + sparkline
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(a.name, style: AppTypography.bodyLarge.copyWith(fontSize: 16, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      Text(_fmt(a.balance), style: AppTypography.numberLarge.copyWith(fontSize: 26)),
                      const SizedBox(height: 6),
                      Text('Equity', style: AppTypography.caption),
                      Text(_fmt(a.equity), style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 13)),
                    ],
                  ),
                ),
                SparklineChart(data: a.sparkline, color: sparklineColor),
              ],
            ),
            const SizedBox(height: 14),
            Divider(color: AppColors.divider, height: 1),
            const SizedBox(height: 12),

            // Variant stats row
            _statsRow(a),
          ],
        ),
      ),
    );
  }

  Widget _statsRow(TradingAccount a) {
    Widget stat(String label, Widget valueWidget) {
      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTypography.caption),
            const SizedBox(height: 4),
            valueWidget,
          ],
        ),
      );
    }

    Widget val(String text, {Color? color}) =>
        Text(text, style: AppTypography.bodyMedium.copyWith(fontSize: 13, fontWeight: FontWeight.w600, color: color ?? AppColors.textPrimary));

    final dailyPnlColor = a.dailyPnl >= 0 ? AppColors.success : AppColors.danger;

    switch (a.cardStatsVariant) {
      case CardStatsVariant.dailyLossLimit:
        return Row(
          children: [
            stat('Daily PnL', val('${a.dailyPnl >= 0 ? '+' : ''}${_fmt(a.dailyPnl)}', color: dailyPnlColor)),
            stat('Drawdown', val('${a.drawdownPercent.toStringAsFixed(2)}%')),
            stat('Daily Loss Left', val(_fmt(a.dailyLossLimit))),
            SizedBox(
              width: 44,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Risk Left', style: AppTypography.caption),
                  const SizedBox(height: 4),
                  CircularGauge(
                    progress: 1 - a.riskUsedPercent,
                    size: 30,
                    strokeWidth: 3.5,
                    color: AppColors.success,
                  ),
                ],
              ),
            ),
          ],
        );
      case CardStatsVariant.profitTarget:
        return Row(
          children: [
            stat('Daily PnL', val('${a.dailyPnl >= 0 ? '+' : ''}${_fmt(a.dailyPnl)}', color: dailyPnlColor)),
            stat('Drawdown', val('${a.drawdownPercent.toStringAsFixed(2)}%')),
            stat('Profit Target', val('${a.profitTargetPercent.toStringAsFixed(0)}%')),
            stat('Days Left', val('${a.daysLeft}')),
          ],
        );
      case CardStatsVariant.riskUsed:
        return Row(
          children: [
            stat('Daily PnL', val('${a.dailyPnl >= 0 ? '+' : ''}${_fmt(a.dailyPnl)}', color: dailyPnlColor)),
            stat('Drawdown', val('${a.drawdownPercent.toStringAsFixed(2)}%')),
            stat('Risk Used', val('${a.riskUsedPercent.toStringAsFixed(2)}')),
            stat('Leverage', val(a.leverage)),
          ],
        );
    }
  }
}
