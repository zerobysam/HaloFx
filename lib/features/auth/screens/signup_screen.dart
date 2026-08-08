import 'package:flutter/material.dart';
import '../../../core/state/auth_status.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_gradient_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../dashboard/screens/dashboard_screen.dart';
import '../widgets/google_auth_button.dart';
import '../widgets/or_divider.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _completeSignup() {
    AuthStatus.logIn();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
      (route) => false,
    );
  }

  void _handleCreateAccount() {
    if (!_agreedToTerms) return;
    // TODO: wire up real signup logic — for now, valid input creates the session
    _completeSignup();
  }

  void _handleGoogleSignup() {
    // TODO: wire up Google OAuth — for now, simulates a successful signup
    _completeSignup();
  }

  void _goToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
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
              const SizedBox(height: 8),

              Text(
                'Create your account',
                style: AppTypography.authTitle,
              ),
              const SizedBox(height: 6),
              Text(
                'Start your trading journey',
                style: AppTypography.bodyMedium.copyWith(fontSize: 15),
              ),

              const SizedBox(height: 28),
              GoogleAuthButton(onPressed: _handleGoogleSignup),
              const SizedBox(height: 20),
              const OrDivider(),
              const SizedBox(height: 20),

              AppTextField(hintText: 'Full Name', controller: _nameController),
              const SizedBox(height: 14),
              AppTextField(
                hintText: 'Email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 14),
              AppTextField(
                hintText: 'Password',
                controller: _passwordController,
                isPassword: true,
              ),
              const SizedBox(height: 16),

              // Terms checkbox
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 22,
                    height: 22,
                    child: Checkbox(
                      value: _agreedToTerms,
                      onChanged: (v) => setState(() => _agreedToTerms = v ?? false),
                      activeColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: AppTypography.bodySmall.copyWith(fontSize: 13, height: 1.4),
                        children: [
                          const TextSpan(text: 'I agree to the '),
                          TextSpan(
                            text: 'Terms of Service',
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 13, color: AppColors.textLink, fontWeight: FontWeight.w600),
                          ),
                          const TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 13, color: AppColors.textLink, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              AppGradientButton(label: 'Create Account', onPressed: _handleCreateAccount),

              const SizedBox(height: 24),
              Center(
                child: RichText(
                  text: TextSpan(
                    style: AppTypography.bodyMedium,
                    children: [
                      const TextSpan(text: 'Already have an account? '),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: GestureDetector(
                          onTap: _goToLogin,
                          child: Text(
                            'Log in',
                            style: AppTypography.linkBold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
