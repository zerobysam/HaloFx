import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/ad_banner.dart';
import '../../../core/widgets/app_gradient_button.dart';
import '../../../core/widgets/labeled_dropdown_field.dart';
import '../../../core/widgets/labeled_input_field.dart';
import '../models/margin_result.dart';
import 'margin_result_screen.dart';

class MarginCalculatorScreen extends StatefulWidget {
  const MarginCalculatorScreen({super.key});

  @override
  State<MarginCalculatorScreen> createState() => _MarginCalculatorScreenState();
}

class _MarginCalculatorScreenState extends State<MarginCalculatorScreen> {
  String _selectedPair = 'XAU/USD';
  String _selectedLot = '1.00';
  String _selectedLeverage = '1:100';
  final TextEditingController _priceController =
      TextEditingController(text: '2345.60');

  MarginResult? _result;

  final List<String> _pairs = ['XAU/USD', 'EUR/USD', 'GBP/USD', 'BTC/USD'];
  final List<String> _lots = ['1.00', '0.50', '0.10', '0.01'];
  final List<String> _leverages = [
    '1:1',
    '1:10',
    '1:20',
    '1:50',
    '1:100',
    '1:500'
  ];

  final NumberFormat _currencyFormat = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 2,
  );

  @override
  void initState() {
    super.initState();
    // _calculateMargin();
  }

  // void _calculateMargin() {
  //   final double price = double.tryParse(_priceController.text) ?? 0.0;
  //   final double lotSize = double.tryParse(_selectedLot) ?? 1.0;

  //   final double leverage =
  //       double.tryParse(_selectedLeverage.split(':').last) ?? 100.0;

  //   final double contractSize =
  //       _selectedPair.startsWith('XAU') ? 100.0 : 100000.0;

  //   final double notionalValue = price * lotSize * contractSize;
  //   final double marginRequired =
  //       leverage > 0 ? (notionalValue / leverage) : 0.0;
  //   final double maintenanceMargin = marginRequired * 0.5;

  //   setState(() {
  //     _result = MarginResult(
  //       marginRequired: marginRequired,
  //       notionalValue: notionalValue,
  //       maintenanceMargin: maintenanceMargin,
  //     );
  //   });
  // }

  void _calculateAndNavigate() {
    final double price = double.tryParse(_priceController.text) ?? 0.0;
    final double lotSize = double.tryParse(_selectedLot) ?? 1.0;
    final double leverage =
        double.tryParse(_selectedLeverage.split(':').last) ?? 100.0;
    final double contractSize =
        _selectedPair.startsWith('XAU') ? 100.0 : 100000.0;

    final double notionalValue = price * lotSize * contractSize;
    final double marginRequired =
        leverage > 0 ? (notionalValue / leverage) : 0.0;
    final double maintenanceMargin = marginRequired * 0.5;

    final result = MarginResult(
      marginRequired: marginRequired,
      notionalValue: notionalValue,
      maintenanceMargin: maintenanceMargin,
    );

    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, animation, __) => FadeTransition(
          opacity: animation,
          child: MarginResultScreen(result: result),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final priceLabel =
        _selectedPair.startsWith('XAU') ? 'Gold Price' : 'Asset Price';

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        title: Text('Margin Calculator', style: AppTypography.headlineMedium),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.star_rounded, color: AppColors.gold),
            onPressed: () {},
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
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.gold.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.layers_rounded,
                              color: AppColors.gold,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Margin Calculator',
                            style: AppTypography.headlineMedium
                                .copyWith(fontSize: 18),
                          ),
                          const Spacer(),
                          const Icon(Icons.star_rounded, color: AppColors.gold),
                        ],
                      ),
                      const SizedBox(height: 20),
                      LabeledDropdownField(
                        label: 'Currency Pair',
                        value: _selectedPair,
                        options: _pairs,
                        onChanged: (v) => setState(() => _selectedPair = v!),
                      ),
                      const SizedBox(height: 16),
                      LabeledDropdownField(
                        label: 'Lot Size',
                        value: _selectedLot,
                        options: _lots,
                        onChanged: (v) => setState(() => _selectedLot = v!),
                      ),
                      const SizedBox(height: 16),
                      LabeledDropdownField(
                        label: 'Leverage',
                        value: _selectedLeverage,
                        options: _leverages,
                        onChanged: (v) =>
                            setState(() => _selectedLeverage = v!),
                      ),
                      const SizedBox(height: 16),
                      LabeledInputField(
                        label: priceLabel,
                        controller: _priceController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                      ),
                      const SizedBox(height: 24),
                      AppGradientButton(
                        onPressed: _calculateAndNavigate,
                        label: 'Calculate',
                      ),
                      const SizedBox(height: 24),
                      if (_result != null) _buildResultCard(),
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

  Widget _buildResultCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bgElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(
            _currencyFormat.format(_result!.marginRequired),
            style: AppTypography.headlineMedium.copyWith(
              color: AppColors.success,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Margin Required',
            style: AppTypography.bodyMedium
                .copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Notional Value', style: AppTypography.bodyMedium),
              Text(
                _currencyFormat.format(_result!.notionalValue),
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Maintenance Margin (50%)', style: AppTypography.bodyMedium),
              Text(
                _currencyFormat.format(_result!.maintenanceMargin),
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
