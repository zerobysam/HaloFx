import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_gradient_button.dart';
import '../../../core/widgets/labeled_dropdown_field.dart';
import '../../../core/widgets/labeled_input_field.dart';
import '../models/drawdown_result.dart';
import 'drawdown_report_screen.dart';

class DrawdownCalculatorScreen extends StatefulWidget {
  const DrawdownCalculatorScreen({super.key});

  @override
  State<DrawdownCalculatorScreen> createState() =>
      _DrawdownCalculatorScreenState();
}

class _DrawdownCalculatorScreenState extends State<DrawdownCalculatorScreen> {
  final TextEditingController _peakController =
      TextEditingController(text: '12500.00');
  final TextEditingController _currentController =
      TextEditingController(text: '10000.00');
  final TextEditingController _drawdownPercentController =
      TextEditingController(text: '20');

  String _selectedCurrency = 'USD';
  String _selectedMarket = 'Forex';
  bool _isFavorite = false;

  double _quickDrawdown = 20.0;
  double _quickRecoveryNeeded = 25.0;

  final Map<String, String> _currencySymbols = {
    'USD': '\$',
    'EUR': '€',
    'GBP': '£',
    'JPY': '¥',
  };

  final List<String> _currencies = ['USD', 'EUR', 'GBP', 'JPY'];
  final List<String> _markets = ['Forex', 'Crypto', 'Stocks', 'Futures'];

  @override
  void initState() {
    super.initState();
    _peakController.addListener(_updateLivePreview);
    _currentController.addListener(_updateLivePreview);
    _drawdownPercentController.addListener(_updateFromPercent);
  }

  void _updateLivePreview() {
    final peak =
        double.tryParse(_peakController.text.replaceAll(',', '')) ?? 0.0;
    final current =
        double.tryParse(_currentController.text.replaceAll(',', '')) ?? 0.0;

    if (peak > 0 && current >= 0 && current <= peak) {
      final dd = ((peak - current) / peak) * 100;
      final recovery = dd > 0 ? (dd / (100 - dd)) * 100 : 0.0;
      setState(() {
        _quickDrawdown = dd;
        _quickRecoveryNeeded = recovery;
      });
    }
  }

  void _updateFromPercent() {
    if (!_drawdownPercentController.selection.isValid) return;
    final ddPercent = double.tryParse(_drawdownPercentController.text) ?? 0.0;
    final peak =
        double.tryParse(_peakController.text.replaceAll(',', '')) ?? 0.0;

    if (ddPercent >= 0 && ddPercent < 100 && peak > 0) {
      final calculatedCurrent = peak * (1 - (ddPercent / 100));
      final recovery =
          ddPercent > 0 ? (ddPercent / (100 - ddPercent)) * 100 : 0.0;

      _currentController.removeListener(_updateLivePreview);
      _currentController.text = calculatedCurrent.toStringAsFixed(2);
      _currentController.addListener(_updateLivePreview);

      setState(() {
        _quickDrawdown = ddPercent;
        _quickRecoveryNeeded = recovery;
      });
    }
  }

  void _resetAll() {
    setState(() {
      _peakController.text = '12500.00';
      _currentController.text = '10000.00';
      _drawdownPercentController.text = '20';
      _selectedCurrency = 'USD';
      _selectedMarket = 'Forex';
      _updateLivePreview();
    });
  }

