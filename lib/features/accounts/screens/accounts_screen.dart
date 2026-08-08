import 'package:flutter/material.dart';
import '../../../core/navigation/tab_navigator.dart';
import '../../../core/state/accounts_store.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';
import '../../calculators/widgets/filter_chip_row.dart';
import '../models/trading_account.dart';
import '../widgets/account_card.dart';
import 'account_detail_screen.dart';

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({super.key});

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  static const _filters = ['All Accounts', 'Prop Firms', 'Personal', 'Archived'];
  String _selectedFilter = 'All Accounts';

  List<TradingAccount> _filtered(List<TradingAccount> all) {
    return all.where((a) {
      switch (_selectedFilter) {
        case 'Prop Firms':
          return a.category == AccountCategory.propFirm;
        case 'Personal':
          return a.category == AccountCategory.personal;
        case 'Archived':
          return a.category == AccountCategory.archived;
        default:
          return true;
      }
    }).toList();
  }

  void _openAccount(TradingAccount account) {
    AccountsStore.select(account);
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, __) => AccountDetailScreen(account: account),
        transitionsBuilder: (context, animation, __, child) {
          final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(curved),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: ValueListenableBuilder<List<TradingAccount>>(
          valueListenable: AccountsStore.accounts,
          builder: (context, accounts, _) {
            final items = _filtered(accounts);
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Accounts', style: AppTypography.headlineMedium.copyWith(fontSize: 24)),
                      Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                        child: const Icon(Icons.add_rounded, color: Colors.white, size: 22),
                      ),
                    ],
                  ),
                ),
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
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                    children: [
                      for (final a in items) AccountCard(account: a, onTap: () => _openAccount(a)),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 22),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: AppColors.primary, style: BorderStyle.solid, width: 1.5),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: 36, height: 36,
                                decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.15), shape: BoxShape.circle),
                                child: const Icon(Icons.add_rounded, color: AppColors.primaryLight, size: 20),
                              ),
                              const SizedBox(height: 8),
                              Text('Add New Account', style: AppTypography.bodyLarge.copyWith(color: AppColors.primaryLight, fontWeight: FontWeight.w700, fontSize: 15)),
                              const SizedBox(height: 2),
                              Text('Track another account or prop firm', style: AppTypography.bodySmall.copyWith(fontSize: 12.5)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 1,
        onTap: (i) => navigateToTab(context, i, 1),
      ),
    );
  }
}
