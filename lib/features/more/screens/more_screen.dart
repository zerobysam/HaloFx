import 'package:flutter/material.dart';
import '../../../core/navigation/tab_navigator.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../core/widgets/lock_prompt_card.dart';
import '../../auth/screens/login_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  static const _menuItems = [
    (icon: Icons.person_outline_rounded, title: 'Profile', subtitle: 'Login to manage'),
    (icon: Icons.tune_rounded, title: 'Preferences', subtitle: null),
    (icon: Icons.notifications_none_rounded, title: 'Notifications', subtitle: null),
    (icon: Icons.help_outline_rounded, title: 'Help Center', subtitle: null),
    (icon: Icons.support_agent_rounded, title: 'Contact Support', subtitle: null),
    (icon: Icons.info_outline_rounded, title: 'About TradRisk', subtitle: null),
  ];

  void _goToLogin(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('More', style: AppTypography.headlineMedium.copyWith(fontSize: 24)),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.bgElevated,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        for (int i = 0; i < _menuItems.length; i++) ...[
                          ListTile(
                            leading: Icon(_menuItems[i].icon, color: AppColors.textSecondary, size: 22),
                            title: Text(_menuItems[i].title, style: AppTypography.bodyLarge.copyWith(fontSize: 15)),
                            subtitle: _menuItems[i].subtitle != null
                                ? Text(_menuItems[i].subtitle!, style: AppTypography.bodySmall.copyWith(fontSize: 12))
                                : null,
                            trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary),
                            onTap: () {},
                          ),
                          if (i != _menuItems.length - 1)
                            const Divider(height: 1, color: AppColors.divider, indent: 16, endIndent: 16),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  LockPromptCard(
                    title: 'Unlock all features',
                    message: 'Log in or create an account to unlock all features and sync your data.',
                    onLogIn: () => _goToLogin(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 4,
        onTap: (i) => navigateToTab(context, i, 4),
      ),
    );
  }
}
