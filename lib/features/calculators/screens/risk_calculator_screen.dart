import 'package:flutter/material.dart';
import '../../../core/navigation/tab_navigator.dart';
import '../../../core/state/accounts_store.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';
import '../../accounts/models/trading_account.dart';
import '../../history/screens/calculation_history_screen.dart';

class RiskCalculatorScreen extends StatefulWidget {
  const RiskCalculatorScreen({super.key});

  @override
  State<RiskCalculatorScreen> createState() => _RiskCalculatorScreenState();
}

class _RiskCalculatorScreenState extends State<RiskCalculatorScreen> {
  static const _tabs = ['Position Size', 'Risk %', 'Pip Value'];
  int _tabIndex = 0;

  late TradingAccount _account = AccountsStore.selectedAccount.value;
  String _pair = 'EUR/USD';
  static const _pairs = ['EUR/USD', 'GBP/USD', 'USD/JPY', 'XAU/USD'];

  final _entryController = TextEditingController(text: '1.08125');
  final _stopLossController = TextEditingController(text: '1.07825');
  final _riskPercentController = TextEditingController(text: '1.00');
  bool _editingByPercent = true; // true = risk % drives risk $, false = reverse

  static const double _pipValuePerStandardLot = 10.0;
  static const double _assumedRewardMultiple = 2.3;

  double get _entry => double.tryParse(_entryController.text) ?? 0;
  double get _stopLoss => double.tryParse(_stopLossController.text) ?? 0;
  double get _riskPercent => double.tryParse(_riskPercentController.text) ?? 0;
  double get _riskAmount => _account.balance * (_riskPercent / 100);

  double get _pipSize => _pair.contains('JPY') ? 0.01 : 0.0001;
  double get _pipRisk => _entry > 0 && _stopLoss > 0 ? ((_entry - _stopLoss).abs() / _pipSize) : 0;
  double get _lots {
    if (_pipRisk <= 0 || _riskAmount <= 0) return 0;
    return _riskAmount / (_pipRisk * _pipValuePerStandardLot);
  }

  double get _dollarPerPip => _lots * _pipValuePerStandardLot;
  double get _riskPerLot => _pipRisk * _pipValuePerStandardLot;

  String get _riskTier {
    if (_riskPercent <= 1.5) return 'low';
    if (_riskPercent <= 2.5) return 'moderate';
    return 'high';
  }

  @override
  void dispose() {
    _entryController.dispose();
    _stopLossController.dispose();
    _riskPercentController.dispose();
    super.dispose();
  }

