import 'package:flutter/material.dart';
import 'package:halofx/core/theme/app_colors.dart';

class HaloFxBottomNav extends StatelessWidget {
  const HaloFxBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
    required this.onQuickAction,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final VoidCallback onQuickAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF080F19),
        border: Border(
          top: BorderSide(color: AppColors.border),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                _NavItem(
                  icon: Icons.home_rounded,
                  label: 'Dashboard',
                  selected: selectedIndex == 0,
                  onTap: () => onSelected(0),
                ),
                _NavItem(
                  icon: Icons.grid_view_rounded,
                  label: 'Calculators',
                  selected: selectedIndex == 1,
                  onTap: () => onSelected(1),
                ),
                Expanded(
                  child: Center(
                    child: GestureDetector(
                      onTap: onQuickAction,
                      child: Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.purpleBright,
                              AppColors.purple,
                            ],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.purple.withOpacity(0.3),
                              blurRadius: 12,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.add_rounded,
                          size: 28,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                _NavItem(
                  icon: Icons.currency_exchange_rounded,
                  label: 'Converter',
                  selected: selectedIndex == 3,
                  onTap: () => onSelected(3),
                ),
                _NavItem(
                  icon: Icons.person_outline_rounded,
                  label: 'Profile',
                  selected: selectedIndex == 4,
                  onTap: () => onSelected(4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.purpleBright : AppColors.textSecondary;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 64,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 21),
              const SizedBox(height: 3),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: color,
                  fontSize: 9,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
