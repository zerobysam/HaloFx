import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../models/trade.dart';

class TradeDetailsScreen extends StatelessWidget {
  final Trade trade;

  const TradeDetailsScreen({super.key, required this.trade});

  @override
  Widget build(BuildContext context) {
    final t = trade;
    final isProfit = t.profit >= 0;
    final color = isProfit ? AppColors.success : AppColors.danger;

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
                  Text('Trade Details', style: AppTypography.headlineSmall.copyWith(fontSize: 18)),
                  const Spacer(),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.edit_outlined, color: AppColors.textSecondary, size: 20)),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(t.symbol, style: AppTypography.headlineMedium.copyWith(fontSize: 22)),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: (t.direction == TradeDirection.buy ? AppColors.success : AppColors.danger).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                t.direction == TradeDirection.buy ? 'Buy' : 'Sell',
                                style: AppTypography.caption.copyWith(color: t.direction == TradeDirection.buy ? AppColors.success : AppColors.danger, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('${isProfit ? '+' : ''}\$${t.profit.abs().toStringAsFixed(2)}', style: AppTypography.bodyLarge.copyWith(color: color, fontWeight: FontWeight.w700, fontSize: 17)),
                            Text('${isProfit ? '+' : ''}${t.profitR.toStringAsFixed(2)}R', style: AppTypography.bodySmall.copyWith(color: color)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: AppColors.bgElevated, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
                      child: Column(
                        children: [
                          _row('Entry Price', t.entryPrice.toStringAsFixed(5)),
                          _row('Exit Price', t.exitPrice.toStringAsFixed(5)),
                          _row('Lot Size', t.lotSize.toStringAsFixed(2)),
                          if (t.stopLoss != null) _row('Stop Loss', '${t.stopLoss!.toStringAsFixed(5)} (${((t.entryPrice - t.stopLoss!).abs() * 10000).toStringAsFixed(0)} pips)'),
                          if (t.takeProfit != null) _row('Take Profit', '${t.takeProfit!.toStringAsFixed(5)} (${((t.takeProfit! - t.entryPrice).abs() * 10000).toStringAsFixed(0)} pips)'),
                          _row('Duration', '${t.duration.inHours}h ${t.duration.inMinutes % 60}m'),
                          _row('Date', '${t.date.month}/${t.date.day}/${t.date.year} ${t.date.hour}:${t.date.minute.toString().padLeft(2, '0')}'),
                          _row('Market', t.market, isLast: true),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    if (t.emotion != null || t.strategy != null || t.session != null || t.notes != null) ...[
                      Row(
                        children: [
                          const Icon(Icons.auto_awesome_rounded, color: AppColors.primaryLight, size: 16),
                          const SizedBox(width: 6),
                          Text('AI Analysis', style: AppTypography.bodyMedium.copyWith(color: AppColors.primaryLight, fontWeight: FontWeight.w700, fontSize: 14)),
                          const Spacer(),
                          Text('View', style: AppTypography.linkMedium.copyWith(fontSize: 13)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: AppColors.bgElevated, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
                        child: Column(
                          children: [
                            if (t.emotion != null) _row('Emotion', t.emotion!, emoji: '🙂'),
                            if (t.strategy != null) _row('Strategy', t.strategy!),
                            if (t.session != null) _row('Session', t.session!),
                            if (t.notes != null) _row('Notes', t.notes!, isLast: t.tags.isEmpty),
                            if (t.tags.isNotEmpty) ...[
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    ...t.tags.map((tag) => Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.15), borderRadius: BorderRadius.circular(100)),
                                          child: Text(tag, style: AppTypography.bodySmall.copyWith(color: AppColors.primaryLight, fontSize: 12, fontWeight: FontWeight.w600)),
                                        )),
                                    Container(
                                      width: 26, height: 26,
                                      decoration: BoxDecoration(color: AppColors.bgInput, shape: BoxShape.circle, border: Border.all(color: AppColors.border)),
                                      child: const Icon(Icons.add_rounded, color: AppColors.textTertiary, size: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value, {bool isLast = false, String? emoji}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTypography.bodyMedium.copyWith(fontSize: 13.5)),
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (emoji != null) ...[Text(emoji, style: const TextStyle(fontSize: 14)), const SizedBox(width: 4)],
                    Flexible(
                      child: Text(value, textAlign: TextAlign.end, style: AppTypography.bodyMedium.copyWith(fontSize: 13.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!isLast) Divider(color: AppColors.divider, height: 1),
      ],
    );
  }
}
