import 'package:flutter/material.dart';
import '../state/premium_status.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'app_gradient_button.dart';

class SubscribeScreen extends StatelessWidget {
  const SubscribeScreen({super.key});

  static const _perks = [
    'Remove all ads',
    'Unlimited saved setups',
    'Full trade journal & analytics',
    'AI recommendations on every calculation',
    'Sync across all your devices',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.close_rounded, color: AppColors.textPrimary, size: 22),
              ),
              const SizedBox(height: 8),
              const Icon(Icons.workspace_premium_rounded, color: AppColors.gold, size: 44),
              const SizedBox(height: 16),
              Text('Go Premium', style: AppTypography.displayLarge),
              const SizedBox(height: 8),
              Text(
                'Unlock the full toolkit and trade without interruptions.',
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: 24),
              ..._perks.map((p) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 18),
                        const SizedBox(width: 10),
                        Expanded(child: Text(p, style: AppTypography.bodyLarge.copyWith(fontSize: 14))),
                      ],
                    ),
                  )),
              const Spacer(),
              AppGradientButton(
                label: 'Subscribe — \$4.99/mo',
                onPressed: () {
                  PremiumStatus.unlock();
                  Navigator.of(context).maybePop();
                },
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  child: Text('Not now', style: AppTypography.bodyMedium),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
