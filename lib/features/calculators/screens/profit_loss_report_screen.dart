import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/auth/access_control.dart';
import '../../../core/state/calculation_history_store.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../history/models/calculation_history_entry.dart';
import '../../journal/screens/save_setup_screen.dart';
import '../models/profit_loss_result.dart';

class ProfitLossReportScreen extends StatelessWidget {
  final ProfitLossResult result;

  const ProfitLossReportScreen({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    );

    final isPositive = result.isProfit;
    final themeColor =
        isPositive ? const Color(0xFF00E676) : const Color(0xFFFF4D4D);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        title:
            Text('Profit & Loss Report', style: AppTypography.headlineMedium),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share_rounded,
                color: AppColors.textPrimary),
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
                child: Column(
                  children: [
                    // Trade Result Banner
                    Container(
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Trade Result',
                                  style: AppTypography.bodyMedium.copyWith(
                                      color: AppColors.textSecondary)),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: themeColor.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  isPositive ? 'Profit' : 'Loss',
                                  style: TextStyle(
                                    color: themeColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${isPositive ? '+' : ''}${currencyFormat.format(result.netProfit)}',
                            style: AppTypography.headlineMedium.copyWith(
                              color: themeColor,
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: 1.0,
                              minHeight: 6,
                              backgroundColor: AppColors.bgElevated,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(themeColor),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              result.performanceLabel,
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Metrics Grid (6 items)
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.55,
                      children: [
                        _buildMetricCard(
                          label: 'Gross Profit',
                          value:
                              '${result.grossProfit >= 0 ? '+' : ''}${currencyFormat.format(result.grossProfit)}',
                          icon: Icons.north_east_rounded,
                          iconColor: const Color(0xFF00E676),
                        ),
                        _buildMetricCard(
                          label: 'Commission',
                          value: '-${currencyFormat.format(result.commission)}',
                          icon: Icons.file_download_outlined,
                          iconColor: const Color(0xFFFF4D4D),
                        ),
                        _buildMetricCard(
                          label: 'Swap',
                          value: currencyFormat.format(result.swap),
                          icon: Icons.sync_rounded,
                          iconColor: const Color(0xFFA855F7),
                        ),
                        _buildMetricCard(
                          label: 'Net Profit',
                          value:
                              '${result.netProfit >= 0 ? '+' : ''}${currencyFormat.format(result.netProfit)}',
                          icon: Icons.north_east_rounded,
                          iconColor: const Color(0xFF00E676),
                        ),
                        _buildMetricCard(
                          label: 'Pips',
                          value:
                              '${result.pips >= 0 ? '+' : ''}${result.pips.toStringAsFixed(0)}',
                          icon: Icons.show_chart_rounded,
                          iconColor: const Color(0xFFA855F7),
                        ),
                        _buildMetricCard(
                          label: 'ROI',
                          value:
                              '${result.roi >= 0 ? '+' : ''}${result.roi.toStringAsFixed(2)}%',
                          icon: Icons.percent_rounded,
                          iconColor: const Color(0xFFA855F7),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Trade Details Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.bgSecondary,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildDetailSubItem('Entry Price',
                                    result.entryPrice.toStringAsFixed(5)),
                              ),
                              const Icon(Icons.arrow_forward_rounded,
                                  color: AppColors.textTertiary, size: 20),
                              Expanded(
                                child: _buildDetailSubItem('Exit Price',
                                    result.exitPrice.toStringAsFixed(5),
                                    crossAxis: CrossAxisAlignment.end),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          const Divider(color: AppColors.border, height: 1),
                          const SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildDetailSubItem('Position Size',
                                  '${result.lotSize.toStringAsFixed(2)} Lots'),
                              _buildDetailSubItem('Direction', result.direction,
                                  valueColor: result.direction == 'Long'
                                      ? const Color(0xFF00E676)
                                      : const Color(0xFFFF4D4D),
                                  crossAxis: CrossAxisAlignment.end),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildDetailSubItem('Risk Reward', '1 : 3'),
                              _buildDetailSubItem(
                                  'Account Currency', result.accountCurrency,
                                  crossAxis: CrossAxisAlignment.end),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // AI Insight Card
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
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFA855F7).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.psychology_outlined,
                              color: Color(0xFFA855F7),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('AI Insight',
                                    style: AppTypography.headlineMedium
                                        .copyWith(fontSize: 14)),
                                const SizedBox(height: 4),
                                Text(
                                  'Great job! Your trade followed your plan and achieved a solid reward relative to the risk taken.',
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              const SizedBox(
                                width: 44,
                                height: 44,
                                child: CircularProgressIndicator(
                                  value: 0.94,
                                  strokeWidth: 4,
                                  backgroundColor: AppColors.bgElevated,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF00E676),
                                  ),
                                ),
                              ),
                              Text(
                                '94%\nConf',
                                textAlign: TextAlign.center,
                                style: AppTypography.bodyMedium.copyWith(
                                    fontSize: 9,
                                    color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Sponsored Card
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
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text('XM',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Sponsored',
                                    style: AppTypography.bodyMedium.copyWith(
                                        color: AppColors.textTertiary,
                                        fontSize: 10)),
                                Text('Trade with low fees.',
                                    style: AppTypography.headlineMedium
                                        .copyWith(fontSize: 13)),
                                Text('Get better conditions.',
                                    style: AppTypography.bodyMedium.copyWith(
                                        color: AppColors.textSecondary,
                                        fontSize: 11)),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6C5CE7),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Open Account',
                                style: TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Actions Bar
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: const BoxDecoration(
                color: AppColors.bgSecondary,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildBottomAction(
                      Icons.bookmark_border_rounded, 'Save Report', () async {
                    final allowed = await ensureLoggedIn(context, featureName: 'Saved Calculations');
                    if (!allowed) return;
                    CalculationHistoryStore.record(CalculationHistoryEntry(
                      calculatorTitle: 'Profit & Loss',
                      resultSummary: '\$${result.netProfit.toStringAsFixed(2)} net',
                      icon: Icons.show_chart_rounded,
                      timestamp: DateTime.now(),
                    ));
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SaveSetupScreen(initialName: 'Profit & Loss Report')),
                    );
                  }),
                  _buildBottomAction(Icons.copy_rounded, 'Copy', () {}),
                  _buildBottomAction(Icons.share_outlined, 'Share', () {}),
                  _buildBottomAction(
                      Icons.note_alt_outlined, 'Open Notes', () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String label,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 6),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    value,
                    style: AppTypography.headlineMedium.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Icon(icon, color: iconColor, size: 18),
        ],
      ),
    );
  }

  Widget _buildDetailSubItem(String label, String value,
      {Color? valueColor,
      CrossAxisAlignment crossAxis = CrossAxisAlignment.start}) {
    return Column(
      crossAxisAlignment: crossAxis,
      children: [
        Text(label,
            style: AppTypography.bodyMedium
                .copyWith(color: AppColors.textTertiary, fontSize: 11)),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTypography.headlineMedium.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomAction(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.textPrimary, size: 20),
            const SizedBox(height: 4),
            Text(label,
                style: AppTypography.bodyMedium
                    .copyWith(color: AppColors.textSecondary, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
