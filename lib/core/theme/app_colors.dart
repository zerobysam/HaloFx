import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Backgrounds
  static const Color bgPrimary = Color(0xFF0A0A0F);
  static const Color bgSecondary = Color(0xFF12121A);
  static const Color bgElevated = Color(0xFF1A1A24);
  static const Color bgInput = Color(0xFF15151F);

  // Brand / Accent
  static const Color primary = Color(0xFF7C5CFC);
  static const Color primaryLight = Color(0xFF9B7FFF);
  static const Color primaryDark = Color(0xFF5B3FD9);
  static const Color primaryGradientStart = Color(0xFF8B5CF6);
  static const Color primaryGradientEnd = Color(0xFF6D28D9);

  // Semantic
  static const Color success = Color(0xFF22C55E);
  static const Color successBg = Color(0xFF14291E);
  static const Color danger = Color(0xFFEF4444);
  static const Color dangerBg = Color(0xFF2A1618);
  static const Color warning = Color(0xFFF59E0B);
  static const Color gold = Color(0xFFFBBF24);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA1A1AA);
  static const Color textTertiary = Color(0xFF6B6B76);
  static const Color textLink = Color(0xFF9B7FFF);

  // Borders / Dividers
  static const Color border = Color(0xFF232330);
  static const Color divider = Color(0xFF1E1E28);

  // Bottom nav
  static const Color navActive = primary;
  static const Color navInactive = Color(0xFF6B6B76);

  // Inactive states (page dots, disabled icons/elements)
  static const Color dotInactive = Color(0xFF3A3A46);
}
