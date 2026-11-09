import 'package:flutter/material.dart';
import 'package:halofx/core/theme/app_colors.dart';

class CalculatorSearchField extends StatelessWidget {
  const CalculatorSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onFilterTap,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onFilterTap;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
      decoration: InputDecoration(
        hintText: 'Search calculators...',
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: AppColors.textSecondary,
        ),
        suffixIcon: IconButton(
          onPressed: onFilterTap,
          icon: const Icon(
            Icons.tune_rounded,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
