import 'package:flutter/material.dart';
import '../../../core/auth/access_control.dart';
import '../../../core/state/calculation_history_store.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/ad_banner.dart';
import '../../../core/widgets/subscribe_screen.dart';
import '../../history/models/calculation_history_entry.dart';
import '../../journal/screens/save_setup_screen.dart';
import '../models/futures_calculation_result.dart';

class FuturesResultScreen extends StatefulWidget {
  final FuturesCalculationResult result;

  const FuturesResultScreen({super.key, required this.result});

  @override
  State<FuturesResultScreen> createState() => _FuturesResultScreenState();
}

class _FuturesResultScreenState extends State<FuturesResultScreen> with TickerProviderStateMixin {
  late final AnimationController _heroController;
  late final Animation<double> _heroFade;
  late final Animation<double> _heroScale;

  @override
  void initState() {
    super.initState();
    _heroController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _heroFade = CurvedAnimation(parent: _heroController, curve: Curves.easeOut);
    _heroScale = Tween<double>(begin: 0.85, end: 1).animate(
      CurvedAnimation(parent: _heroController, curve: Curves.easeOutBack),
    );
    _heroController.forward();
  }

  @override
  void dispose() {
    _heroController.dispose();
    super.dispose();
  }

  String _fmt(double v, {int decimals = 2}) {
    final parts = v.toStringAsFixed(decimals).split('.');
    final intPart = parts[0].replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',');
    return decimals == 0 ? intPart : '$intPart.${parts[1]}';
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.result;

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
                      ),
                      Text('Result', style: AppTypography.headlineSmall),
                    ],
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.ios_share_rounded, color: AppColors.textSecondary, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Hero recommended position
              FadeTransition(
                opacity: _heroFade,
                child: ScaleTransition(
                  scale: _heroScale,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.bgElevated,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Recommended Position', style: AppTypography.bodySmall.copyWith(fontSize: 12)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Text('AI Optimized',
                                  style: AppTypography.caption.copyWith(color: AppColors.primaryLight)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${_fmt(r.recommendedPositionSize, decimals: 3)} ${r.asset.replaceAll('USDC', '')}',
                          style: AppTypography.numberLarge.copyWith(color: AppColors.success),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Stat grid — staggered entrance
              Row(
                children: [
                  Expanded(child: _StatCard(label: 'Position Value', value: '${_fmt(r.positionValue)} USDC', delay: 0)),
                  const SizedBox(width: 12),
                  Expanded(child: _StatCard(label: 'Margin Required', value: '${_fmt(r.marginRequired)} USDC', delay: 60)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _StatCard(label: 'Liquidation Price', value: _fmt(r.liquidationPrice), delay: 120)),
                  const SizedBox(width: 12),
                  Expanded(child: _StatCard(label: 'Max Loss', value: '${r.maxLossPercent.toStringAsFixed(2)}% (\$${_fmt(r.maxLoss)})', delay: 180)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'Potential Profit',
                      value: '+${r.potentialProfitPercent.toStringAsFixed(2)}% (\$${_fmt(r.potentialProfit)})',
                      valueColor: AppColors.success,
                      delay: 240,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: _StatCard(label: 'Risk / Reward', value: '1 : ${r.riskRewardRatio.toStringAsFixed(1)}', delay: 300)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _StatCard(label: 'Est. Fees', value: '${_fmt(r.estFees)} USDC', delay: 360)),
                  const SizedBox(width: 12),
                  Expanded(child: _StatCard(label: 'Est. Funding (8h)', value: '${_fmt(r.estFunding)} USDC', delay: 420)),
                ],
              ),

              const SizedBox(height: 16),
              _AiRecommendationCard(leverage: r.leverage),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () async {
                    final allowed = await ensureLoggedIn(context, featureName: 'Saved Calculations');
                    if (!allowed) return;
                    if (!context.mounted) return;
                    CalculationHistoryStore.record(CalculationHistoryEntry(
                      calculatorTitle: 'Futures Calculator',
                      resultSummary: '${r.recommendedPositionSize.toStringAsFixed(3)} ${r.asset} · ${r.direction}',
                      icon: Icons.bolt_rounded,
                      timestamp: DateTime.now(),
                    ));
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => SaveSetupScreen(
                          initialName: '${r.direction} ${r.asset} ${r.leverage}x Setup',
                          initialTags: {r.asset, r.direction},
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text('Save Setup', style: AppTypography.buttonText),
                ),
              ),

              AdBanner(
                onUpgradeTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SubscribeScreen()),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Text(
                  'Estimates for planning purposes only — not financial advice. '
                  'Verify against your exchange before trading.',
                  textAlign: TextAlign.center,
                  style: AppTypography.caption,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatefulWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final int delay;

  const _StatCard({required this.label, required this.value, this.valueColor, required this.delay});

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 340));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.bgElevated,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.label, style: AppTypography.bodySmall.copyWith(fontSize: 12)),
              const SizedBox(height: 6),
              Text(
                widget.value,
                style: AppTypography.bodyLarge.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: widget.valueColor ?? AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AiRecommendationCard extends StatelessWidget {
  final int leverage;

  const _AiRecommendationCard({required this.leverage});

  @override
  Widget build(BuildContext context) {
    final suggested = (leverage * 0.75).round();
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.warning.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.auto_awesome_rounded, color: AppColors.warning, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AI Recommendation', style: AppTypography.bodySmall.copyWith(fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(
                  'Reduce leverage to ${suggested}x. Current volatility is elevated.',
                  style: AppTypography.bodySmall.copyWith(fontSize: 12.5, height: 1.4),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary),
        ],
      ),
    );
  }
}
