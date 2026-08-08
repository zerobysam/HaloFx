import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/labeled_dropdown_field.dart';
import '../../../core/widgets/labeled_input_field.dart';
import '../models/position_size_result.dart';
import 'position_size_result_screen.dart';

class PositionSizeScreen extends StatefulWidget {
  const PositionSizeScreen({super.key});

  @override
  State<PositionSizeScreen> createState() => _PositionSizeScreenState();
}

class _PositionSizeScreenState extends State<PositionSizeScreen> {
  final _balanceController = TextEditingController(text: '100,000');
  final _riskController = TextEditingController(text: '1');
  final _stopLossController = TextEditingController(text: '25');

  String _market = 'Forex';
  String _pair = 'EUR/USD';
  String _leverage = '30x';

  bool _isFavorite = true;

  double _parse(String s) => double.tryParse(s.replaceAll(',', '')) ?? 0;

  // Simplified assumptions — see PositionSizeResult doc comment.
  static const double _pipValuePerStandardLot = 10.0;
  static const double _assumedPairPrice = 1.15;
  static const double _assumedRewardMultiple = 2.5;

  void _calculate() {
    final balance = _parse(_balanceController.text.isEmpty ? '10000' : _balanceController.text);
    final riskPct = _parse(_riskController.text);
    final stopLossPips = _parse(_stopLossController.text);
    final leverage = double.tryParse(_leverage.replaceAll('x', '')) ?? 30;

    if (balance <= 0 || riskPct <= 0 || stopLossPips <= 0) return;

    final riskAmount = balance * (riskPct / 100);
    final lots = riskAmount / (stopLossPips * _pipValuePerStandardLot);
    final positionValue = lots * 100000 * _assumedPairPrice;
    final requiredMargin = positionValue / leverage;
    final potentialProfit = riskAmount * _assumedRewardMultiple;

    final result = PositionSizeResult(
      lots: lots,
      positionValue: positionValue,
      requiredMargin: requiredMargin,
      potentialLoss: riskAmount,
      potentialProfit: potentialProfit,
      riskRewardMultiple: _assumedRewardMultiple,
      pair: _pair,
      market: _market,
    );

    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 340),
        pageBuilder: (context, animation, __) => PositionSizeResultScreen(result: result),
        transitionsBuilder: (context, animation, __, child) {
          final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
          return SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(curved),
            child: child,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _balanceController.dispose();
    _riskController.dispose();
    _stopLossController.dispose();
    super.dispose();
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
                      ),
                      Text('Position Size', style: AppTypography.headlineSmall),
                    ],
                  ),
                  IconButton(
                    onPressed: () => setState(() => _isFavorite = !_isFavorite),
                    icon: Icon(
                      _isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
                      color: AppColors.gold,
                      size: 24,
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.help_outline_rounded, size: 16, color: AppColors.textLink),
                  label: Text('How it works?', style: AppTypography.linkMedium),
                ),
              ),

              // Market + Pair side by side
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: LabeledDropdownField(
                      label: 'Market',
                      value: _market,
                      options: const ['Forex', 'Crypto', 'Futures', 'Stocks'],
                      onChanged: (v) => setState(() => _market = v),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: LabeledDropdownField(
                      label: 'Pair',
                      value: _pair,
                      options: const ['EUR/USD', 'GBP/USD', 'USD/JPY', 'XAU/USD'],
                      leading: const Text('🇪🇺🇺🇸', style: TextStyle(fontSize: 14)),
                      onChanged: (v) => setState(() => _pair = v),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              LabeledInputField(
                label: 'Account Balance (Optional)',
                controller: _balanceController,
                suffixUnit: 'USD',
              ),
              const SizedBox(height: 16),
              LabeledInputField(
                label: 'Risk Percentage',
                controller: _riskController,
                suffixUnit: '%',
              ),
              const SizedBox(height: 16),
              LabeledInputField(
                label: 'Stop Loss',
                controller: _stopLossController,
                suffixUnit: 'Pips',
              ),
              const SizedBox(height: 16),
              LabeledDropdownField(
                label: 'Leverage (Optional)',
                value: _leverage,
                options: const ['10x', '20x', '30x', '50x', '100x'],
                onChanged: (v) => setState(() => _leverage = v),
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _calculate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text('Calculate', style: AppTypography.buttonText),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
