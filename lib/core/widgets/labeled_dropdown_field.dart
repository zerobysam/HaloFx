import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class LabeledDropdownField extends StatelessWidget {
  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;
  final Widget? leading;

  const LabeledDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    this.leading,
  });

  Future<void> _showPicker(BuildContext context) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.bgElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(width: 36, height: 4, decoration: BoxDecoration(
                color: AppColors.border, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 12),
              ...options.map((opt) => ListTile(
                    title: Text(opt, style: AppTypography.bodyLarge),
                    trailing: opt == value
                        ? const Icon(Icons.check_rounded, color: AppColors.primary)
                        : null,
                    onTap: () => Navigator.of(context).pop(opt),
                  )),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
    if (selected != null) onChanged(selected);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.bodySmall.copyWith(fontSize: 13, color: AppColors.textSecondary)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showPicker(context),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.bgInput,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              children: [
                if (leading != null) ...[leading!, const SizedBox(width: 10)],
                Expanded(
                  child: Text(value, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                ),
                const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textTertiary),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
