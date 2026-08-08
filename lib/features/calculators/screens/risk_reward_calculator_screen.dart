import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/ad_banner.dart';
import '../../../core/widgets/app_gradient_button.dart';
import '../../../core/widgets/labeled_input_field.dart';
import '../models/risk_reward_result.dart';
import 'risk_reward_result_screen.dart';

class RiskRewardCalculatorScreen extends StatefulWidget {
  const RiskRewardCalculatorScreen({super.key});

  @override
  State<RiskRewardCalculatorScreen> createState() =>
      _RiskRewardCalculatorScreenState();
}

class _RiskRewardCalculatorScreenState
    extends State<RiskRewardCalculatorScreen> {
  final TextEditingController _entryController =
      TextEditingController(text: '1.08245');
  final TextEditingController _stopLossController =
      TextEditingController(text: '1.07745');
  final TextEditingController _takeProfitController =
      TextEditingController(text: '1.09245');

  bool _isFavorite = true;

  void _calculateAndNavigate() {
    final double entry = double.tryParse(_entryController.text) ?? 0.0;
    final double stopLoss = double.tryParse(_stopLossController.text) ?? 0.0;
    final double takeProfit =
        double.tryParse(_takeProfitController.text) ?? 0.0;

    if (entry == 0.0 || stopLoss == 0.0 || takeProfit == 0.0) return;

    // PIP multiplier calculation (standard 5-decimal pairs e.g. EUR/USD)
    const double pipMultiplier = 10000.0;

    final double riskPips = (entry - stopLoss).abs() * pipMultiplier;
    final double rewardPips = (takeProfit - entry).abs() * pipMultiplier;
    final double ratio = riskPips > 0 ? (rewardPips / riskPips) : 0.0;

    final result = RiskRewardResult(
      riskPips: riskPips,
      rewardPips: rewardPips,
      ratio: ratio,
    );

    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 320),
        pageBuilder: (context, animation, secondaryAnimation) =>
            RiskRewardResultScreen(result: result),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.04),
                end: Offset.zero,
              ).animate(curved),
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
      appBar: AppBar(
        title: Text(
          'Risk Reward Calculator',
          style: AppTypography.headlineMedium,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
              color: AppColors.gold,
            ),
            onPressed: () => setState(() => _isFavorite = !_isFavorite),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.bgSecondary,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF6C5CE7).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.balance_rounded,
                              color: Color(0xFF8C7CFF),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Risk Reward Calculator',
                            style: AppTypography.headlineMedium
                                .copyWith(fontSize: 18),
                          ),
                          const Spacer(),
                          Icon(
                            _isFavorite
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            color: AppColors.gold,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Input Fields
                      LabeledInputField(
                        label: 'Entry Price',
                        controller: _entryController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                      ),
                      const SizedBox(height: 16),
                      LabeledInputField(
                        label: 'Stop Loss',
                        controller: _stopLossController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                      ),
                      const SizedBox(height: 16),
                      LabeledInputField(
                        label: 'Take Profit',
                        controller: _takeProfitController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                      ),
                      const SizedBox(height: 24),

                      // Calculate Button
                      AppGradientButton(
                        onPressed: _calculateAndNavigate,
                        label: 'Calculate',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const AdBanner(),
          ],
        ),
      ),
    );
  }
}
