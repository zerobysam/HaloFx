import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/ad_banner.dart';
import '../../../core/widgets/app_gradient_button.dart';
import '../../../core/widgets/labeled_dropdown_field.dart';
import '../../../core/widgets/labeled_input_field.dart';
import '../models/pip_value_result.dart';
import 'pip_value_result_screen.dart';

class PipValueCalculatorScreen extends StatefulWidget {
  const PipValueCalculatorScreen({super.key});

  @override
  State<PipValueCalculatorScreen> createState() =>
      _PipValueCalculatorScreenState();
}

class _PipValueCalculatorScreenState extends State<PipValueCalculatorScreen> {
  String _selectedPair = 'USD/CHF';
  String _selectedLotType = '1.00 (Standard)';
  String _selectedCurrency = 'USD';
  final TextEditingController _rateController =
      TextEditingController(text: '0.89560');

  final List<String> _pairs = [
    'EUR/USD',
    'GBP/USD',
    'USD/CHF',
    'USD/JPY',
    'AUD/USD'
  ];
  final List<String> _lotTypes = [
    '1.00 (Standard)',
    '0.10 (Mini)',
    '0.01 (Micro)',
  ];
  final List<String> _currencies = ['USD', 'EUR', 'GBP', 'CHF', 'JPY'];

  void _calculateAndNavigate() {
    final double exchangeRate = double.tryParse(_rateController.text) ?? 1.0;

    // Determine lot size units and label
    double lotMultiplier = 1.0;
    String lotLabel = 'Standard Lot (100,000 units)';
    int units = 100000;

    if (_selectedLotType.contains('0.10')) {
      lotMultiplier = 0.10;
      lotLabel = 'Mini Lot (10,000 units)';
      units = 10000;
    } else if (_selectedLotType.contains('0.01')) {
      lotMultiplier = 0.01;
      lotLabel = 'Micro Lot (1,000 units)';
      units = 1000;
    }

    final bool isJpy = _selectedPair.contains('JPY');
    final double pipSize = isJpy ? 0.01 : 0.0001;

    // Standard Pip Value Formula: (One Pip / Exchange Rate) * Units
    double pipVal =
        (pipSize / (exchangeRate == 0 ? 1.0 : exchangeRate)) * units;

    final result = PipValueResult(
      pipValue: pipVal,
      accountCurrency: _selectedCurrency,
      lotTypeLabel: lotLabel,
      pipSize: pipSize,
      contractSize: units,
    );

    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, animation, __) => FadeTransition(
          opacity: animation,
          child: PipValueResultScreen(result: result),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        title:
            Text('Pip Value Calculator', style: AppTypography.headlineMedium),
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
                      LabeledDropdownField(
                        label: 'Currency Pair',
                        value: _selectedPair,
                        options: _pairs,
                        onChanged: (v) => setState(() => _selectedPair = v!),
                      ),
                      const SizedBox(height: 16),
                      LabeledDropdownField(
                        label: 'Lot Size',
                        value: _selectedLotType,
                        options: _lotTypes,
                        onChanged: (v) => setState(() => _selectedLotType = v!),
                      ),
                      const SizedBox(height: 16),
                      LabeledDropdownField(
                        label: 'Account Currency',
                        value: _selectedCurrency,
                        options: _currencies,
                        onChanged: (v) =>
                            setState(() => _selectedCurrency = v!),
                      ),
                      const SizedBox(height: 16),
                      LabeledInputField(
                        label: 'Exchange Rate',
                        controller: _rateController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                      ),
                      const SizedBox(height: 24),
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
