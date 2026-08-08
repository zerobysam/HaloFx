import 'package:flutter/material.dart';
import '../../../core/auth/access_control.dart';
import '../../../core/state/calculation_history_store.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/ad_banner.dart';
import '../../history/models/calculation_history_entry.dart';
import '../../journal/screens/save_setup_screen.dart';
import '../models/pip_value_result.dart';

class PipValueResultScreen extends StatefulWidget {
  final PipValueResult result;

  const PipValueResultScreen({super.key, required this.result});

  @override
  State<PipValueResultScreen> createState() => _PipValueResultScreenState();
}

class _PipValueResultScreenState extends State<PipValueResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currencySymbol = widget.result.accountCurrency == 'USD'
        ? '\$'
        : widget.result.accountCurrency == 'EUR'
            ? '€'
            : widget.result.accountCurrency == 'GBP'
                ? '£'
                : '';

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        title: Text('Calculation Result', style: AppTypography.headlineMedium),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: AppColors.bgSecondary,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$currencySymbol${widget.result.pipValue.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: AppColors.success,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Pip Value',
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.result.lotTypeLabel,
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.textTertiary,
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Divider(color: AppColors.divider),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text('1 Pip',
                                          style: AppTypography.bodySmall
                                              .copyWith(
                                                  color:
                                                      AppColors.textSecondary)),
                                      const SizedBox(height: 6),
                                      Text(
                                        widget.result.pipSize.toString(),
                                        style: AppTypography.headlineSmall
                                            .copyWith(
                                                color: AppColors.textPrimary),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 40,
                                  color: AppColors.divider,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text('Contract Size',
                                          style: AppTypography.bodySmall
                                              .copyWith(
                                                  color:
                                                      AppColors.textSecondary)),
                                      const SizedBox(height: 6),
                                      Text(
                                        widget.result.contractSize.toString(),
                                        style: AppTypography.headlineSmall
                                            .copyWith(
                                                color: AppColors.textPrimary),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () async {
                    final allowed = await ensureLoggedIn(context, featureName: 'Saved Calculations');
                    if (!allowed) return;
                    if (!context.mounted) return;
                    CalculationHistoryStore.record(CalculationHistoryEntry(
                      calculatorTitle: 'Pip Value',
                      resultSummary: '\$${widget.result.pipValue.toStringAsFixed(2)} per pip',
                      icon: Icons.grain_rounded,
                      timestamp: DateTime.now(),
                    ));
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SaveSetupScreen(initialName: 'Pip Value Setup')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text('Save', style: AppTypography.buttonText),
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
