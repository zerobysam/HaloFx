import 'package:flutter/material.dart';
import '../../../core/state/trade_journal_store.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../models/trade.dart';
import 'journal_dashboard_screen.dart';

/// TODO: wire a real file_picker + CSV parsing pipeline per platform
/// (MT4/MT5/cTrader/Binance/Bybit export formats differ). This
/// simulates detecting a file on tap so the flow is fully navigable.
class ImportCsvScreen extends StatefulWidget {
  const ImportCsvScreen({super.key});

  @override
  State<ImportCsvScreen> createState() => _ImportCsvScreenState();
}

class _ImportCsvScreenState extends State<ImportCsvScreen> {
  bool _fileDetected = false;
  bool _importing = false;

  static const _platforms = [
    (label: 'MT4', icon: Icons.show_chart_rounded),
    (label: 'MT5', icon: Icons.candlestick_chart_rounded),
    (label: 'cTrader', icon: Icons.equalizer_rounded),
    (label: 'Binance', icon: Icons.currency_bitcoin_rounded),
    (label: 'Bybit', icon: Icons.bolt_rounded),
    (label: 'Hyperliquid', icon: Icons.water_drop_rounded),
  ];

  void _simulatePickFile() {
    setState(() => _fileDetected = true);
  }

  Future<void> _importTrades() async {
    setState(() => _importing = true);
    await Future.delayed(const Duration(milliseconds: 700));
    // Mocked: in reality this would parse and insert every row.
    TradeJournalStore.addTrade(Trade(
      id: 'csv_import_${DateTime.now().millisecondsSinceEpoch}',
      symbol: 'GBP/USD',
      market: 'Forex',
      direction: TradeDirection.sell,
      status: TradeStatus.closed,
      entryPrice: 1.26500,
      exitPrice: 1.26210,
      lotSize: 0.25,
      profit: 72.50,
      profitR: 0.9,
      date: DateTime.now(),
      duration: const Duration(hours: 1),
    ));
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const JournalDashboardScreen()),
      (route) => false,
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
                  Text('Import CSV', style: AppTypography.headlineSmall.copyWith(fontSize: 18)),
                ],
              ),
              const SizedBox(height: 16),

              GestureDetector(
                onTap: _fileDetected ? null : _simulatePickFile,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  decoration: BoxDecoration(
                    color: AppColors.bgElevated,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.primary.withOpacity(0.4), style: BorderStyle.solid),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 56, height: 56,
                        decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.15), shape: BoxShape.circle),
                        child: const Icon(Icons.cloud_upload_rounded, color: AppColors.primaryLight, size: 26),
                      ),
                      const SizedBox(height: 14),
                      Text('Drop your CSV file here', style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w700, fontSize: 15)),
                      const SizedBox(height: 4),
                      Text('or tap to browse', style: AppTypography.bodySmall),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 22),

              Text('Supported Platforms', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w700, fontSize: 14)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _platforms.map((p) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(color: AppColors.bgElevated, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(p.icon, size: 14, color: AppColors.textSecondary),
                        const SizedBox(width: 6),
                        Text(p.label, style: AppTypography.bodySmall.copyWith(fontSize: 12.5)),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              if (_fileDetected) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: AppColors.bgElevated, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Detected File', style: AppTypography.caption),
                            const SizedBox(height: 2),
                            Text('trades_history.csv', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w700, fontSize: 14)),
                            Text('324 trades found', style: AppTypography.bodySmall.copyWith(fontSize: 12)),
                          ],
                        ),
                      ),
                      const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 22),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _importing ? null : _importTrades,
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                    child: _importing
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                        : Text('Import 324 Trades', style: AppTypography.buttonText),
                  ),
                ),
              ],

              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text('We will preview the data before importing to your journal.', textAlign: TextAlign.center, style: AppTypography.caption),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
