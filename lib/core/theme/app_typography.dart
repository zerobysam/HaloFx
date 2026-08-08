import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  AppTypography._();

  static TextStyle get _base => GoogleFonts.inter();

  // Display / Headlines
  static TextStyle displayLarge = _base.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.2,
  );
  static TextStyle headlineMedium = _base.copyWith(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );
  static TextStyle headlineSmall = _base.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Body
  static TextStyle bodyLarge = _base.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );
  static TextStyle bodyMedium = _base.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );
  static TextStyle bodySmall = _base.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textTertiary,
  );

  // Numeric / Financial
  static TextStyle numberLarge = _base.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    fontFeatures: [const FontFeature.tabularFigures()],
  );
  static TextStyle numberMedium = _base.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFeatures: [const FontFeature.tabularFigures()],
  );

  // Labels / Buttons
  static TextStyle buttonText = _base.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
  static TextStyle labelSmall = _base.copyWith(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    letterSpacing: 0.5,
  );
  static TextStyle caption = _base.copyWith(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.textTertiary,
  );

  // Extras needed by onboarding/auth screens (not in the original set)
  static TextStyle onboardingTitle = _base.copyWith(
    fontSize: 30,
    fontWeight: FontWeight.w700,
    height: 1.25,
  );
  static TextStyle authTitle = _base.copyWith(
    fontSize: 26,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );
  static TextStyle linkMedium = _base.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textLink,
  );
  static TextStyle linkBold = _base.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryLight,
  );
}
