import 'package:flutter/material.dart';

/// =======================================================
/// HALOFX DESIGN SYSTEM
/// Centralized colors and application theme.
/// =======================================================

// abstract final class AppColors {
//   // -------------------------------------------------------
//   // BACKGROUNDS
//   // -------------------------------------------------------

//   static const Color bgPrimary = Color(0xFF0A0A0F);
//   static const Color bgSecondary = Color(0xFF12121A);
//   static const Color bgElevated = Color(0xFF1A1A24);
//   static const Color bgInput = Color(0xFF15151F);

//   // -------------------------------------------------------
//   // BRAND / PRIMARY ACCENTS
//   // -------------------------------------------------------

//   static const Color primary = Color(0xFF7C5CFC);
//   static const Color primaryLight = Color(0xFF9B7FFF);
//   static const Color primaryDark = Color(0xFF5B3FD9);

//   static const Color primaryGradientStart = Color(0xFF8B5CF6);
//   static const Color primaryGradientEnd = Color(0xFF6D28D9);

//   // Additional accent colors
//   static const Color blue = Color(0xFF2864F0);
//   static const Color purple = primary;

//   // -------------------------------------------------------
//   // SEMANTIC COLORS
//   // -------------------------------------------------------

//   static const Color success = Color(0xFF22C55E);
//   static const Color successBg = Color(0xFF14291E);

//   static const Color danger = Color(0xFFEF4444);
//   static const Color dangerBg = Color(0xFF2A1618);

//   static const Color warning = Color(0xFFF59E0B);
//   static const Color gold = Color(0xFFFBBF24);

//   // -------------------------------------------------------
//   // TEXT COLORS
//   // -------------------------------------------------------

//   static const Color textPrimary = Color(0xFFFFFFFF);
//   static const Color textSecondary = Color(0xFFA1A1AA);
//   static const Color textTertiary = Color(0xFF6B6B76);
//   static const Color textLink = Color(0xFF9B7FFF);

//   // -------------------------------------------------------
//   // BORDERS / DIVIDERS
//   // -------------------------------------------------------

//   static const Color border = Color(0xFF232330);
//   static const Color divider = Color(0xFF1E1E28);

//   // -------------------------------------------------------
//   // BOTTOM NAVIGATION
//   // -------------------------------------------------------

//   static const Color navActive = primary;
//   static const Color navInactive = Color(0xFF6B6B76);

//   // -------------------------------------------------------
//   // INACTIVE STATES
//   // -------------------------------------------------------

//   static const Color dotInactive = Color(0xFF3A3A46);

//   static const Color purpleBright = Color(0xFFA78BFA);
// }
abstract final class AppColors {
  // -------------------------------------------------------
  // BACKGROUNDS
  // -------------------------------------------------------

  static const Color bgPrimary = Color(0xFF0A0A0F);
  static const Color bgSecondary = Color(0xFF12121A);
  static const Color bgElevated = Color(0xFF1A1A24);
  static const Color bgInput = Color(0xFF15151F);

  // Surface aliases (used by HaloCard and session widgets)
  static const Color surface = bgSecondary;
  static const Color surfaceRaised = bgElevated;

  // -------------------------------------------------------
  // BRAND / PRIMARY ACCENTS
  // -------------------------------------------------------

  static const Color primary = Color(0xFF7C5CFC);
  static const Color primaryLight = Color(0xFF9B7FFF);
  static const Color primaryDark = Color(0xFF5B3FD9);

  static const Color primaryGradientStart = Color(0xFF8B5CF6);
  static const Color primaryGradientEnd = Color(0xFF6D28D9);

  // Additional accent colors
  static const Color blue = Color(0xFF2864F0);
  static const Color purple = primary;
  static const Color purpleBright = Color(0xFFA78BFA);
  static const Color green = success;
  static const Color orange = Color(0xFFF97316);

  // -------------------------------------------------------
  // SEMANTIC COLORS
  // -------------------------------------------------------

  static const Color success = Color(0xFF22C55E);
  static const Color successBg = Color(0xFF14291E);

  static const Color danger = Color(0xFFEF4444);
  static const Color dangerBg = Color(0xFF2A1618);

  static const Color warning = Color(0xFFF59E0B);
  static const Color gold = Color(0xFFFBBF24);

  // -------------------------------------------------------
  // TEXT COLORS
  // -------------------------------------------------------

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA1A1AA);
  static const Color textTertiary = Color(0xFF6B6B76);
  static const Color textLink = Color(0xFF9B7FFF);

  // Text aliases (used by session widgets)
  static const Color text = textPrimary;
  static const Color muted = textSecondary;

  // -------------------------------------------------------
  // BORDERS / DIVIDERS
  // -------------------------------------------------------

  static const Color border = Color(0xFF232330);
  static const Color divider = Color(0xFF1E1E28);

  // -------------------------------------------------------
  // BOTTOM NAVIGATION
  // -------------------------------------------------------

  static const Color navActive = primary;
  static const Color navInactive = Color(0xFF6B6B76);

  // -------------------------------------------------------
  // INACTIVE STATES
  // -------------------------------------------------------

  static const Color dotInactive = Color(0xFF3A3A46);
}

/// =======================================================
/// APPLICATION THEME
/// =======================================================

abstract final class AppTheme {
  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Global colors
      scaffoldBackgroundColor: AppColors.bgPrimary,

      fontFamily: 'ProximaNova',

      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.primaryLight,
        surface: AppColors.bgSecondary,
        error: AppColors.danger,
        onPrimary: AppColors.textPrimary,
        onSurface: AppColors.textPrimary,
        onError: AppColors.textPrimary,
      ),

      // App bar
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.bgPrimary,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
      ),

      // Cards
      cardTheme: CardThemeData(
        color: AppColors.bgSecondary,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: AppColors.border,
          ),
        ),
      ),

      // Input fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.bgInput,
        hintStyle: const TextStyle(
          color: AppColors.textTertiary,
        ),
        labelStyle: const TextStyle(
          color: AppColors.textSecondary,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.border,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.border,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
        ),
      ),

      // Elevated buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // Dividers
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
      ),

      // Bottom navigation
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.bgSecondary,
        indicatorColor: AppColors.primary.withOpacity(0.15),
        elevation: 0,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) {
            return TextStyle(
              fontSize: 11,
              color: states.contains(WidgetState.selected)
                  ? AppColors.navActive
                  : AppColors.navInactive,
            );
          },
        ),
      ),
    );
  }
}
