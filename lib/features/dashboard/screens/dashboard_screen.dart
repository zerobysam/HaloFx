import 'package:flutter/material.dart';
import 'package:halofx/core/widgets/halo_dashboard_cards.dart';
import 'package:halofx/features/dashboard/widgets/calculator_search_field.dart';
import 'package:halofx/features/dashboard/widgets/continue_calculator_card.dart';
import 'package:halofx/features/dashboard/widgets/dashboard_header.dart';
import 'package:halofx/features/dashboard/widgets/halofx_bottom_nav.dart';
import 'package:halofx/features/dashboard/widgets/planner_preview_card.dart';
import 'package:halofx/features/dashboard/widgets/session_status_card.dart';
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

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _searchController = TextEditingController();
  // const DashboardScreen({super.key});

  int _selectedIndex = 0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

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
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    // 1. Dashboard Header
                    DashboardHeader(
                      onNotificationsTap: () {
                        _showMessage('Notifications coming soon.');
                      },
                    ),

                    const SizedBox(height: 20),

                    // 2. Calculator Search
                    CalculatorSearchField(
                      controller: _searchController,
                      onChanged: (value) {},
                      onFilterTap: () {
                        _showMessage('Calculator filters coming soon.');
                      },
                    ),

                    const SizedBox(height: 20),

                    // 3. Market Sessions
                    MarketSessionsCard(
                      now: DateTime.now().toUtc(),
                    ),

                    const SizedBox(height: 12),

                    // 4. Active Session
                    const SessionStatusCard(),

                    const SizedBox(height: 20),

                    // 5. Next Planner
                    PlannerPreviewCard(
                      onTap: () {
                        _showMessage('Opening planner...');
                      },
                    ),

                    const SizedBox(height: 20),

                    // 6. Continue Last Calculator
                    ContinueCalculatorCard(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PositionSizeScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // bottomNavigationBar: AppBottomNavBar(
      //   currentIndex: 0,
      //   onTap: (i) => navigateToTab(context, i, 0),
      // ),

      // 7. Bottom Navigation
      bottomNavigationBar: SafeArea(
        top: false,
        child: HaloFxBottomNav(
          selectedIndex: _selectedIndex,
          onSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });

            if (index != 0) {
              navigateToTab(context, index, 0);
              // _showMessage(
              //   '${_navName(index)} coming soon.',
              // );

              setState(() {
                _selectedIndex = 0;
              });
            }
          },
          onQuickAction: () {
            _showMessage('Quick actions coming soon.');
          },
        ),
      ),
    );
  }
}
