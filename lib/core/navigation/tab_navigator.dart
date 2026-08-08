import 'package:flutter/material.dart';
import '../../features/accounts/screens/accounts_screen.dart';
import '../../features/calculators/screens/risk_calculator_screen.dart';
import '../../features/community/screens/community_screen.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/more/screens/more_screen.dart';

/// Maps a bottom-nav index to its destination screen: Home, Accounts,
/// Calculator, Community, Profile. The Calculator tab opens the
/// unified Risk Calculator screen directly (Position Size / Risk % /
/// Pip Value tabs inside it) rather than the older multi-calculator
/// grid — CalculatorsHubScreen still exists and works if navigated to
/// directly, it's just no longer the primary tab destination.
Widget _screenForTab(int index) {
  return switch (index) {
    0 => const DashboardScreen(),
    1 => const AccountsScreen(),
    2 => const RiskCalculatorScreen(),
    3 => const CommunityScreen(),
    4 => const MoreScreen(),
    _ => const DashboardScreen(),
  };
}

/// Switches to tab [index] from a screen currently showing [currentIndex].
/// No-ops if already on that tab. Uses a fade transition and replaces the
/// current route so repeated tab-switching doesn't stack up the navigator.
void navigateToTab(BuildContext context, int index, int currentIndex) {
  if (index == currentIndex) return;
  Navigator.of(context).pushReplacement(
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (context, animation, __) => _screenForTab(index),
      transitionsBuilder: (context, animation, __, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: child,
        );
      },
    ),
  );
}
