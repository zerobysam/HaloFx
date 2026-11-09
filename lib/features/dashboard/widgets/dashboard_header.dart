import 'package:flutter/material.dart';
import 'package:halofx/core/theme/app_colors.dart';
// import 'core/theme/app_colors.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
    required this.onNotificationsTap,
  });

  final VoidCallback onNotificationsTap;

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'H',
                style: TextStyle(
                  color: AppColors.purpleBright,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                '${_greeting()}, Samuel 👋',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Plan better. Calculate smarter. Trade with confidence.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onNotificationsTap,
          icon: const Icon(Icons.notifications_none_rounded, size: 25),
          color: AppColors.textPrimary,
          tooltip: 'Notifications',
        ),
      ],
    );
  }
}
