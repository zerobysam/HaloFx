import 'package:flutter/material.dart';
import '../../../core/state/trade_journal_store.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/ad_banner.dart';
import '../../accounts/models/trading_account.dart';
import '../../journal/screens/save_setup_screen.dart';
import '../models/trade.dart';
import 'journal_dashboard_screen.dart';

class TradeCalculatorResultScreen extends StatefulWidget {
  final TradingAccount account;
  final String symbol;
  final double lots;
  final double riskAmount;
  final double potentialProfit;
  final double potentialLoss;
  final double marginRequired;
  final double accountRiskPercent;

  const TradeCalculatorResultScreen({
    super.key,
    required this.account,
    required this.symbol,
    required this.lots,
    required this.riskAmount,
    required this.potentialProfit,
    required this.potentialLoss,
    required this.marginRequired,
    required this.accountRiskPercent,
  });

  @override
  State<TradeCalculatorResultScreen> createState() => _TradeCalculatorResultScreenState();
}

class _TradeCalculatorResultScreenState extends State<TradeCalculatorResultScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  int get _qualityStars {
    // Purely presentational scoring off account-risk sanity, matching
    // the "Optimal" badge shown for well-sized, low-risk setups.
    if (widget.accountRiskPercent <= 1.0) return 5;
    if (widget.accountRiskPercent <= 2.0) return 4;
    if (widget.accountRiskPercent <= 3.0) return 3;
    return 2;
  }

  String get _qualityLabel => _qualityStars >= 4 ? 'Optimal' : (_qualityStars == 3 ? 'Acceptable' : 'Risky');

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _scale = Tween<double>(begin: 0.85, end: 1).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _logTrade() {
    final trade = Trade(
      id: 'from_calc_${DateTime.now().millisecondsSinceEpoch}',
      symbol: widget.symbol,
      market: 'Forex',
      direction: TradeDirection.buy,
      status: TradeStatus.open,
      entryPrice: 0,
      exitPrice: 0,
      lotSize: widget.lots,
      profit: 0,
      profitR: 0,
      date: DateTime.now(),
      duration: Duration.zero,
      notes: 'Logged from Position Size calculator (${widget.accountRiskPercent.toStringAsFixed(2)}% risk).',
    );
    TradeJournalStore.addTrade(trade);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const JournalDashboardScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
                  ),
                  Expanded(child: Text('Position Size Result', style: AppTypography.headlineSmall.copyWith(fontSize: 16))),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.ios_share_rounded, color: AppColors.textSecondary, size: 20)),
                ],
              ),
              const SizedBox(height: 8),

              FadeTransition(
                opacity: _fade,
                child: ScaleTransition(
                  scale: _scale,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: AppColors.bgElevated, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Recommended Position Size', style: AppTypography.bodySmall.copyWith(fontSize: 12)),
                        const SizedBox(height: 8),
                        Text('${widget.lots.toStringAsFixed(2)} Lots', style: AppTypography.numberLarge.copyWith(color: AppColors.success, fontSize: 30)),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: AppColors.success.withOpacity(0.15), borderRadius: BorderRadius.circular(100)),
                          child: Text(_qualityLabel, style: AppTypography.caption.copyWith(color: AppColors.success, fontWeight: FontWeight.w700)),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: List.generate(5, (i) => Icon(
                                i < _qualityStars ? Icons.star_rounded : Icons.star_border_rounded,
                                color: AppColors.gold,
                                size: 18,
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              _statRow('Risk Amount', '\$${widget.riskAmount.toStringAsFixed(2)}'),
              _statRow('Potential Profit (1:2.5)', '\$${widget.potentialProfit.toStringAsFixed(2)}', valueColor: AppColors.success),
              _statRow('Potential Loss', '\$${widget.potentialLoss.toStringAsFixed(2)}', valueColor: AppColors.danger),
              _statRow('Margin Required', '\$${widget.marginRequired.toStringAsFixed(2)}'),
              _statRow('Current Drawdown', '${widget.account.drawdownPercent.toStringAsFixed(2)}%'),
              _statRow('Account Risk After Trade', '${widget.accountRiskPercent.toStringAsFixed(2)}%', isLast: true),

              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.08), borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.primary.withOpacity(0.3))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.auto_awesome_rounded, color: AppColors.primaryLight, size: 16),
                        const SizedBox(width: 8),
                        Text('AI Insight', style: AppTypography.bodyMedium.copyWith(color: AppColors.primaryLight, fontWeight: FontWeight.w700, fontSize: 13.5)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('Position size reduced because:', style: AppTypography.bodySmall.copyWith(fontSize: 12.5)),
                    const SizedBox(height: 6),
                    _insightBullet('You had 2 losing trades yesterday'),
                    _insightBullet('Market volatility is high'),
                    _insightBullet('Current drawdown is above 4%'),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => SaveSetupScreen(initialName: '${widget.symbol} Setup'))),
                      style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.border), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                      child: Text('Save Setup', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _logTrade,
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                      child: Text('Log Trade', style: AppTypography.buttonText.copyWith(fontSize: 15)),
                    ),
                  ),
                ],
              ),

              const AdBanner(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Text('Estimates for planning purposes only — not financial advice.', textAlign: TextAlign.center, style: AppTypography.caption),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statRow(String label, String value, {Color? valueColor, bool isLast = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      margin: const EdgeInsets.only(bottom: 1),
      decoration: BoxDecoration(border: isLast ? null : const Border(bottom: BorderSide(color: AppColors.divider))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodyMedium.copyWith(fontSize: 13.5)),
          Text(value, style: AppTypography.bodyMedium.copyWith(fontSize: 14, fontWeight: FontWeight.w700, color: valueColor ?? AppColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _insightBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 14),
          const SizedBox(width: 6),
          Expanded(child: Text(text, style: AppTypography.bodySmall.copyWith(fontSize: 12.5))),
        ],
      ),
    );
  }
}
