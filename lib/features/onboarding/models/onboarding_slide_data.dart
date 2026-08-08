import 'package:flutter/widgets.dart';

/// Describes the content for a single onboarding slide.
/// [titleLine1] renders in the primary text color, [titleLine2]
/// renders in the highlighted brand color (matches the two-tone
/// headline style in the mockups, e.g. "Trade smarter." / "Risk better.").
class OnboardingSlideData {
  final WidgetBuilder illustrationBuilder;
  final String titleLine1;
  final String titleLine2;
  final String subtitle;
  final String primaryButtonLabel;

  const OnboardingSlideData({
    required this.illustrationBuilder,
    required this.titleLine1,
    required this.titleLine2,
    required this.subtitle,
    required this.primaryButtonLabel,
  });
}
