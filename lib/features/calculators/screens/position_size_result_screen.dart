import 'package:flutter/material.dart';
import '../../../core/auth/access_control.dart';
import '../../../core/state/calculation_history_store.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/ad_banner.dart';
import '../../../core/widgets/subscribe_screen.dart';
import '../../history/models/calculation_history_entry.dart';
import '../../journal/screens/save_setup_screen.dart';
import '../models/position_size_result.dart';

class PositionSizeResultScreen extends StatefulWidget {
  final PositionSizeResult result;

  const PositionSizeResultScreen({super.key, required this.result});

  @override
  State<PositionSizeResultScreen> createState() => _PositionSizeResultScreenState();
}

class _PositionSizeResultScreenState extends State<PositionSizeResultScreen>
    with TickerProviderStateMixin {
  late final AnimationController _heroController;
  late final Animation<double> _heroFade;
  late final Animation<double> _heroScale;

  @override
  void initState() {
    super.initState();
    _heroController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _heroFade = CurvedAnimation(parent: _heroController, curve: Curves.easeOut);
    _heroScale = Tween<double>(begin: 0.85, end: 1)
        .animate(CurvedAnimation(parent: _heroController, curve: Curves.easeOutBack));
    _heroController.forward();
  }

  @override
  void dispose() {
    _heroController.dispose();
    super.dispose();
  }

  String _fmt(double v) {
    final parts = v.toStringAsFixed(2).split('.');
    final intPart = parts[0].replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',');
    return '$intPart.${parts[1]}';
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
                      Text('Position Size Result', style: AppTypography.headlineSmall.copyWith(fontSize: 16)),
                    ],
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.ios_share_rounded, color: AppColors.textSecondary, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 8),

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
                            Text('${r.market} · ${r.pair}', style: AppTypography.bodySmall.copyWith(fontSize: 12)),
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
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(r.lots.toStringAsFixed(2),
                                style: AppTypography.numberLarge.copyWith(color: AppColors.success, fontSize: 34)),
                            const SizedBox(width: 8),
                            Text('Lots', style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(child: _StatCard(label: 'Position Value', value: '\$${_fmt(r.positionValue)}', delay: 0)),
                  const SizedBox(width: 12),
                  Expanded(child: _StatCard(label: 'Required Margin', value: '\$${_fmt(r.requiredMargin)}', delay: 60)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'Potential Loss',
                      value: '-\$${_fmt(r.potentialLoss)}',
                      valueColor: AppColors.danger,
                      delay: 120,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      label: 'Potential Profit',
                      value: '+\$${_fmt(r.potentialProfit)}',
                      valueColor: AppColors.success,
                      delay: 180,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _StatCard(label: 'Risk / Reward', value: '1 : ${r.riskRewardMultiple.toStringAsFixed(1)}', delay: 240, fullWidth: true),

              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.auto_awesome_rounded, color: AppColors.primaryLight, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('AI Recommendation',
                              style: AppTypography.bodySmall.copyWith(fontSize: 12, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Text(
                            'Position size is optimal based on your risk, recent performance and market volatility.',
                            style: AppTypography.bodySmall.copyWith(fontSize: 12.5, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

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
                      calculatorTitle: 'Position Size',
                      resultSummary: '${r.lots.toStringAsFixed(2)} lots · ${r.pair}',
                      icon: Icons.straighten_rounded,
                      timestamp: DateTime.now(),
                    ));
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => SaveSetupScreen(
                          initialName: '${r.market} ${r.pair} Setup',
                          initialTags: {r.pair},
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
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
                  'Estimates for planning purposes only — not financial advice.',
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
  final bool fullWidth;

  const _StatCard({
    required this.label,
    required this.value,
    this.valueColor,
    required this.delay,
    this.fullWidth = false,
  });

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
          width: widget.fullWidth ? double.infinity : null,
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
