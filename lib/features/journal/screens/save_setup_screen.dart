import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/lock_prompt_card.dart';
import '../../auth/screens/login_screen.dart';

class SaveSetupScreen extends StatefulWidget {
  final String? initialName;
  final Set<String>? initialTags;

  const SaveSetupScreen({super.key, this.initialName, this.initialTags});

  @override
  State<SaveSetupScreen> createState() => _SaveSetupScreenState();
}

class _SaveSetupScreenState extends State<SaveSetupScreen> {
  late final _nameController = TextEditingController(text: widget.initialName ?? 'My EUR/USD Setup');
  late final Set<String> _selectedTags = {...?widget.initialTags};
  static const _defaultTags = ['EUR/USD', 'London Session', 'Breakout', 'Scalp', 'Swing'];
  List<String> get _availableTags => {..._defaultTags, ..._selectedTags}.toList();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _goToLogin() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
                  ),
                  Text('Save Setup', style: AppTypography.headlineSmall),
                ],
              ),
              const SizedBox(height: 16),

              Text('Setup Name', style: AppTypography.bodySmall.copyWith(fontSize: 13)),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.bgInput,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: TextField(
                  controller: _nameController,
                  style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                  decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 14)),
                ),
              ),

              const SizedBox(height: 18),
              Text('Add Tags (Optional)', style: AppTypography.bodySmall.copyWith(fontSize: 13)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableTags.map((tag) {
                  final isSelected = _selectedTags.contains(tag);
                  return GestureDetector(
                    onTap: () => setState(() {
                      isSelected ? _selectedTags.remove(tag) : _selectedTags.add(tag);
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : AppColors.bgElevated,
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
                      ),
                      child: Text(
                        tag,
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 13,
                          color: isSelected ? Colors.white : AppColors.textSecondary,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),
              LockPromptCard(
                title: 'Save this setup',
                message: 'Log in or create an account to save your setups and access them on any device.',
                onLogIn: _goToLogin,
              ),

              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    child: Text('Not now', style: AppTypography.bodyMedium),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    child: Text('Save Locally', style: AppTypography.linkMedium.copyWith(fontSize: 14)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
