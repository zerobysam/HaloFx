import 'package:flutter/material.dart';
import 'package:halofx/core/theme/app_colors.dart';
import 'package:halofx/model/dashboard_mock_data.dart';

import 'dashboard_section_title.dart';

class ContinueCalculatorCard extends StatelessWidget {
  const ContinueCalculatorCard({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const DashboardSectionTitle(title: 'Continue Last Calculator'),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A1538), Color(0xFF11172A)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF30245C)),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.purple.withOpacity(.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.calculate_rounded,
                    color: AppColors.purpleBright,
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lastCalculator.name,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        lastCalculator.details,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                const CircleAvatar(
                  radius: 15,
                  backgroundColor: Color(0xFF29204D),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.purpleBright,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
