import 'package:flutter/material.dart';
import '../../../core/state/trade_journal_store.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/labeled_dropdown_field.dart';
import '../../../core/widgets/labeled_input_field.dart';
import '../models/trade.dart';
import 'trade_details_screen.dart';

class ManualTradeEntryScreen extends StatefulWidget {
  const ManualTradeEntryScreen({super.key});

  @override
  State<ManualTradeEntryScreen> createState() => _ManualTradeEntryScreenState();
}

class _ManualTradeEntryScreenState extends State<ManualTradeEntryScreen> {
  String _market = 'Forex';
  String _symbol = 'EUR/USD';
  TradeDirection _direction = TradeDirection.buy;

  final _entryController = TextEditingController(text: '1.17240');
  final _exitController = TextEditingController(text: '1.17490');
  final _stopLossController = TextEditingController(text: '1.17000');
  final _takeProfitController = TextEditingController(text: '1.17700');
  final _lotSizeController = TextEditingController(text: '0.40');
  final _feesController = TextEditingController(text: '2.10');
  final _notesController = TextEditingController(text: 'London breakout trade.');

  double _parse(String s) => double.tryParse(s.replaceAll(',', '')) ?? 0;

  void _saveTrade() {
    final entry = _parse(_entryController.text);
    final exit = _parse(_exitController.text);
    final lotSize = _parse(_lotSizeController.text);
    if (entry <= 0 || exit <= 0 || lotSize <= 0) return;

    final priceDiff = _direction == TradeDirection.buy ? (exit - entry) : (entry - exit);
    final pipValuePerLot = _market == 'Crypto' ? 1.0 : 10000.0; // simplified: forex pip-scaled, crypto raw
    final profit = _market == 'Crypto' ? priceDiff * lotSize : priceDiff * pipValuePerLot * lotSize * 0.1;
    final stopLoss = _parse(_stopLossController.text);
    final riskDistance = stopLoss > 0 ? (entry - stopLoss).abs() : 0;
    final profitR = riskDistance > 0 ? (exit - entry).abs() / riskDistance * (profit >= 0 ? 1 : -1) : 0.0;

    final trade = Trade(
      id: 'manual_${DateTime.now().millisecondsSinceEpoch}',
      symbol: _symbol,
      market: _market,
      direction: _direction,
      status: TradeStatus.closed,
      entryPrice: entry,
      exitPrice: exit,
      lotSize: lotSize,
      stopLoss: stopLoss > 0 ? stopLoss : null,
      takeProfit: _parse(_takeProfitController.text) > 0 ? _parse(_takeProfitController.text) : null,
      profit: profit,
      profitR: profitR,
      date: DateTime.now(),
      duration: const Duration(minutes: 0),
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
    );

    TradeJournalStore.addTrade(trade);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => TradeDetailsScreen(trade: trade)),
    );
  }

  @override
  void dispose() {
    _entryController.dispose();
    _exitController.dispose();
    _stopLossController.dispose();
    _takeProfitController.dispose();
    _lotSizeController.dispose();
    _feesController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: Padding(
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
                      Text('Manual Entry', style: AppTypography.headlineSmall.copyWith(fontSize: 18)),
                    ],
                  ),
                  TextButton(
                    onPressed: _saveTrade,
                    child: Text('Save', style: AppTypography.linkBold.copyWith(fontSize: 15)),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: LabeledDropdownField(
                              label: 'Market',
                              value: _market,
                              options: const ['Forex', 'Crypto', 'Futures', 'Stocks', 'Commodities'],
                              onChanged: (v) => setState(() => _market = v),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: LabeledDropdownField(
                              label: 'Symbol',
                              value: _symbol,
                              options: const ['EUR/USD', 'GBP/USD', 'BTC/USDT', 'XAU/USD'],
                              onChanged: (v) => setState(() => _symbol = v),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      Text('Direction', style: AppTypography.bodySmall.copyWith(fontSize: 13)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(child: _directionButton('Buy', TradeDirection.buy)),
                          const SizedBox(width: 10),
                          Expanded(child: _directionButton('Sell', TradeDirection.sell)),
                        ],
                      ),
                      const SizedBox(height: 16),

                      LabeledInputField(label: 'Entry Price', controller: _entryController),
                      const SizedBox(height: 14),
                      LabeledInputField(label: 'Exit Price', controller: _exitController),
                      const SizedBox(height: 14),
                      LabeledInputField(label: 'Stop Loss', controller: _stopLossController),
                      const SizedBox(height: 14),
                      LabeledInputField(label: 'Take Profit', controller: _takeProfitController),
                      const SizedBox(height: 14),
                      LabeledInputField(label: 'Lot Size', controller: _lotSizeController),
                      const SizedBox(height: 14),
                      LabeledInputField(label: 'Fees', controller: _feesController, suffixUnit: 'USD'),
                      const SizedBox(height: 16),

                      Text('Notes', style: AppTypography.bodySmall.copyWith(fontSize: 13)),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(color: AppColors.bgInput, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                        child: TextField(
                          controller: _notesController,
                          maxLines: 3,
                          style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
                          decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 12)),
                        ),
                      ),
                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _saveTrade,
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                          child: Text('Save Trade', style: AppTypography.buttonText),
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
      ),
    );
  }

  Widget _directionButton(String label, TradeDirection value) {
    final isSelected = _direction == value;
    final color = value == TradeDirection.buy ? AppColors.success : AppColors.danger;
    return GestureDetector(
      onTap: () => setState(() => _direction = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.15) : AppColors.bgInput,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isSelected ? color : AppColors.border),
        ),
        alignment: Alignment.center,
        child: Text(label, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w700, color: isSelected ? color : AppColors.textSecondary)),
      ),
    );
  }
}
