import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/auth/access_control.dart';
import '../../../core/state/calculation_history_store.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../history/models/calculation_history_entry.dart';
import '../../journal/screens/save_setup_screen.dart';
import '../models/drawdown_result.dart';

class DrawdownReportScreen extends StatelessWidget {
  final DrawdownResult result;

  const DrawdownReportScreen({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      symbol: result.currencySymbol,
      decimalDigits: 2,
    );

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        title: Text('Drawdown Report', style: AppTypography.headlineMedium),
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
                    // Top Progress & Status Card
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
                              Text('Current Drawdown',
                                  style: AppTypography.bodyMedium.copyWith(
                                      color: AppColors.textSecondary)),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFFFFB000).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const CircleAvatar(
                                      radius: 4,
                                      backgroundColor: Color(0xFFFFB000),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      result.riskLevel,
                                      style: AppTypography.bodyMedium.copyWith(
                                        color: const Color(0xFFFFB000),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${result.drawdownPercentage.toStringAsFixed(2)}%',
                            style: AppTypography.headlineMedium.copyWith(
                              color: const Color(0xFFFF4D4D),
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: (result.drawdownPercentage / 100)
                                  .clamp(0.0, 1.0),
                              minHeight: 8,
                              backgroundColor: AppColors.bgElevated,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFFFF4D4D),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  '${result.drawdownPercentage.toStringAsFixed(0)}%',
                                  style: AppTypography.bodyMedium.copyWith(
                                      color: AppColors.textTertiary,
                                      fontSize: 12)),
                              Text('100%',
                                  style: AppTypography.bodyMedium.copyWith(
                                      color: AppColors.textTertiary,
                                      fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Metrics Grid (2 columns)
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.55,
                      children: [
                        _buildMetricCard(
                          label: 'Peak Balance',
                          value: currencyFormat.format(result.peakBalance),
                          icon: Icons.show_chart_rounded,
                          iconColor: const Color(0xFFA855F7),
                        ),
                        _buildMetricCard(
                          label: 'Current Balance',
                          value: currencyFormat.format(result.currentBalance),
                          icon: Icons.account_balance_wallet_rounded,
                          iconColor: const Color(0xFF3B82F6),
                        ),
                        _buildMetricCard(
                          label: 'Money Lost',
                          value: currencyFormat.format(result.moneyLost),
                          icon: Icons.file_download_outlined,
                          iconColor: const Color(0xFFFF4D4D),
                        ),
                        _buildMetricCard(
                          label: 'Recovery Needed',
                          value:
                              '${result.recoveryNeededPercentage.toStringAsFixed(2)}%',
                          icon: Icons.trending_up_rounded,
                          iconColor: const Color(0xFFA855F7),
                        ),
                        _buildMetricCard(
                          label: 'Recovery Amount',
                          value: currencyFormat.format(result.recoveryAmount),
                          icon: Icons.savings_outlined,
                          iconColor: const Color(0xFFA855F7),
                        ),
                        _buildMetricCard(
                          label: 'Break Even Balance',
                          value: currencyFormat.format(result.breakEvenBalance),
                          icon: Icons.outlined_flag_rounded,
                          iconColor: const Color(0xFF3B82F6),
                        ),
                      ],
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
                                  'A ${result.drawdownPercentage.toStringAsFixed(0)}% drawdown requires a ${result.recoveryNeededPercentage.toStringAsFixed(0)}% gain to recover your previous peak. Focus on consistency and risk control.',
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
                                  value: 0.92,
                                  strokeWidth: 4,
                                  backgroundColor: AppColors.bgElevated,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF00E676),
                                  ),
                                ),
                              ),
                              Text(
                                '92%\nConf',
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

                    // Sponsored Ad Banner Component
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.bgSecondary,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Sponsored',
                              style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.textTertiary, fontSize: 11)),
                          const SizedBox(height: 4),
                          Text('exness',
                              style: AppTypography.headlineMedium.copyWith(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text(
                            'The best pricing on gold. Low spreads, fast execution.',
                            style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textSecondary, fontSize: 12),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFC107),
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Trade Now',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Did you know Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.bgSecondary,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.lightbulb_outline_rounded,
                              color: AppColors.gold, size: 24),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Did you know?',
                                    style: AppTypography.headlineMedium
                                        .copyWith(fontSize: 14)),
                                const SizedBox(height: 4),
                                Text(
                                  'Most professional traders risk 1-2% per trade to avoid deep drawdowns.',
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Actions Strip
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
                      calculatorTitle: 'Drawdown Recovery',
                      resultSummary: '${result.drawdownPercentage.toStringAsFixed(1)}% drawdown',
                      icon: Icons.trending_down_rounded,
                      timestamp: DateTime.now(),
                    ));
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SaveSetupScreen(initialName: 'Drawdown Report')),
                    );
                  }),
                  _buildBottomAction(Icons.copy_rounded, 'Copy', () {}),
                  _buildBottomAction(Icons.share_outlined, 'Share', () {}),
                  _buildBottomAction(Icons.refresh_rounded, 'Recalculate', () {
                    Navigator.pop(context);
                  }),
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
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Icon(icon, color: iconColor, size: 20),
        ],
      ),
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
