import 'package:flutter/widgets.dart';
import '../models/onboarding_slide_data.dart';
import '../widgets/rocket_illustration.dart';
import '../widgets/shield_illustration.dart';

/// Ordered list of onboarding slides shown in the PageView.
/// Add/remove entries here to change the onboarding flow — the
/// screen and page indicator adapt automatically.
final List<OnboardingSlideData> onboardingSlides = [
  OnboardingSlideData(
    illustrationBuilder: (_) => const RocketIllustration(),
    titleLine1: 'Trade Smarter.',
    titleLine2: 'Not Harder.',
    subtitle: 'The all-in-one risk management app for disciplined traders.',
    primaryButtonLabel: 'Get Started',
  ),
  OnboardingSlideData(
    illustrationBuilder: (_) => const ShieldIllustration(),
    titleLine1: 'Plan. Calculate.',
    titleLine2: 'Protect. Grow.',
    subtitle: 'Calculate position size, track performance, and let AI '
        'help you trade your best.',
    primaryButtonLabel: 'Create Account',
  ),
];