  void _calculateAndNavigate() {
    final peak =
        double.tryParse(_peakController.text.replaceAll(',', '')) ?? 0.0;
    final current =
        double.tryParse(_currentController.text.replaceAll(',', '')) ?? 0.0;

    if (peak <= 0) return;

    final moneyLost = peak - current;
    final drawdownPercentage = (moneyLost / peak) * 100;
    final recoveryNeededPercentage = drawdownPercentage > 0
        ? (drawdownPercentage / (100 - drawdownPercentage)) * 100
        : 0.0;

    final result = DrawdownResult(
      peakBalance: peak,
      currentBalance: current,
      drawdownPercentage: drawdownPercentage,
      moneyLost: moneyLost,
      recoveryNeededPercentage: recoveryNeededPercentage,
      recoveryAmount: moneyLost,
      breakEvenBalance: peak,
      currency: _selectedCurrency,
      currencySymbol: _currencySymbols[_selectedCurrency] ?? '\$',
    );

    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 320),
        pageBuilder: (context, animation, secondaryAnimation) =>
            DrawdownReportScreen(result: result),
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
  void dispose() {
    _peakController.dispose();
    _currentController.dispose();
    _drawdownPercentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        title: Text('Drawdown Calculator', style: AppTypography.headlineMedium),
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
          IconButton(
            icon:
                const Icon(Icons.history_rounded, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Top Banner Widget
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.bgSecondary,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C5CE7).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.shield_outlined,
                        color: Color(0xFF8C7CFF),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        'Understand your drawdown and how much recovery is required to break even.',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Inputs Group
              LabeledInputField(
                label: 'Peak Balance',
                controller: _peakController,
                suffixUnit: _currencySymbols[_selectedCurrency],
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 14),
              LabeledInputField(
                label: 'Current Balance',
                controller: _currentController,
                suffixUnit: _currencySymbols[_selectedCurrency],
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 14),

              Row(
                children: [
                  const Expanded(child: Divider(color: AppColors.border)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text('or',
                        style: AppTypography.bodyMedium
                            .copyWith(color: AppColors.textTertiary)),
                  ),
                  const Expanded(child: Divider(color: AppColors.border)),
                ],
              ),
              const SizedBox(height: 14),

              LabeledInputField(
                label: 'Drawdown %',
                controller: _drawdownPercentController,
                suffixUnit: '%',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 14),

              LabeledDropdownField(
                label: 'Account Currency',
                value: _selectedCurrency,
                options: _currencies,
                onChanged: (v) => setState(() => _selectedCurrency = v!),
              ),
              const SizedBox(height: 14),

              LabeledDropdownField(
                label: 'Market (Optional)',
                value: _selectedMarket,
                options: _markets,
                onChanged: (v) => setState(() => _selectedMarket = v!),
              ),
              const SizedBox(height: 20),

              // Quick Preview Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
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
                        Text('Quick Preview',
                            style: AppTypography.headlineMedium
                                .copyWith(fontSize: 15)),
                        const SizedBox(width: 6),
                        const Icon(Icons.info_outline_rounded,
                            color: AppColors.textTertiary, size: 16),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Drawdown',
                                  style: AppTypography.bodyMedium.copyWith(
                                      color: AppColors.textSecondary,
                                      fontSize: 12)),
                              const SizedBox(height: 4),
                              Text(
                                '${_quickDrawdown.toStringAsFixed(0)}%',
                                style: AppTypography.headlineMedium.copyWith(
                                  color: const Color(0xFFFF4D4D),
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Recovery Needed',
                                  style: AppTypography.bodyMedium.copyWith(
                                      color: AppColors.textSecondary,
                                      fontSize: 12)),
                              const SizedBox(height: 4),
                              Text(
                                '${_quickRecoveryNeeded.toStringAsFixed(0)}%',
                                style: AppTypography.headlineMedium.copyWith(
                                  color: const Color(0xFFA855F7),
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Tap Calculate to view full report',
                      style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textTertiary, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Calculate Button
              AppGradientButton(
                onPressed: _calculateAndNavigate,
                label: 'Calculate',
              ),
              const SizedBox(height: 12),

              // Reset All Action
              TextButton.icon(
                onPressed: _resetAll,
                icon: const Icon(Icons.refresh_rounded,
                    color: AppColors.textSecondary, size: 18),
                label: Text(
                  'Reset All',
                  style: AppTypography.bodyMedium
                      .copyWith(color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
