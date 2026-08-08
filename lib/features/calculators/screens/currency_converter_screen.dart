import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/ad_banner.dart';
import '../../../core/widgets/subscribe_screen.dart';

class _CurrencyMeta {
  final String code;
  final String name;
  final String flag;
  final Color flagBg;

  const _CurrencyMeta({
    required this.code,
    required this.name,
    required this.flag,
    required this.flagBg,
  });
}

const Map<String, _CurrencyMeta> _currencyMeta = {
  'USD': _CurrencyMeta(code: 'USD', name: 'US Dollar', flag: '🇺🇸', flagBg: Color(0xFF2C3E91)),
  'EUR': _CurrencyMeta(code: 'EUR', name: 'Euro', flag: '🇪🇺', flagBg: Color(0xFF1F5FBF)),
  'GBP': _CurrencyMeta(code: 'GBP', name: 'British Pound', flag: '🇬🇧', flagBg: Color(0xFF7A1F3D)),
  'JPY': _CurrencyMeta(code: 'JPY', name: 'Japanese Yen', flag: '🇯🇵', flagBg: Color(0xFFB91C1C)),
};

/// Simplified static exchange rates (USD base) for demo purposes.
/// Swap in a real FX rate API/service later.
const Map<String, double> _usdRates = {
  'USD': 1.0,
  'EUR': 0.9157,
  'GBP': 0.7841,
  'JPY': 155.32,
};

class CurrencyConverterScreen extends StatefulWidget {
  const CurrencyConverterScreen({super.key});

  @override
  State<CurrencyConverterScreen> createState() => _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen>
    with SingleTickerProviderStateMixin {
  final _amountController = TextEditingController(text: '1,000');
  String _fromCurrency = 'USD';
  String _toCurrency = 'EUR';

  late final AnimationController _swapController;

  @override
  void initState() {
    super.initState();
    _swapController = AnimationController(vsync: this, duration: const Duration(milliseconds: 320));
  }

  @override
  void dispose() {
    _amountController.dispose();
    _swapController.dispose();
    super.dispose();
  }

  double get _amount => double.tryParse(_amountController.text.replaceAll(',', '')) ?? 0;

  double get _convertedAmount {
    final fromRate = _usdRates[_fromCurrency] ?? 1;
    final toRate = _usdRates[_toCurrency] ?? 1;
    return _amount / fromRate * toRate;
  }

  double get _rate {
    final fromRate = _usdRates[_fromCurrency] ?? 1;
    final toRate = _usdRates[_toCurrency] ?? 1;
    return toRate / fromRate;
  }

  void _swap() {
    _swapController.forward(from: 0);
    setState(() {
      final temp = _fromCurrency;
      _fromCurrency = _toCurrency;
      _toCurrency = temp;
    });
  }

  Future<void> _pickCurrency(bool isFrom) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.bgElevated,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(width: 36, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 8),
              ..._currencyMeta.values.map((meta) => ListTile(
                    leading: _FlagBadge(meta: meta, size: 28),
                    title: Text('${meta.code} - ${meta.name}', style: AppTypography.bodyLarge),
                    onTap: () => Navigator.of(context).pop(meta.code),
                  )),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
    if (selected == null) return;
    setState(() {
      if (isFrom) {
        _fromCurrency = selected;
      } else {
        _toCurrency = selected;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final fromMeta = _currencyMeta[_fromCurrency]!;
    final toMeta = _currencyMeta[_toCurrency]!;

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
                  Text('Currency Converter', style: AppTypography.headlineSmall),
                ],
              ),
              const SizedBox(height: 20),

              Text('From', style: AppTypography.bodySmall.copyWith(fontSize: 13)),
              const SizedBox(height: 8),
              _CurrencyCard(
                meta: fromMeta,
                onTapCurrency: () => _pickCurrency(true),
                editable: true,
                controller: _amountController,
                onChanged: (_) => setState(() {}),
              ),

              SizedBox(
                height: 4,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      top: -22,
                      child: Center(
                        child: GestureDetector(
                          onTap: _swap,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.bgElevated,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.border, width: 1.5),
                            ),
                            child: AnimatedBuilder(
                              animation: _swapController,
                              builder: (context, child) => Transform.rotate(
                                angle: _swapController.value * 3.1416,
                                child: child,
                              ),
                              child: const Icon(Icons.swap_vert_rounded, color: AppColors.primaryLight, size: 20),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 26),

              Text('To', style: AppTypography.bodySmall.copyWith(fontSize: 13)),
              const SizedBox(height: 8),
              _CurrencyCard(
                meta: toMeta,
                onTapCurrency: () => _pickCurrency(false),
                editable: false,
                displayValue: _formatNumber(_convertedAmount),
              ),

              const SizedBox(height: 20),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: Container(
                  key: ValueKey('${_amountController.text}-$_fromCurrency-$_toCurrency'),
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.bgElevated,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${_formatNumber(_amount)} $_fromCurrency =', style: AppTypography.bodySmall.copyWith(fontSize: 13)),
                      const SizedBox(height: 6),
                      Text(
                        '${_formatNumber(_convertedAmount)} $_toCurrency',
                        style: AppTypography.numberLarge.copyWith(color: AppColors.success, fontSize: 28),
                      ),
                      const SizedBox(height: 6),
                      Text('Rate: 1 $_fromCurrency = ${_rate.toStringAsFixed(4)} $_toCurrency',
                          style: AppTypography.bodySmall.copyWith(fontSize: 12.5)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text('Convert', style: AppTypography.buttonText),
                ),
              ),

              AdBanner(
                onUpgradeTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SubscribeScreen()),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  String _formatNumber(double value) {
    final parts = value.toStringAsFixed(2).split('.');
    final intPart = parts[0].replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',');
    return '$intPart.${parts[1]}';
  }
}

class _FlagBadge extends StatelessWidget {
  final _CurrencyMeta meta;
  final double size;

  const _FlagBadge({required this.meta, this.size = 22});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: meta.flagBg, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(meta.flag, style: TextStyle(fontSize: size * 0.55)),
    );
  }
}

class _CurrencyCard extends StatelessWidget {
  final _CurrencyMeta meta;
  final VoidCallback onTapCurrency;
  final bool editable;
  final TextEditingController? controller;
  final String? displayValue;
  final ValueChanged<String>? onChanged;

  const _CurrencyCard({
    required this.meta,
    required this.onTapCurrency,
    required this.editable,
    this.controller,
    this.displayValue,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgElevated,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onTapCurrency,
            child: Row(
              children: [
                _FlagBadge(meta: meta),
                const SizedBox(width: 8),
                Text('${meta.code} - ${meta.name}', style: AppTypography.bodySmall.copyWith(fontSize: 13)),
                const SizedBox(width: 4),
                const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textTertiary, size: 16),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: editable
                    ? TextField(
                        controller: controller,
                        onChanged: onChanged,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        style: AppTypography.numberMedium.copyWith(fontSize: 22),
                        decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
                      )
                    : Text(displayValue ?? '', style: AppTypography.numberMedium.copyWith(fontSize: 22)),
              ),
              Text(meta.code, style: AppTypography.bodySmall.copyWith(fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }
}
