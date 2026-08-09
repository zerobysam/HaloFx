import 'package:flutter/material.dart';
import '../../../core/state/accounts_store.dart';
import '../../../core/state/trade_journal_store.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/sparkline_chart.dart';
import '../models/trade.dart';
import '../widgets/journal_bottom_nav.dart';
import '../widgets/trade_list_tile.dart';
import 'add_trade_options_screen.dart';
import 'journal_list_screen.dart';
import 'manual_trade_entry_screen.dart';
import 'trade_calculator_screen.dart';

class JournalDashboardScreen extends StatelessWidget {
  const JournalDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final account = AccountsStore.selectedAccount.value;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: ValueListenableBuilder<List<Trade>>(
          valueListenable: TradeJournalStore.trades,
          builder: (context, trades, _) {
            final today = trades.where((t) {
              final now = trades.isNotEmpty ? trades.first.date : DateTime.now();
              return t.date.year == now.year && t.date.month == now.month && t.date.day == now.day;
            }).toList();

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              children: [
                Row(
                  children: [
                    const Icon(Icons.menu_rounded, color: AppColors.textPrimary, size: 22),
                    const SizedBox(width: 12),
                    Text('Trade Journal', style: AppTypography.headlineSmall.copyWith(fontSize: 18)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(color: AppColors.bgElevated, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_shortAccountName(account.name), style: AppTypography.bodySmall.copyWith(fontSize: 12.5, fontWeight: FontWeight.w600)),
                          const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textTertiary, size: 16),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.notifications_none_rounded, color: AppColors.textSecondary, size: 22),
                  ],
                ),
                const SizedBox(height: 18),

                // Balance card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(color: AppColors.bgElevated, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.border)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Current Balance', style: AppTypography.caption),
                      const SizedBox(height: 6),
                      Text('\$${account.balance.toStringAsFixed(2)}', style: AppTypography.numberLarge.copyWith(fontSize: 30)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text('+${account.changePercent.toStringAsFixed(2)}%', style: AppTypography.bodySmall.copyWith(color: AppColors.success, fontWeight: FontWeight.w700)),
                          const SizedBox(width: 6),
                          Text('Today', style: AppTypography.caption),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SparklineChart(data: account.sparkline, color: AppColors.primaryLight, width: double.infinity, height: 50),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(child: _statTile('Win Rate', '${TradeJournalStore.winRatePercent.toStringAsFixed(0)}%')),
                    Expanded(child: _statTile('Total Trades', '${trades.length}')),
                    Expanded(child: _statTile('Avg RR', TradeJournalStore.averageR.toStringAsFixed(2))),
                  ],
                ),
                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AddTradeOptionsScreen())),
                    icon: const Icon(Icons.add_rounded, color: Colors.white),
                    label: Text('Add Trade', style: AppTypography.buttonText),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                  ),
                ),
                const SizedBox(height: 16),

                // Method shortcuts
                Row(
                  children: [
                    Expanded(child: _methodCard(context, icon: Icons.camera_alt_rounded, label: 'AI Import', sublabel: 'Screenshot', color: AppColors.primaryLight, onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AddTradeOptionsScreen())))),
                    const SizedBox(width: 10),
                    Expanded(child: _methodCard(context, icon: Icons.description_rounded, label: 'CSV Import', sublabel: 'Import Trades', color: AppColors.success, onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AddTradeOptionsScreen())))),
                    const SizedBox(width: 10),
                    Expanded(child: _methodCard(context, icon: Icons.edit_rounded, label: 'Manual Entry', sublabel: 'Add Manually', color: AppColors.gold, onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ManualTradeEntryScreen())))),
                    const SizedBox(width: 10),
                    Expanded(child: _methodCard(context, icon: Icons.cloud_sync_rounded, label: 'Sync Broker', sublabel: 'Coming Soon', color: AppColors.textTertiary, onTap: null)),
                  ],
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Today's Trades", style: AppTypography.headlineSmall.copyWith(fontSize: 15)),
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const JournalListScreen())),
                      child: Text('View All', style: AppTypography.linkMedium.copyWith(fontSize: 13)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                if (today.isEmpty)
                  Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Text('No trades logged today.', style: AppTypography.bodySmall))
                else
                  ...today.map((t) => TradeListTile(trade: t)),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: const JournalBottomNav(current: JournalTab.overview),
    );
  }

  String _shortAccountName(String name) {
    // 'FTMO Challenge' -> 'FTMO 100K' style short label isn't derivable
    // generically, so just show the account name as-is, truncated.
    return name.length > 14 ? '${name.substring(0, 12)}…' : name;
  }

  Widget _statTile(String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(color: AppColors.bgElevated, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Column(
        children: [
          Text(value, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 2),
          Text(label, style: AppTypography.caption),
        ],
      ),
    );
  }

  Widget _methodCard(BuildContext context, {required IconData icon, required String label, required String sublabel, required Color color, required VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: onTap == null ? 0.5 : 1,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
          decoration: BoxDecoration(color: AppColors.bgElevated, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
          child: Column(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(height: 6),
              Text(label, textAlign: TextAlign.center, style: AppTypography.caption.copyWith(fontSize: 10.5, color: AppColors.textSecondary, fontWeight: FontWeight.w700)),
              Text(sublabel, textAlign: TextAlign.center, style: AppTypography.caption.copyWith(fontSize: 9)),
            ],
          ),
        ),
      ),
    );
  }
}
