import 'package:flutter/material.dart';
import '../../../core/state/trade_journal_store.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../models/trade.dart';
import 'trade_details_screen.dart';

/// TODO: wire a real image_picker + OCR/vision-model extraction
/// pipeline. For now this simulates the AI parsing a screenshot with
/// a fixed mock result so the review → confirm flow is fully
/// functional end-to-end.
class AiImportReviewScreen extends StatefulWidget {
  const AiImportReviewScreen({super.key});

  @override
  State<AiImportReviewScreen> createState() => _AiImportReviewScreenState();
}

class _AiImportReviewScreenState extends State<AiImportReviewScreen> {
  bool _analyzing = true;

  static final _extracted = Trade(
    id: 'ai_import_${DateTime.now().millisecondsSinceEpoch}',
    symbol: 'EUR/USD',
    market: 'Forex',
    direction: TradeDirection.buy,
    status: TradeStatus.closed,
    entryPrice: 1.17245,
    exitPrice: 1.17490,
    lotSize: 0.40,
    profit: 125.00,
    profitR: 1.25,
    date: DateTime(2026, 5, 21, 10, 32, 15),
    duration: const Duration(minutes: 0),
  );

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) setState(() => _analyzing = false);
    });
  }

  void _confirm() {
    TradeJournalStore.addTrade(_extracted);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => TradeDetailsScreen(trade: _extracted)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
                  ),
                  Text('AI Import', style: AppTypography.headlineSmall.copyWith(fontSize: 18)),
                  const Spacer(),
                  Text('1/1', style: AppTypography.caption),
                  const SizedBox(width: 8),
                ],
              ),
              const SizedBox(height: 8),

              if (_analyzing)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(color: AppColors.primaryLight),
                        const SizedBox(height: 16),
                        Text('Analyzing screenshot...', style: AppTypography.bodyMedium),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                  Row(
                                    children: [
                                      Text('${_extracted.symbol}, ', style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w700, fontSize: 15)),
                                      Text('buy ${_extracted.lotSize.toStringAsFixed(2)}', style: AppTypography.bodyLarge.copyWith(color: AppColors.success, fontWeight: FontWeight.w700, fontSize: 15)),
                                    ],
                                  ),
                                  Text('${_extracted.date.year}.${_extracted.date.month.toString().padLeft(2, '0')}.${_extracted.date.day.toString().padLeft(2, '0')} ${_extracted.date.hour}:${_extracted.date.minute.toString().padLeft(2, '0')}:15', style: AppTypography.caption),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(_extracted.entryPrice.toStringAsFixed(5), style: AppTypography.bodyMedium.copyWith(fontSize: 13)),
                                  const SizedBox(width: 6),
                                  const Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.textTertiary),
                                  const SizedBox(width: 6),
                                  Text(_extracted.exitPrice.toStringAsFixed(5), style: AppTypography.bodyMedium.copyWith(fontSize: 13)),
                                  const Spacer(),
                                  Text(_extracted.profit.toStringAsFixed(2), style: AppTypography.bodyMedium.copyWith(color: AppColors.success, fontWeight: FontWeight.w700)),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Divider(color: AppColors.divider, height: 1),
                              const SizedBox(height: 12),
                              _kv('Profit:', _extracted.profit.toStringAsFixed(2), valueColor: AppColors.success),
                              _kv('Deposit:', '-0.00'),
                              _kv('Swap:', '-2.10'),
                              _kv('Commission:', '-0.90'),
                              _kv('Balance:', '122.00'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Text('AI Detected', style: AppTypography.bodyMedium.copyWith(color: AppColors.primaryLight, fontWeight: FontWeight.w700, fontSize: 14)),
                            const Spacer(),
                            Text('98% Confidence', style: AppTypography.caption),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _detailRow('Symbol', _extracted.symbol),
                        _detailRow('Direction', 'Buy', valueBadgeColor: AppColors.success),
                        _detailRow('Entry Price', _extracted.entryPrice.toStringAsFixed(5)),
                        _detailRow('Exit Price', _extracted.exitPrice.toStringAsFixed(5)),
                        _detailRow('Lots', _extracted.lotSize.toStringAsFixed(2)),
                        _detailRow('Profit', '+ \$${_extracted.profit.toStringAsFixed(2)}', valueColor: AppColors.success),
                        _detailRow('Date & Time', '${_extracted.date.month}/${_extracted.date.day}/${_extracted.date.year} ${_extracted.date.hour}:${_extracted.date.minute.toString().padLeft(2, '0')}'),

                        const SizedBox(height: 16),
                        Text(
                          'Review the extracted details before saving to your journal.',
                          style: AppTypography.caption,
                        ),
                        const SizedBox(height: 20),

                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.of(context).maybePop(),
                                style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.border), padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                child: Text('Edit', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _confirm,
                                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                child: Text('Confirm', style: AppTypography.buttonText.copyWith(fontSize: 14)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _kv(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodySmall.copyWith(fontSize: 12.5)),
          Text(value, style: AppTypography.bodyMedium.copyWith(fontSize: 12.5, fontWeight: FontWeight.w600, color: valueColor)),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value, {Color? valueColor, Color? valueBadgeColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodyMedium.copyWith(fontSize: 13.5)),
          if (valueBadgeColor != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: valueBadgeColor.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
              child: Text(value, style: AppTypography.bodySmall.copyWith(color: valueBadgeColor, fontWeight: FontWeight.w700, fontSize: 12)),
            )
          else
            Text(value, style: AppTypography.bodyMedium.copyWith(fontSize: 13.5, fontWeight: FontWeight.w600, color: valueColor)),
        ],
      ),
    );
  }
}
