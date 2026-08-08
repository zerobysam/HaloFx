import 'package:flutter/material.dart';
import '../../../core/theme/app_typography.dart';

class GoogleAuthButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GoogleAuthButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF3F3F5),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onPressed,
        child: Container(
          height: 52,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Swap for an actual Google 'G' logo asset/svg in production
              Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                child: const Text(
                  'G',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF4285F4),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Continue with Google',
                style: AppTypography.bodyMedium.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
