import 'package:flutter/material.dart';
import '../../../core/state/auth_status.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../core/widgets/guest_upsell_banner.dart';
import '../../../core/navigation/tab_navigator.dart';
import '../../auth/screens/login_screen.dart';
import '../../auth/screens/signup_screen.dart';
import '../../calculators/screens/currency_converter_screen.dart';
import '../../calculators/screens/futures_calculator_screen.dart';
import '../../calculators/screens/position_size_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const _quickActions = [
    (icon: Icons.straighten_rounded, label: 'Position Size'),
    (icon: Icons.bolt_rounded, label: 'Futures Calc'),
    (icon: Icons.swap_horiz_rounded, label: 'Converter'),
    (icon: Icons.grain_rounded, label: 'Pip Value'),
  ];

  void _openQuickAction(BuildContext context, int i) {
    final Widget screen = switch (i) {
      0 => const PositionSizeScreen(),
      1 => const FuturesCalculatorScreen(),
      2 => const CurrencyConverterScreen(),
      _ => const PositionSizeScreen(),
    };
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: ValueListenableBuilder<bool>(
          valueListenable: AuthStatus.isLoggedIn,
          builder: (context, isLoggedIn, _) {
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isLoggedIn ? 'Good morning 👋' : 'Welcome',
                      style: AppTypography.headlineMedium.copyWith(fontSize: 22),
                    ),
                    const Icon(Icons.notifications_none_rounded, color: AppColors.textSecondary, size: 24),
                  ],
                ),
                const SizedBox(height: 16),

                if (isLoggedIn)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.bgElevated,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Balance (All Accounts)', style: AppTypography.bodySmall.copyWith(fontSize: 12)),
                        const SizedBox(height: 6),
                        Text('\$142,430.50', style: AppTypography.numberLarge),
                        const SizedBox(height: 4),
                        Text('+2.45% today', style: AppTypography.bodySmall.copyWith(color: AppColors.success, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  )
                else
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.bgElevated,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Calculate instantly. Create account anytime.',
                            style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Text('All calculators and converters are free to use without an account.',
                            style: AppTypography.bodySmall.copyWith(fontSize: 12.5)),
                      ],
                    ),
                  ),

                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Quick Actions', style: AppTypography.headlineSmall.copyWith(fontSize: 16)),
                    GestureDetector(
                      onTap: () => navigateToTab(context, 2, 0),
                      child: Text('See All', style: AppTypography.linkMedium.copyWith(fontSize: 13)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _quickActions.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.85,
                  ),
                  itemBuilder: (context, i) {
                    final action = _quickActions[i];
                    return GestureDetector(
                      onTap: () => _openQuickAction(context, i),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.bgElevated,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(action.icon, color: AppColors.primaryLight, size: 22),
                            const SizedBox(height: 8),
                            Text(
                              action.label,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: AppTypography.caption.copyWith(fontSize: 10.5, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                if (!isLoggedIn) ...[
                  const SizedBox(height: 16),
                  GuestUpsellBanner(
                    onCreateAccount: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SignupScreen()),
                    ),
                    onLogIn: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 0,
        onTap: (i) => navigateToTab(context, i, 0),
      ),
    );
  }
}
