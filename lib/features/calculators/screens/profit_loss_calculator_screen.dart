import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_gradient_button.dart';
import '../../../core/widgets/labeled_dropdown_field.dart';
import '../../../core/widgets/labeled_input_field.dart';
import '../models/profit_loss_result.dart';
import 'profit_loss_report_screen.dart';

class ProfitLossCalculatorScreen extends StatefulWidget {
  const ProfitLossCalculatorScreen({super.key});

  @override
  State<ProfitLossCalculatorScreen> createState() =>
      _ProfitLossCalculatorScreenState();
}

class _ProfitLossCalculatorScreenState
    extends State<ProfitLossCalculatorScreen> {
  String _selectedMarket = 'Forex';
  String _selectedPair = 'EUR/USD';
  String _direction = 'Long'; // 'Long' or 'Short'

  final TextEditingController _entryController =
      TextEditingController(text: '1.08500');
  final TextEditingController _exitController =
      TextEditingController(text: '1.09250');
  final TextEditingController _lotSizeController =
      TextEditingController(text: '0.50');
  final TextEditingController _commissionController =
      TextEditingController(text: '3.00');
  final TextEditingController _swapController =
      TextEditingController(text: '0.00');

  bool _isFavorite = false;
  double _previewNetProfit = 372.00;
  double _previewPips = 75.0;

  final List<String> _markets = ['Forex', 'Crypto', 'Stocks', 'Futures'];
  final List<String> _pairs = ['EUR/USD', 'GBP/USD', 'XAU/USD', 'BTC/USD'];

  @override
  void initState() {
    super.initState();
    _entryController.addListener(_calculatePreview);
    _exitController.addListener(_calculatePreview);
    _lotSizeController.addListener(_calculatePreview);
    _commissionController.addListener(_calculatePreview);
    _swapController.addListener(_calculatePreview);
  }

  void _calculatePreview() {
    final entry = double.tryParse(_entryController.text) ?? 0.0;
    final exit = double.tryParse(_exitController.text) ?? 0.0;
    final lot = double.tryParse(_lotSizeController.text) ?? 0.0;
    final commission = double.tryParse(_commissionController.text) ?? 0.0;
    final swap = double.tryParse(_swapController.text) ?? 0.0;

    if (entry <= 0 || exit <= 0 || lot <= 0) return;

    final multiplier = _selectedPair.startsWith('XAU') ? 10.0 : 10000.0;
    final priceDiff = _direction == 'Long' ? (exit - entry) : (entry - exit);
    final pips = priceDiff * multiplier;

    const contractSize = 100000.0;
    final gross = priceDiff * lot * contractSize;
    final net = gross - commission - swap;

    setState(() {
      _previewPips = pips;
      _previewNetProfit = net;
    });
  }

  void _resetAll() {
    setState(() {
      _selectedMarket = 'Forex';
      _selectedPair = 'EUR/USD';
      _direction = 'Long';
      _entryController.text = '1.08500';
      _exitController.text = '1.09250';
      _lotSizeController.text = '0.50';
      _commissionController.text = '3.00';
      _swapController.text = '0.00';
      _calculatePreview();
    });
  }

  void _calculateAndNavigate() {
    final entry = double.tryParse(_entryController.text) ?? 0.0;
    final exit = double.tryParse(_exitController.text) ?? 0.0;
    final lot = double.tryParse(_lotSizeController.text) ?? 0.0;
    final commission = double.tryParse(_commissionController.text) ?? 0.0;
    final swap = double.tryParse(_swapController.text) ?? 0.0;

    final multiplier = _selectedPair.startsWith('XAU') ? 10.0 : 10000.0;
    final priceDiff = _direction == 'Long' ? (exit - entry) : (entry - exit);
    final pips = priceDiff * multiplier;

    const contractSize = 100000.0;
    final gross = priceDiff * lot * contractSize;
    final net = gross - commission - swap;

    final baseAccountValue = entry * lot * contractSize;
    final roi = baseAccountValue > 0 ? (net / baseAccountValue) * 100 : 0.0;

    final result = ProfitLossResult(
      grossProfit: gross,
      netProfit: net,
      commission: commission,
      swap: swap,
      pips: pips,
      roi: roi,
      entryPrice: entry,
      exitPrice: exit,
      lotSize: lot,
      direction: _direction,
      accountCurrency: 'USD',
    );

    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 320),
        pageBuilder: (context, animation, secondaryAnimation) =>
            ProfitLossReportScreen(result: result),
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
    _entryController.dispose();
    _exitController.dispose();
    _lotSizeController.dispose();
    _commissionController.dispose();
    _swapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPositive = _previewNetProfit >= 0;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        title: Text(
          'Profit & Loss Calculator',
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
              // Header Card
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
                        Icons.calculate_outlined,
                        color: Color(0xFF8C7CFF),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        'Calculate your trade result including pips, ROI and all costs.',
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

              // Inputs
              LabeledDropdownField(
                label: 'Market',
                value: _selectedMarket,
                options: _markets,
                onChanged: (v) => setState(() => _selectedMarket = v!),
              ),
              const SizedBox(height: 14),
              LabeledDropdownField(
                label: 'Currency Pair',
                value: _selectedPair,
                options: _pairs,
                onChanged: (v) => setState(() => _selectedPair = v!),
              ),
              const SizedBox(height: 14),

              // Direction Toggle
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Direction', style: AppTypography.bodyMedium),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() => _direction = 'Long');
                            _calculatePreview();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _direction == 'Long'
                                  ? const Color(0xFF00E676).withOpacity(0.12)
                                  : AppColors.bgInput,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: _direction == 'Long'
                                    ? const Color(0xFF00E676)
                                    : AppColors.border,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.north_east_rounded,
                                    size: 16,
                                    color: _direction == 'Long'
                                        ? const Color(0xFF00E676)
                                        : AppColors.textSecondary),
                                const SizedBox(width: 6),
                                Text(
                                  'Long',
                                  style: TextStyle(
                                    color: _direction == 'Long'
                                        ? const Color(0xFF00E676)
                                        : AppColors.textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() => _direction = 'Short');
                            _calculatePreview();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _direction == 'Short'
                                  ? const Color(0xFFFF4D4D).withOpacity(0.12)
                                  : AppColors.bgInput,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: _direction == 'Short'
                                    ? const Color(0xFFFF4D4D)
                                    : AppColors.border,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.south_east_rounded,
                                    size: 16,
                                    color: _direction == 'Short'
                                        ? const Color(0xFFFF4D4D)
                                        : AppColors.textSecondary),
                                const SizedBox(width: 6),
                                Text(
                                  'Short',
                                  style: TextStyle(
                                    color: _direction == 'Short'
                                        ? const Color(0xFFFF4D4D)
                                        : AppColors.textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),

              LabeledInputField(
                label: 'Entry Price',
                controller: _entryController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 14),
              LabeledInputField(
                label: 'Exit Price',
                controller: _exitController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 14),
              LabeledInputField(
                label: 'Lot Size',
                controller: _lotSizeController,
                suffixUnit: 'Lots',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 14),
              LabeledInputField(
                label: 'Commission',
                controller: _commissionController,
                suffixUnit: 'USD',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 14),
              LabeledInputField(
                label: 'Swap',
                controller: _swapController,
                suffixUnit: 'USD',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 20),

              // Quick Preview
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
                    const SizedBox(height: 12),
                    Text('Estimated Profit',
                        style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary, fontSize: 12)),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${isPositive ? '+' : ''}\$${_previewNetProfit.toStringAsFixed(2)}',
                          style: AppTypography.headlineMedium.copyWith(
                            color: isPositive
                                ? const Color(0xFF00E676)
                                : const Color(0xFFFF4D4D),
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${_previewPips >= 0 ? '+' : ''}${_previewPips.toStringAsFixed(0)} Pips',
                          style: AppTypography.bodyMedium.copyWith(
                            color: const Color(0xFF00E676),
                            fontWeight: FontWeight.w600,
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

              AppGradientButton(
                onPressed: _calculateAndNavigate,
                label: 'Calculator',
              ),
              const SizedBox(height: 12),

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
