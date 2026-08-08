import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../models/onboarding_slide_data.dart';

/// Renders one onboarding slide's illustration + copy, animating
/// opacity/scale/vertical offset based on how far the page is from
/// being centered in the PageView (a subtle parallax/settle effect
/// as the user swipes between slides).
class OnboardingSlideContent extends StatelessWidget {
  final OnboardingSlideData data;
  final double pageOffset; // 0 = fully centered, 1 = one page away

  const OnboardingSlideContent({
    super.key,
    required this.data,
    required this.pageOffset,
  });

  @override
  Widget build(BuildContext context) {
    final t = pageOffset.clamp(0.0, 1.0);
    final opacity = 1 - t;
    final scale = 1 - (t * 0.08);
    final riseOffset = t * 24; // px

    return Opacity(
      opacity: opacity,
      child: Transform.translate(
        offset: Offset(0, riseOffset),
        child: Transform.scale(
          scale: scale,
          child: Column(
            children: [
              const SizedBox(height: 24),
              Expanded(
                flex: 5,
                child: Center(child: data.illustrationBuilder(context)),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: AppTypography.onboardingTitle,
                        children: [
                          TextSpan(
                            text: '${data.titleLine1}\n',
                            style: TextStyle(color: AppColors.textPrimary),
                          ),
                          TextSpan(
                            text: data.titleLine2,
                            style: TextStyle(color: AppColors.primaryLight),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      data.subtitle,
                      style: AppTypography.bodyMedium.copyWith(height: 1.4),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
