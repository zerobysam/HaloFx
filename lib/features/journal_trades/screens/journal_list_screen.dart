import 'package:flutter/material.dart';
import '../../../core/state/trade_journal_store.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../models/trade.dart';
import '../widgets/journal_bottom_nav.dart';
import '../widgets/trade_list_tile.dart';
import 'add_trade_options_screen.dart';
import 'trade_details_screen.dart';

class JournalListScreen extends StatefulWidget {
  const JournalListScreen({super.key});

  @override
  State<JournalListScreen> createState() => _JournalListScreenState();
}

class _JournalListScreenState extends State<JournalListScreen> {
  static const _filters = ['All Trades', 'Open', 'Closed', 'Favorites'];
  String _filter = 'All Trades';

  List<Trade> _filtered(List<Trade> all) {
    switch (_filter) {
      case 'Open':
        return all.where((t) => t.status == TradeStatus.open).toList();
      case 'Closed':
        return all.where((t) => t.status == TradeStatus.closed).toList();
      case 'Favorites':
        return const []; // TODO: wire favoriting once that's tracked per-trade
      default:
        return all;
    }
  }

  Map<String, List<Trade>> _groupByDate(List<Trade> trades) {
    final map = <String, List<Trade>>{};
    for (final t in trades) {
      final key = '${_monthName(t.date.month)} ${t.date.day}, ${t.date.year}';
      map.putIfAbsent(key, () => []).add(t);
    }
    return map;
  }

  String _monthName(int m) => const ['', 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'][m];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: ValueListenableBuilder<List<Trade>>(
          valueListenable: TradeJournalStore.trades,
          builder: (context, allTrades, _) {
            final filtered = _filtered(allTrades);
            final grouped = _groupByDate(filtered);

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                  child: Row(
                    children: [
                      const Icon(Icons.menu_book_rounded, color: AppColors.textPrimary, size: 20),
                      const SizedBox(width: 10),
                      Text('Journal', style: AppTypography.headlineSmall.copyWith(fontSize: 18)),
                      const Spacer(),
                      const Icon(Icons.search_rounded, color: AppColors.textSecondary, size: 22),
                      const SizedBox(width: 14),
                      const Icon(Icons.filter_list_rounded, color: AppColors.textSecondary, size: 22),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: _filters.map((f) {
                      final isActive = f == _filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => setState(() => _filter = f),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(color: isActive ? AppColors.primary : AppColors.bgElevated, borderRadius: BorderRadius.circular(100), border: Border.all(color: isActive ? AppColors.primary : AppColors.border)),
                            child: Text(f, style: AppTypography.bodySmall.copyWith(fontSize: 12.5, fontWeight: isActive ? FontWeight.w700 : FontWeight.w500, color: isActive ? Colors.white : AppColors.textSecondary)),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Expanded(
                  child: grouped.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.menu_book_outlined, color: AppColors.textTertiary, size: 32),
                              const SizedBox(height: 10),
                              Text('No trades here yet', style: AppTypography.bodyMedium),
                            ],
                          ),
                        )
                      : ListView(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 90),
                          children: grouped.entries.map((entry) {
                            final dayTotal = entry.value.fold<double>(0, (sum, t) => sum + t.profit);
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(entry.key, style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w600, fontSize: 12.5)),
                                      Text('${entry.value.length} Trades', style: AppTypography.caption),
                                      Text('${dayTotal >= 0 ? '+' : ''}\$${dayTotal.abs().toStringAsFixed(2)}', style: AppTypography.bodySmall.copyWith(color: dayTotal >= 0 ? AppColors.success : AppColors.danger, fontWeight: FontWeight.w700, fontSize: 12.5)),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(color: AppColors.bgElevated, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                                  child: Column(
                                    children: entry.value.map((t) => TradeListTile(
                                          trade: t,
                                          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => TradeDetailsScreen(trade: t))),
                                        )).toList(),
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],
                            );
                          }).toList(),
                        ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 40,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AddTradeOptionsScreen())),
            icon: const Icon(Icons.add_rounded, color: Colors.white),
            label: Text('Add Trade', style: AppTypography.buttonText),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
          ),
        ),
      ),
      bottomNavigationBar: const JournalBottomNav(current: JournalTab.journal),
    );
  }
}
