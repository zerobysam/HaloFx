import 'package:flutter/material.dart';
import '../../../core/auth/access_control.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import 'ai_import_review_screen.dart';
import 'import_csv_screen.dart';
import 'manual_trade_entry_screen.dart';

class AddTradeOptionsScreen extends StatelessWidget {
  const AddTradeOptionsScreen({super.key});

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
                  Text('Add Trade', style: AppTypography.headlineSmall.copyWith(fontSize: 18)),
                ],
              ),
              const SizedBox(height: 12),

              _optionCard(
                context,
                icon: Icons.camera_alt_rounded,
                iconColor: AppColors.primaryLight,
                title: 'AI Import (Screenshot)',
                subtitle: 'Upload screenshot and AI will extract the trade',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AiImportReviewScreen()),
                ),
              ),
              const SizedBox(height: 12),
              _optionCard(
                context,
                icon: Icons.description_rounded,
                iconColor: AppColors.success,
                title: 'Import CSV',
                subtitle: 'Import from MT4, MT5, cTrader, Binance, Bybit',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ImportCsvScreen()),
                ),
              ),
              const SizedBox(height: 12),
              _optionCard(
                context,
                icon: Icons.edit_rounded,
                iconColor: AppColors.gold,
                title: 'Manual Entry',
                subtitle: 'Enter trade details manually',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ManualTradeEntryScreen()),
                ),
              ),
              const SizedBox(height: 12),
              _optionCard(
                context,
                icon: Icons.cloud_sync_rounded,
                iconColor: AppColors.textLink,
                title: 'Sync Broker',
                subtitle: 'Auto import trades from your broker',
                isPremium: true,
                onTap: () async {
                  await ensureLoggedIn(context, featureName: 'Sync Broker');
                },
              ),

              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
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

  Widget _optionCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    bool isPremium = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.bgElevated, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
        child: Row(
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(color: iconColor.withOpacity(0.15), shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(title, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w700, fontSize: 15)),
                      if (isPremium) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.15), borderRadius: BorderRadius.circular(4)),
                          child: Text('PRO', style: AppTypography.caption.copyWith(color: AppColors.gold, fontWeight: FontWeight.w700, fontSize: 9)),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTypography.bodySmall.copyWith(fontSize: 12.5)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }
}
