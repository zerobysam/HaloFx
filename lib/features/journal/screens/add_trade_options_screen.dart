import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../accounts/models/trading_account.dart';
import 'ai_import_review_screen.dart';
import 'csv_import_screen.dart';
import 'manual_entry_screen.dart';

class AddTradeOptionsScreen extends StatelessWidget {
  final TradingAccount account;

  const AddTradeOptionsScreen({super.key, required this.account});

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
                    icon: const Icon(Icons.close_rounded, color: AppColors.textPrimary, size: 22),
                  ),
                  Text('Add Trade', style: AppTypography.headlineSmall),
                ],
              ),
              const SizedBox(height: 12),

              _optionCard(
                icon: Icons.camera_alt_rounded,
                iconColor: AppColors.primaryLight,
                title: 'AI Import (Screenshot)',
                subtitle: 'Upload screenshot and AI will extract the trade',
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => AiImportReviewScreen(account: account))),
              ),
              const SizedBox(height: 12),
              _optionCard(
                icon: Icons.description_rounded,
                iconColor: AppColors.success,
                title: 'Import CSV',
                subtitle: 'Import from MT4, MT5, cTrader, Binance, Bybit',
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => CsvImportScreen(account: account))),
              ),
              const SizedBox(height: 12),
              _optionCard(
                icon: Icons.edit_rounded,
                iconColor: const Color(0xFFF59E0B),
                title: 'Manual Entry',
                subtitle: 'Enter trade details manually',
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ManualEntryScreen(account: account))),
              ),
              const SizedBox(height: 12),
              _optionCard(
                icon: Icons.cloud_sync_rounded,
                iconColor: AppColors.textTertiary,
                title: 'Sync Broker (Premium)',
                subtitle: 'Auto import trades from your broker',
                badge: 'PRO',
                disabled: true,
                onTap: () {},
              ),

              const SizedBox(height: 20),
              Center(
                child: Text(
                  'All imports are private and processed on your device.',
                  textAlign: TextAlign.center,
                  style: AppTypography.caption,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _optionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    String? badge,
    bool disabled = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.bgElevated, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
        child: Row(
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(color: iconColor.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: disabled ? AppColors.textTertiary : iconColor, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(title, style: AppTypography.bodyLarge.copyWith(fontSize: 15, fontWeight: FontWeight.w700, color: disabled ? AppColors.textSecondary : AppColors.textPrimary)),
                      if (badge != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(4)),
                          child: Text(badge, style: AppTypography.caption.copyWith(color: AppColors.bgPrimary, fontWeight: FontWeight.w800, fontSize: 9)),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(subtitle, style: AppTypography.bodySmall.copyWith(fontSize: 12.5)),
                ],
              ),
            ),
            if (!disabled) const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }
}
