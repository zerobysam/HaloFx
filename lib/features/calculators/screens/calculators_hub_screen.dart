import 'package:flutter/material.dart';
import '../../../core/auth/access_control.dart';
import '../../../core/navigation/tab_navigator.dart';
import '../../../core/state/auth_status.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../core/widgets/guest_upsell_banner.dart';
import '../../auth/screens/login_screen.dart';
import '../../auth/screens/signup_screen.dart';
import '../data/calculator_items.dart';
import '../models/calculator_access_level.dart';
import '../models/calculator_item.dart';
import '../widgets/calculator_grid_card.dart';
import '../widgets/filter_chip_row.dart';
import 'coming_soon_screen.dart';

class CalculatorsHubScreen extends StatefulWidget {
  const CalculatorsHubScreen({super.key});

  @override
  State<CalculatorsHubScreen> createState() => _CalculatorsHubScreenState();
}

class _CalculatorsHubScreenState extends State<CalculatorsHubScreen> {
  static const _filters = ['All', 'Favorites', 'Forex', 'Crypto', 'Futures', 'Stocks'];
  String _selectedFilter = 'All';
  String _query = '';

  List<CalculatorItem> get _filteredItems {
    return calculatorItems.where((item) {
      final matchesQuery = _query.isEmpty || item.title.toLowerCase().contains(_query.toLowerCase());
      final matchesFilter = switch (_selectedFilter) {
        'All' => true,
        'Favorites' => item.isFavorite,
        _ => item.categories.contains(_selectedFilter.toLowerCase()),
      };
      return matchesQuery && matchesFilter;
    }).toList();
  }

  Future<void> _openCalculator(CalculatorItem item) async {
    // Login-gated calculators (Risk Reward, Drawdown, etc — see
    // calculator_items.dart) require an account before opening at all.
    if (item.accessLevel == CalculatorAccessLevel.requiresLogin) {
      final allowed = await ensureLoggedIn(context, featureName: item.title);
      if (!allowed || !mounted) return;
    }

    final builder = item.screenBuilder?.call() ?? (_) => ComingSoonScreen(title: item.title);
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 320),
        pageBuilder: (context, animation, __) => builder(context),
        transitionsBuilder: (context, animation, __, child) {
          final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero).animate(curved),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = _filteredItems;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Calculators', style: AppTypography.headlineMedium.copyWith(fontSize: 24)),
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(color: AppColors.bgElevated, shape: BoxShape.circle, border: Border.all(color: AppColors.border)),
                    child: const Icon(Icons.add_rounded, color: AppColors.textPrimary, size: 20),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.bgInput,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: TextField(
                  onChanged: (v) => setState(() => _query = v),
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Search calculators',
                    hintStyle: AppTypography.bodyMedium,
                    prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textTertiary, size: 20),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: FilterChipRow(
                filters: _filters,
                selected: _selectedFilter,
                onSelected: (f) => setState(() => _selectedFilter = f),
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: items.isEmpty
                  ? Center(child: Text('No calculators found', style: AppTypography.bodyMedium))
                  : GridView.builder(
                      key: ValueKey('$_selectedFilter-$_query'),
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      itemCount: items.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.98,
                      ),
                      itemBuilder: (context, i) {
                        return CalculatorGridCard(
                          item: items[i],
                          animationDelay: Duration(milliseconds: 40 * i),
                          onTap: () => _openCalculator(items[i]),
                        );
                      },
                    ),
            ),

            // Guest upsell banner (hidden once logged in)
            ValueListenableBuilder<bool>(
              valueListenable: AuthStatus.isLoggedIn,
              builder: (context, isLoggedIn, _) {
                if (isLoggedIn) return const SizedBox.shrink();
                return GuestUpsellBanner(
                  onCreateAccount: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SignupScreen()),
                  ),
                  onLogIn: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 2,
        onTap: (i) => navigateToTab(context, i, 2),
      ),
    );
  }
}
