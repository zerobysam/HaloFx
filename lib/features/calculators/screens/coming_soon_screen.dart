import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class ComingSoonScreen extends StatelessWidget {
  final String title;

  const ComingSoonScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: AppColors.textPrimary, size: 20),
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.construction_rounded, color: AppColors.textTertiary, size: 40),
                      const SizedBox(height: 12),
                      Text(title, style: AppTypography.headlineMedium),
                      const SizedBox(height: 6),
                      Text('Coming soon', style: AppTypography.bodyMedium),
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
}
