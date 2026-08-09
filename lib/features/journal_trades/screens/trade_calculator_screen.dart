import 'package:flutter/material.dart';
import '../../../core/state/accounts_store.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/labeled_dropdown_field.dart';
import '../../../core/widgets/labeled_input_field.dart';
import '../../accounts/models/trading_account.dart';
import '../widgets/journal_bottom_nav.dart';
import 'trade_calculator_result_screen.dart';

class TradeCalculatorScreen extends StatefulWidget {
  const TradeCalculatorScreen({super.key});

  @override
  State<TradeCalculatorScreen> createState() => _TradeCalculatorScreenState();
}

class _TradeCalculatorScreenState extends State<TradeCalculatorScreen> {
  late TradingAccount _account = AccountsStore.selectedAccount.value;
  double _accountRisk = 0.75;

  String _market = 'Forex';
  String _symbol = 'EUR/USD';
  final _stopLossController = TextEditingController(text: '25');

  Future<void> _changeRisk() async {
    final controller = TextEditingController(text: _accountRisk.toString());
    final result = await showModalBottomSheet<double>(
      context: context,
      backgroundColor: AppColors.bgElevated,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(context).padding.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Account Risk', style: AppTypography.headlineSmall.copyWith(fontSize: 16)),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(color: AppColors.bgInput, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: TextField(
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w700),
                  decoration: const InputDecoration(border: InputBorder.none, suffixText: '%', isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 14)),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(double.tryParse(controller.text)),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: Text('Update', style: AppTypography.buttonText),
                ),
              ),
            ],
          ),
        );
      },
    );
    if (result != null && result > 0) setState(() => _accountRisk = result);
  }

  void _calculate() {
    final stopLossPips = double.tryParse(_stopLossController.text) ?? 0;
    if (stopLossPips <= 0) return;

    const pipValuePerStandardLot = 10.0;
    final riskAmount = _account.balance * (_accountRisk / 100);
    final lots = riskAmount / (stopLossPips * pipValuePerStandardLot);
    final assumedPrice = _symbol == 'XAU/USD' ? 2345.60 : 1.15;
    final positionValue = lots * 100000 * assumedPrice;
    final marginRequired = positionValue / 30; // assumed 30x leverage
    final potentialProfit = riskAmount * 2.5;

    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 320),
        pageBuilder: (context, animation, __) => TradeCalculatorResultScreen(
          account: _account,
          symbol: _symbol,
          lots: lots,
          riskAmount: riskAmount,
          potentialProfit: potentialProfit,
          potentialLoss: riskAmount,
          marginRequired: marginRequired,
          accountRiskPercent: _accountRisk,
        ),
        transitionsBuilder: (context, animation, __, child) {
          final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
          return SlideTransition(position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(curved), child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _stopLossController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.menu_rounded, color: AppColors.textPrimary, size: 22),
                      const SizedBox(width: 12),
                      Text('Position Size', style: AppTypography.headlineSmall.copyWith(fontSize: 17)),
                    ],
                  ),
                  const Icon(Icons.settings_outlined, color: AppColors.textSecondary, size: 20),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text('Account', style: AppTypography.caption),
                    const SizedBox(height: 4),
                    Text(_account.name, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w700, fontSize: 16)),
                    const SizedBox(height: 14),

                    Text('Current Balance', style: AppTypography.caption),
                    const SizedBox(height: 4),
                    Text('\$${_account.balance.toStringAsFixed(2)}', style: AppTypography.numberLarge.copyWith(fontSize: 26)),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Account Risk', style: AppTypography.caption),
                            const SizedBox(height: 4),
                            Text('${_accountRisk.toStringAsFixed(2)}%', style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w700, fontSize: 18)),
                          ],
                        ),
                        OutlinedButton(
                          onPressed: _changeRisk,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.primary),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Text('Change', style: AppTypography.bodySmall.copyWith(color: AppColors.primaryLight, fontWeight: FontWeight.w700, fontSize: 12.5)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),

                    Text('Trade Setup', style: AppTypography.headlineSmall.copyWith(fontSize: 15)),
                    const SizedBox(height: 12),
                    LabeledDropdownField(label: 'Market', value: _market, options: const ['Forex', 'Crypto', 'Futures', 'Stocks'], onChanged: (v) => setState(() => _market = v)),
                    const SizedBox(height: 14),
                    LabeledDropdownField(label: 'Symbol', value: _symbol, options: const ['EUR/USD', 'GBP/USD', 'USD/JPY', 'XAU/USD'], onChanged: (v) => setState(() => _symbol = v)),
                    const SizedBox(height: 14),
                    LabeledInputField(label: 'Stop Loss', controller: _stopLossController, suffixUnit: 'Pips'),
                    const SizedBox(height: 14),
                    _readOnlyRow('Account Risk', '${_accountRisk.toStringAsFixed(2)}%'),
                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _calculate,
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                        child: Text('Calculate', style: AppTypography.buttonText),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const JournalBottomNav(current: JournalTab.calculator),
    );
  }

  Widget _readOnlyRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.caption),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(color: AppColors.bgInput, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Text(value, style: AppTypography.bodyLarge.copyWith(fontSize: 14.5, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}
