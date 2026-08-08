import 'package:flutter/material.dart';
import '../state/premium_status.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Drop this into any calculation/result screen. It renders a banner-ad
/// placeholder and a "Remove ads" upsell, and disappears entirely once
/// [PremiumStatus.isPremium] is true. Wrap the screen body with
/// [ValueListenableBuilder] on [PremiumStatus.isPremium] (this widget
/// does that internally) so it reacts live if the user subscribes
/// mid-session.
class AdBanner extends StatelessWidget {
  final VoidCallback? onUpgradeTap;

  const AdBanner({super.key, this.onUpgradeTap});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: PremiumStatus.isPremium,
      builder: (context, isPremium, _) {
        if (isPremium) return const SizedBox.shrink();

        return Container(
          margin: const EdgeInsets.only(top: 16),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.bgElevated,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border, style: BorderStyle.solid),
          ),
          child: Column(
            children: [
              // Ad placeholder slot — wire up your ad SDK's banner widget here
              Container(
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.bgInput,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.divider),
                ),
                alignment: Alignment.center,
                child: Text('Advertisement', style: AppTypography.caption),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: onUpgradeTap,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.workspace_premium_rounded, size: 14, color: AppColors.gold),
                    const SizedBox(width: 6),
                    Text(
                      'Remove ads — Subscribe',
                      style: AppTypography.linkMedium.copyWith(fontSize: 12.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
