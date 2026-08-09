import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../more/screens/more_screen.dart';
import '../screens/balance_history_screen.dart';
import '../screens/journal_dashboard_screen.dart';
import '../screens/journal_list_screen.dart';
import '../screens/trade_calculator_screen.dart';

enum JournalTab { overview, journal, calculator, analytics, profile }

class JournalBottomNav extends StatelessWidget {
  final JournalTab current;

  const JournalBottomNav({super.key, required this.current});

  static const _items = [
    (tab: JournalTab.overview, icon: Icons.home_rounded, label: 'Overview'),
    (tab: JournalTab.journal, icon: Icons.menu_book_rounded, label: 'Journal'),
    (tab: JournalTab.calculator, icon: Icons.calculate_rounded, label: 'Calculator'),
    (tab: JournalTab.analytics, icon: Icons.bar_chart_rounded, label: 'Analytics'),
    (tab: JournalTab.profile, icon: Icons.person_rounded, label: 'Profile'),
  ];

  void _go(BuildContext context, JournalTab tab) {
    if (tab == current) return;
    final Widget screen = switch (tab) {
      JournalTab.overview => const JournalDashboardScreen(),
      JournalTab.journal => const JournalListScreen(),
      JournalTab.calculator => const TradeCalculatorScreen(),
      JournalTab.analytics => const BalanceHistoryScreen(),
      JournalTab.profile => const MoreScreen(),
    };
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (context, animation, __) => screen,
        transitionsBuilder: (context, animation, __, child) => FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(color: AppColors.bgSecondary, border: Border(top: BorderSide(color: AppColors.divider))),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _items.map((item) {
            final isActive = item.tab == current;
            final color = isActive ? AppColors.primary : AppColors.textTertiary;
            return InkWell(
              onTap: () => _go(context, item.tab),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(item.icon, color: color, size: 22),
                    const SizedBox(height: 4),
                    Text(item.label, style: AppTypography.caption.copyWith(color: color, fontWeight: isActive ? FontWeight.w700 : FontWeight.w500)),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
