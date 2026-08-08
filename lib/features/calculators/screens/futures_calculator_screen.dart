import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/labeled_dropdown_field.dart';
import '../../../core/widgets/labeled_input_field.dart';
import '../models/futures_calculation_result.dart';
import '../widgets/direction_toggle.dart';
import 'futures_result_screen.dart';

class FuturesCalculatorScreen extends StatefulWidget {
  const FuturesCalculatorScreen({super.key});

  @override
  State<FuturesCalculatorScreen> createState() => _FuturesCalculatorScreenState();
}

class _FuturesCalculatorScreenState extends State<FuturesCalculatorScreen> {
  String _account = 'Hyperliquid Account';
  String _exchange = 'Hyperliquid';
  String _asset = 'BTCUSDC';
  TradeDirection _direction = TradeDirection.long;
  String _leverage = '20x';

  final _entryController = TextEditingController(text: '118,000');
  final _stopLossController = TextEditingController(text: '116,800');
  final _takeProfitController = TextEditingController(text: '121,500');

  // Simplified assumptions — see FuturesCalculationResult doc comment.
  static const double _assumedAccountBalance = 10000;
  static const double _assumedRiskPercent = 1.0;

  double _parse(String s) => double.tryParse(s.replaceAll(',', '')) ?? 0;

  @override
  void dispose() {
    _entryController.dispose();
    _stopLossController.dispose();
    _takeProfitController.dispose();
    super.dispose();
  }

  void _calculate() {
    final entry = _parse(_entryController.text);
    final stopLoss = _parse(_stopLossController.text);
    final takeProfit = _parse(_takeProfitController.text);
    final leverage = int.tryParse(_leverage.replaceAll('x', '')) ?? 20;

    if (entry <= 0 || stopLoss <= 0 || takeProfit <= 0) return;

    final isLong = _direction == TradeDirection.long;
    final stopLossDistance = (entry - stopLoss).abs();
    final takeProfitDistance = (takeProfit - entry).abs();
    if (stopLossDistance == 0) return;

    final riskAmount = _assumedAccountBalance * (_assumedRiskPercent / 100);
    final positionSize = riskAmount / stopLossDistance;
    final positionValue = positionSize * entry;
    final marginRequired = positionValue / leverage;
    final liquidationPrice = isLong
        ? entry * (1 - 1 / leverage)
        : entry * (1 + 1 / leverage);
    final maxLoss = riskAmount;
    final maxLossPercent = (maxLoss / _assumedAccountBalance) * 100;
    final potentialProfit = positionSize * takeProfitDistance;
    final potentialProfitPercent = (potentialProfit / _assumedAccountBalance) * 100;
    final riskRewardRatio = takeProfitDistance / stopLossDistance;
    final estFees = positionValue * 0.00045;
    final estFunding = positionValue * 0.00008;

    final result = FuturesCalculationResult(
      recommendedPositionSize: positionSize,
      positionValue: positionValue,
      marginRequired: marginRequired,
      liquidationPrice: liquidationPrice,
      maxLoss: maxLoss,
      maxLossPercent: maxLossPercent,
      potentialProfit: potentialProfit,
      potentialProfitPercent: potentialProfitPercent,
      riskRewardRatio: riskRewardRatio,
      estFees: estFees,
      estFunding: estFunding,
      asset: _asset,
      direction: isLong ? 'Long' : 'Short',
      leverage: leverage,
    );

    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 340),
        pageBuilder: (context, animation, __) => FuturesResultScreen(result: result),
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
                      Text('Futures Calculator', style: AppTypography.headlineSmall.copyWith(fontSize: 17)),
                    ],
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.help_outline_rounded, size: 16, color: AppColors.textLink),
                    label: Text('How it works?', style: AppTypography.linkMedium),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              LabeledDropdownField(
                label: 'Account',
                value: _account,
                options: const ['Hyperliquid Account', 'Bybit', 'Binance'],
                leading: const Icon(Icons.bolt_rounded, color: AppColors.gold, size: 18),
                onChanged: (v) => setState(() => _account = v),
              ),
              const SizedBox(height: 14),
              LabeledDropdownField(
                label: 'Exchange',
                value: _exchange,
                options: const ['Hyperliquid', 'Bybit', 'Binance'],
                onChanged: (v) => setState(() => _exchange = v),
              ),
              const SizedBox(height: 14),
              LabeledDropdownField(
                label: 'Asset',
                value: _asset,
                options: const ['BTCUSDC', 'ETHUSDC', 'SOLUSDC'],
                onChanged: (v) => setState(() => _asset = v),
              ),
              const SizedBox(height: 14),

              Text('Direction', style: AppTypography.bodySmall.copyWith(fontSize: 13)),
              const SizedBox(height: 8),
              DirectionToggle(value: _direction, onChanged: (d) => setState(() => _direction = d)),
              const SizedBox(height: 14),

              LabeledInputField(label: 'Entry Price', controller: _entryController, suffixUnit: 'USDC'),
              const SizedBox(height: 14),
              LabeledInputField(label: 'Stop Loss', controller: _stopLossController, suffixUnit: 'USDC'),
              const SizedBox(height: 14),
              LabeledInputField(label: 'Take Profit', controller: _takeProfitController, suffixUnit: 'USDC'),
              const SizedBox(height: 14),
              LabeledDropdownField(
                label: 'Leverage',
                value: _leverage,
                options: const ['5x', '10x', '20x', '50x', '100x'],
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
