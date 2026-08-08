import 'package:flutter/material.dart';
import '../../../core/navigation/tab_navigator.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';

/// Placeholder — Community feed/leaderboard/discussion, to be
/// designed later. Wired into the bottom nav now so the tab isn't
/// a dead end.
class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Community', style: AppTypography.headlineMedium.copyWith(fontSize: 24)),
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.groups_rounded, color: AppColors.textTertiary, size: 36),
                    const SizedBox(height: 12),
                    Text('Community coming soon', style: AppTypography.bodyLarge),
                    const SizedBox(height: 4),
                    Text('Trader leaderboards, discussions, and shared setups.', style: AppTypography.bodySmall),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 3,
        onTap: (i) => navigateToTab(context, i, 3),
      ),
    );
  }
}
