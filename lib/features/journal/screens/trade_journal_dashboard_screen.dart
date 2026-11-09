import 'package:flutter/material.dart';
import '../../../core/state/accounts_store.dart';
import '../../../core/state/journal_store.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/sparkline_chart.dart';
import '../../accounts/models/trading_account.dart';
import '../../calculators/screens/risk_calculator_screen.dart';
import '../../more/screens/more_screen.dart';
import '../models/trade_entry.dart';
import '../widgets/journal_nav_bar.dart';
import 'add_trade_options_screen.dart';
// import 'balance_history_screen.dart';
// import 'journal_list_screen.dart';
// import 'journal_position_size_calculator_screen.dart';
// import 'trade_details_screen.dart';

class TradeJournalDashboardScreen extends StatefulWidget {
  final TradingAccount account;

  const TradeJournalDashboardScreen({super.key, required this.account});

  @override
  State<TradeJournalDashboardScreen> createState() =>
      _TradeJournalDashboardScreenState();
}

class _TradeJournalDashboardScreenState
    extends State<TradeJournalDashboardScreen> {
  void _onNavTap(int i) {
    if (i == 0) return;
    Widget screen;
    // switch (i) {
    //   case 1:
    //     screen = const JournalListScreen();
    //     break;
    //   case 2:
    //     screen = JournalPositionSizeCalculatorScreen(account: widget.account);
    //     break;
    //   case 3:
    //     screen = BalanceHistoryScreen(account: widget.account);
    //     break;
    //   default:
    //     screen = const MoreScreen();
    // }
    // Navigator.of(context).pushReplacement(
    //   PageRouteBuilder(
    //     transitionDuration: const Duration(milliseconds: 220),
    //     pageBuilder: (context, animation, __) => screen,
    //     transitionsBuilder: (context, animation, __, child) =>
    //         FadeTransition(opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut), child: child),
    //   ),
    // );
  }

  void _openAddTrade() {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (_) => AddTradeOptionsScreen(account: widget.account)),
    );
  }

  String _fmt(double v) {
    final isNeg = v < 0;
    final parts = v.abs().toStringAsFixed(2).split('.');
    final intPart =
        parts[0].replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',');
    return '${isNeg ? '-' : ''}\$$intPart.${parts[1]}';
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.account;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: ValueListenableBuilder<List<TradeEntry>>(
          valueListenable: JournalStore.trades,
          builder: (context, trades, _) {
            final todaysTrades = trades
                .where((t) =>
                    t.date.year == trades.first.date.year &&
                    t.date.month == trades.first.date.month &&
                    t.date.day == trades.first.date.day)
                .toList();

            return Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: const Icon(Icons.menu_rounded,
                            color: AppColors.textPrimary, size: 22),
                      ),
                      Text('Trade Journal',
                          style: AppTypography.headlineSmall
                              .copyWith(fontSize: 17)),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: AppColors.bgElevated,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(color: AppColors.border)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(a.badgeLabel == 'FTMO' ? 'FTMO 100K' : a.name,
                                style: AppTypography.bodySmall.copyWith(
                                    fontSize: 12, fontWeight: FontWeight.w600)),
                            const Icon(Icons.keyboard_arrow_down_rounded,
                                color: AppColors.textTertiary, size: 16),
                          ],
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.notifications_none_rounded,
                          color: AppColors.textSecondary, size: 22),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        // Current balance card
                        GestureDetector(
                          onTap: () => {
                            // Navigator.of(context).push(MaterialPageRoute(
                            //     builder: (_) =>
                            //         BalanceHistoryScreen(account: a)))
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [
                                Color(0xFF241A47),
                                Color(0xFF1A1430)
                              ]),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                  color: AppColors.primary.withOpacity(0.35)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Current Balance',
                                    style: AppTypography.bodySmall
                                        .copyWith(fontSize: 12.5)),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(_fmt(a.balance),
                                        style: AppTypography.numberLarge
                                            .copyWith(fontSize: 30)),
                                    SparklineChart(
                                        data: a.sparkline,
                                        color: AppColors.success,
                                        width: 90,
                                        height: 36),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                    '+${a.changePercent.toStringAsFixed(2)}%  Today',
                                    style: AppTypography.bodySmall.copyWith(
                                        color: AppColors.success,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12.5)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Stats row
                        Row(
                          children: [
                            Expanded(
                                child: _statBox(
                                    'Win Rate',
                                    '${JournalStore.winRatePercent.toStringAsFixed(0)}%',
                                    AppColors.success)),
                            const SizedBox(width: 10),
                            Expanded(
                                child: _statBox('Total Trades',
                                    '${trades.length}', AppColors.textPrimary)),
                            const SizedBox(width: 10),
                            Expanded(
                                child: _statBox(
                                    'Avg RR',
                                    JournalStore.avgRMultiple
                                        .toStringAsFixed(2),
                                    AppColors.primaryLight)),
                          ],
                        ),
                        const SizedBox(height: 16),

                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton.icon(
                            onPressed: _openAddTrade,
                            icon: const Icon(Icons.add_rounded,
                                color: Colors.white, size: 20),
                            label: Text('Add Trade',
                                style: AppTypography.buttonText),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14))),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Import method grid
                        Row(
                          children: [
                            Expanded(
                                child: _importCard(
                                    icon: Icons.camera_alt_rounded,
                                    iconColor: AppColors.primaryLight,
                                    title: 'AI Import',
                                    subtitle: 'Screenshot',
                                    highlighted: true,
                                    onTap: _openAddTrade)),
                            const SizedBox(width: 10),
                            Expanded(
                                child: _importCard(
                                    icon: Icons.description_rounded,
                                    iconColor: AppColors.success,
                                    title: 'CSV Import',
                                    subtitle: 'Import Trades',
                                    onTap: _openAddTrade)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                                child: _importCard(
                                    icon: Icons.edit_rounded,
                                    iconColor: const Color(0xFFF59E0B),
                                    title: 'Manual Entry',
                                    subtitle: 'Add Manually',
                                    onTap: _openAddTrade)),
                            const SizedBox(width: 10),
                            Expanded(
                                child: _importCard(
                                    icon: Icons.cloud_sync_rounded,
                                    iconColor: AppColors.textTertiary,
                                    title: 'Sync Broker',
                                    subtitle: 'Coming Soon',
                                    disabled: true,
                                    onTap: () {})),
                          ],
                        ),
                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Today's Trades",
                                style: AppTypography.headlineSmall
                                    .copyWith(fontSize: 16)),
                            GestureDetector(
                              onTap: () => {
                                // Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (_) => const JournalListScreen())),
                                // child: Text('View All',
                                //     style: AppTypography.linkMedium
                                //         .copyWith(fontSize: 13))
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        for (final t in (todaysTrades.isEmpty
                            ? trades.take(3)
                            : todaysTrades))
                          _tradeRow(t,
                              onTap: () => {
                                    // Navigator.of(context).push(
                                    //   MaterialPageRoute(
                                    //       builder: (_) =>
                                    //           TradeDetailsScreen(trade: t)))
                                  }),

                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: JournalNavBar(currentIndex: 0, onTap: _onNavTap),
    );
  }

  Widget _statBox(String label, String value, Color valueColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
          color: AppColors.bgElevated,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border)),
      child: Column(
        children: [
          Text(value,
              style: AppTypography.bodyLarge.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: valueColor)),
          const SizedBox(height: 2),
          Text(label, style: AppTypography.caption),
        ],
      ),
    );
  }

  Widget _importCard(
      {required IconData icon,
      required Color iconColor,
      required String title,
      required String subtitle,
      bool highlighted = false,
      bool disabled = false,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.bgElevated,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: highlighted ? AppColors.primary : AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon,
                color: disabled ? AppColors.textTertiary : iconColor, size: 22),
            const SizedBox(height: 8),
            Text(title,
                style: AppTypography.bodyMedium.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: disabled
                        ? AppColors.textTertiary
                        : AppColors.textPrimary)),
            Text(subtitle,
                style: AppTypography.caption.copyWith(
                    color: highlighted
                        ? AppColors.primaryLight
                        : AppColors.textTertiary)),
          ],
        ),
      ),
    );
  }

  Widget _tradeRow(TradeEntry t, {required VoidCallback onTap}) {
    final isWin = t.profit >= 0;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            color: AppColors.bgElevated,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border)),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                  color: t.symbolIconColor.withOpacity(0.15),
                  shape: BoxShape.circle),
              child: Icon(t.symbolIcon, color: t.symbolIconColor, size: 16),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.symbol,
                      style: AppTypography.bodyMedium
                          .copyWith(fontSize: 14, fontWeight: FontWeight.w700)),
                  Text(t.direction == TradeDirection.buy ? 'Buy' : 'Sell',
                      style: AppTypography.bodySmall.copyWith(
                          fontSize: 12,
                          color: t.direction == TradeDirection.buy
                              ? AppColors.success
                              : AppColors.danger)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                    '${isWin ? '+' : ''}\$${t.profit.abs().toStringAsFixed(2)}',
                    style: AppTypography.bodyMedium.copyWith(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: isWin ? AppColors.success : AppColors.danger)),
                Text(
                    '${t.profitR >= 0 ? '' : ''}${t.profitR.toStringAsFixed(1)}R',
                    style: AppTypography.caption),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
