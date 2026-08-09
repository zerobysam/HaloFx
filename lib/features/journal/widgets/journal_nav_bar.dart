import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

/// Bottom nav scoped to the Trade Journal flow (Overview/Journal/
/// Calculator/Analytics/Profile) — distinct from the app's global
/// nav (Home/Accounts/Calculator/Community/Profile), since this
/// flow is entered from an account's "Add Trade" button rather than
/// being a primary app tab itself.
class JournalNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const JournalNavBar({super.key, required this.currentIndex, required this.onTap});

  static const _items = [
    (icon: Icons.dashboard_rounded, label: 'Overview'),
    (icon: Icons.menu_book_rounded, label: 'Journal'),
    (icon: Icons.calculate_rounded, label: 'Calculator'),
    (icon: Icons.bar_chart_rounded, label: 'Analytics'),
    (icon: Icons.person_rounded, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        color: AppColors.bgSecondary,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_items.length, (i) {
            final isActive = i == currentIndex;
            final color = isActive ? AppColors.primaryLight : AppColors.navInactive;
            return InkWell(
              onTap: () => onTap(i),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_items[i].icon, color: color, size: 22),
                    const SizedBox(height: 4),
                    Text(_items[i].label, style: AppTypography.caption.copyWith(color: color, fontWeight: isActive ? FontWeight.w700 : FontWeight.w500)),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
