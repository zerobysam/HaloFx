import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class LockPromptCard extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onLogIn;

  const LockPromptCard({
    super.key,
    required this.title,
    required this.message,
    required this.onLogIn,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgElevated,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.15), shape: BoxShape.circle),
                child: const Icon(Icons.lock_outline_rounded, color: AppColors.primaryLight, size: 16),
              ),
              const SizedBox(width: 10),
              Text(title, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 8),
          Text(message, style: AppTypography.bodySmall.copyWith(fontSize: 13, height: 1.4)),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: onLogIn,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text('Log In / Sign Up', style: AppTypography.buttonText.copyWith(fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }
}