  Future<void> _pickAccount() async {
    final selected = await showModalBottomSheet<TradingAccount>(
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
              ...AccountsStore.accounts.value.map((acc) => ListTile(
                    leading: Container(
                      width: 32, height: 32,
                      decoration: BoxDecoration(color: acc.badgeColor.withOpacity(0.15), shape: BoxShape.circle),
                      child: Icon(Icons.account_balance_wallet_rounded, color: acc.badgeColor, size: 16),
                    ),
                    title: Text(acc.name, style: AppTypography.bodyLarge),
                    subtitle: Text('Balance: \$${acc.balance.toStringAsFixed(2)}', style: AppTypography.bodySmall),
                    onTap: () => Navigator.of(context).pop(acc),
                  )),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
    if (selected != null) {
      setState(() => _account = selected);
      AccountsStore.select(selected);
    }
  }

  Future<void> _pickPair() async {
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
              ..._pairs.map((p) => ListTile(
                    title: Text(p, style: AppTypography.bodyLarge),
                    trailing: p == _pair ? const Icon(Icons.check_rounded, color: AppColors.primary) : null,
                    onTap: () => Navigator.of(context).pop(p),
                  )),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
    if (selected != null) setState(() => _pair = selected);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 20, 4),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
                  ),
                  Expanded(
                    child: Text('Risk Calculator', textAlign: TextAlign.center, style: AppTypography.headlineSmall.copyWith(fontSize: 18)),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const CalculationHistoryScreen()),
                    ),
                    icon: const Icon(Icons.history_rounded, color: AppColors.textSecondary, size: 22),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: AppColors.bgInput, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                child: Row(
                  children: List.generate(_tabs.length, (i) {
                    final isActive = i == _tabIndex;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _tabIndex = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: isActive ? AppColors.primary : Colors.transparent,
                            borderRadius: BorderRadius.circular(9),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            _tabs[i],
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 13,
                              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                              color: isActive ? Colors.white : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _tabIndex == 0 ? _buildPositionSizeTab() : _buildOtherTabPlaceholder(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 2,
        onTap: (i) => navigateToTab(context, i, 2),
      ),
    );
  }

  Widget _buildOtherTabPlaceholder() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.construction_rounded, color: AppColors.textTertiary, size: 32),
            const SizedBox(height: 10),
            Text('${_tabs[_tabIndex]} coming soon', style: AppTypography.bodyMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildPositionSizeTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _pickerCard(
          label: 'Account',
          leading: Container(
            width: 34, height: 34,
            decoration: BoxDecoration(color: _account.badgeColor.withOpacity(0.15), shape: BoxShape.circle),
            child: Icon(Icons.account_balance_wallet_rounded, color: _account.badgeColor, size: 17),
          ),
          title: _account.name,
          subtitle: 'Balance: \$${_account.balance.toStringAsFixed(2)}',
          onTap: _pickAccount,
        ),
        const SizedBox(height: 14),

        _pickerCard(
          label: 'Trading Pair',
          leading: Container(
            width: 34, height: 34,
            decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.15), shape: BoxShape.circle),
            child: const Icon(Icons.currency_exchange_rounded, color: AppColors.primaryLight, size: 16),
          ),
          title: _pair,
          trailingText: _entry > 0 ? _entry.toStringAsFixed(5) : '—',
          onTap: _pickPair,
        ),
        const SizedBox(height: 14),

        Row(
          children: [
            Expanded(child: _numberField(label: 'Entry Price', controller: _entryController, onChanged: (_) => setState(() {}))),
            const SizedBox(width: 12),
            Expanded(child: _numberField(label: 'Stop Loss', controller: _stopLossController, onChanged: (_) => setState(() {}))),
          ],
        ),
        const SizedBox(height: 14),

        Stack(
          clipBehavior: Clip.none,
          children: [
            Row(
              children: [
                Expanded(
                  child: _editingByPercent
                      ? _numberField(label: 'Risk Percentage', controller: _riskPercentController, suffix: '%', onChanged: (_) => setState(() {}))
                      : _readOnlyField(label: 'Risk Percentage', value: '${_riskPercent.toStringAsFixed(2)}%'),
                ),
                const SizedBox(width: 32),
                Expanded(
                  child: _readOnlyField(label: 'Risk Amount', value: '\$${_riskAmount.toStringAsFixed(2)}'),
                ),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 26,
              child: Center(
                child: GestureDetector(
                  onTap: () => setState(() => _editingByPercent = !_editingByPercent),
                  child: Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(color: AppColors.bgElevated, shape: BoxShape.circle, border: Border.all(color: AppColors.border)),
                    child: const Icon(Icons.swap_horiz_rounded, color: AppColors.primaryLight, size: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF241A47), Color(0xFF1A1430)]),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.primary.withOpacity(0.35)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Position Size', style: AppTypography.bodySmall.copyWith(fontSize: 13)),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(color: AppColors.bgElevated, shape: BoxShape.circle),
                    child: const Icon(Icons.copy_rounded, color: AppColors.textSecondary, size: 14),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(_lots.toStringAsFixed(2), style: AppTypography.numberLarge.copyWith(fontSize: 40)),
                  const SizedBox(width: 8),
                  Text('Lots', style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary)),
                ],
              ),
              const SizedBox(height: 16),
              Divider(color: AppColors.divider, height: 1),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(child: _resultStat('Pip Risk', _pipRisk.toStringAsFixed(1))),
                  Expanded(child: _resultStat('\$ per Pip', '\$${_dollarPerPip.toStringAsFixed(2)}')),
                  Expanded(child: _resultStat('Risk / Lot', '\$${_riskPerLot.toStringAsFixed(2)}')),
                  Expanded(child: _resultStat('RR Ratio', '1 : ${_assumedRewardMultiple.toStringAsFixed(1)}')),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        _buildRiskMeter(),
        const SizedBox(height: 16),

        _buildRiskTip(),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _pickerCard({required String label, required Widget leading, required String title, String? subtitle, String? trailingText, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: AppColors.bgInput, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
        child: Row(
          children: [
            leading,
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTypography.caption),
                  Text(title, style: AppTypography.bodyLarge.copyWith(fontSize: 14.5, fontWeight: FontWeight.w700)),
                  if (subtitle != null) Text(subtitle, style: AppTypography.bodySmall.copyWith(fontSize: 12)),
                ],
              ),
            ),
            if (trailingText != null) Text(trailingText, style: AppTypography.bodyMedium.copyWith(color: AppColors.success, fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }

  Widget _numberField({required String label, required TextEditingController controller, String? suffix, required ValueChanged<String> onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.caption),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(color: AppColors.bgInput, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  onChanged: onChanged,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: AppTypography.bodyLarge.copyWith(fontSize: 14.5, fontWeight: FontWeight.w600),
                  decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 12)),
                ),
              ),
              if (suffix != null) Text(suffix, style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _readOnlyField({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.caption),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(color: AppColors.bgInput, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Text(value, style: AppTypography.bodyLarge.copyWith(fontSize: 14.5, fontWeight: FontWeight.w700, color: AppColors.success)),
        ),
      ],
    );
  }

  Widget _resultStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.caption),
        const SizedBox(height: 3),
        Text(value, style: AppTypography.bodyMedium.copyWith(fontSize: 13, fontWeight: FontWeight.w700)),
      ],
    );
  }

  Widget _buildRiskMeter() {
    final fraction = (_riskPercent / 3.0).clamp(0.0, 1.0);
    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final barWidth = constraints.maxWidth;
            final pointerX = (fraction * barWidth).clamp(16.0, barWidth - 16.0);
            return SizedBox(
              height: 46,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: 20,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        gradient: const LinearGradient(colors: [AppColors.success, Color(0xFFF5C542), AppColors.danger]),
                      ),
                    ),
                  ),
                  Positioned(
                    left: pointerX - 22,
                    top: -6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
                      child: Text('${_riskPercent.toStringAsFixed(2)}%', style: AppTypography.caption.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Low Risk', style: AppTypography.caption.copyWith(color: AppColors.success, fontWeight: FontWeight.w600)),
            Text('Moderate', style: AppTypography.caption.copyWith(color: const Color(0xFFF5C542), fontWeight: FontWeight.w600)),
            Text('High Risk', style: AppTypography.caption.copyWith(color: AppColors.danger, fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }

  Widget _buildRiskTip() {
    final tier = _riskTier;
    final color = tier == 'low' ? AppColors.success : (tier == 'moderate' ? const Color(0xFFF5C542) : AppColors.danger);
    final icon = tier == 'low' ? Icons.verified_user_rounded : (tier == 'moderate' ? Icons.info_rounded : Icons.warning_rounded);
    final title = tier == 'low' ? 'Good risk level' : (tier == 'moderate' ? 'Moderate risk level' : 'High risk level');
    final message = tier == 'low'
        ? 'You\'re risking ${_riskPercent.toStringAsFixed(2)}% of your account. Keep your risk consistent to stay profitable.'
        : (tier == 'moderate'
            ? 'You\'re risking ${_riskPercent.toStringAsFixed(2)}% of your account. Consider reducing this for more consistent results.'
            : 'You\'re risking ${_riskPercent.toStringAsFixed(2)}% of your account — well above typical guidance of 1-2% per trade.');

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(14), border: Border.all(color: color.withOpacity(0.3))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(color: color.withOpacity(0.15), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w700, fontSize: 14, color: color)),
                const SizedBox(height: 3),
                Text(message, style: AppTypography.bodySmall.copyWith(fontSize: 12.5, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
