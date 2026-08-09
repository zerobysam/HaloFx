import 'package:flutter/material.dart';
import '../../../core/auth/access_control.dart';
import '../../../core/state/auth_status.dart';
import '../../../core/state/calculation_history_store.dart';
import '../models/calculation_history_entry.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/lock_prompt_card.dart';

class CalculationHistoryScreen extends StatelessWidget {
  const CalculationHistoryScreen({super.key});

  String _timeAgo(DateTime t) {
    final diff = DateTime.now().difference(t);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: ValueListenableBuilder<bool>(
          valueListenable: AuthStatus.isLoggedIn,
          builder: (context, isLoggedIn, _) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 8, 20, 12),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
                      ),
                      Text('Calculation History', style: AppTypography.headlineMedium.copyWith(fontSize: 20)),
                    ],
                  ),
                ),
                Expanded(
                  child: !isLoggedIn
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              const SizedBox(height: 12),
                              LockPromptCard(
                                title: 'View Your History',
                                message: 'Log in or create an account to see every calculation you\'ve saved.',
                                onLogIn: () async {
                                  await ensureLoggedIn(context, featureName: 'Calculation History');
                                },
                              ),
                            ],
                          ),
                        )
                      : ValueListenableBuilder<List<CalculationHistoryEntry>>(
                          valueListenable: CalculationHistoryStore.entries,
                          builder: (context, entries, _) {
                            if (entries.isEmpty) {
                              return Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.history_rounded, color: AppColors.textTertiary, size: 36),
                                    const SizedBox(height: 10),
                                    Text('No calculations yet', style: AppTypography.bodyLarge),
                                    const SizedBox(height: 4),
                                    Text('Saved calculations will show up here.', style: AppTypography.bodySmall),
                                  ],
                                ),
                              );
                            }
                            return ListView.builder(
                              padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                              itemCount: entries.length,
                              itemBuilder: (context, i) {
                                final e = entries[i];
                                return Container(
                                  padding: const EdgeInsets.all(14),
                                  margin: const EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(
                                    color: AppColors.bgElevated,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(color: AppColors.border),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 38, height: 38,
                                        decoration: BoxDecoration(color: AppColors.primaryLight.withOpacity(0.15), shape: BoxShape.circle),
                                        child: Icon(e.icon, color: AppColors.primaryLight, size: 18),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(e.calculatorTitle, style: AppTypography.bodyLarge.copyWith(fontSize: 14.5, fontWeight: FontWeight.w600)),
                                            const SizedBox(height: 2),
                                            Text(e.resultSummary, style: AppTypography.bodySmall.copyWith(fontSize: 12.5)),
                                          ],
                                        ),
                                      ),
                                      Text(_timeAgo(e.timestamp), style: AppTypography.caption),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
