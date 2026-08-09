import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../models/trade.dart';

class TradeListTile extends StatelessWidget {
  final Trade trade;
  final VoidCallback? onTap;

  const TradeListTile({super.key, required this.trade, this.onTap});

  Color _marketIconColor(String market) {
    switch (market) {
      case 'Crypto':
        return AppColors.gold;
      case 'Commodities':
        return AppColors.warning;
      default:
        return AppColors.primaryLight;
    }
  }

  IconData _marketIcon(String market) {
    switch (market) {
      case 'Crypto':
        return Icons.currency_bitcoin_rounded;
      case 'Commodities':
        return Icons.local_fire_department_rounded;
      default:
        return Icons.flag_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = trade;
    final isProfit = t.profit >= 0;
    final color = isProfit ? AppColors.success : AppColors.danger;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 34, height: 34,
              decoration: BoxDecoration(color: _marketIconColor(t.market).withOpacity(0.15), shape: BoxShape.circle),
              child: Icon(_marketIcon(t.market), color: _marketIconColor(t.market), size: 16),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(t.symbol, style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 13.5)),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: (t.direction == TradeDirection.buy ? AppColors.success : AppColors.danger).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          t.direction == TradeDirection.buy ? 'Buy' : 'Sell',
                          style: AppTypography.caption.copyWith(color: t.direction == TradeDirection.buy ? AppColors.success : AppColors.danger, fontWeight: FontWeight.w700, fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text('${t.lotSize.toStringAsFixed(2)} Lots', style: AppTypography.caption),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('${isProfit ? '+' : ''}\$${t.profit.abs().toStringAsFixed(2)}', style: AppTypography.bodyMedium.copyWith(color: color, fontWeight: FontWeight.w700, fontSize: 13.5)),
                Text('${isProfit ? '+' : ''}${t.profitR.toStringAsFixed(2)}R', style: AppTypography.caption.copyWith(color: color)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
