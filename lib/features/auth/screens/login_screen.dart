import 'package:flutter/material.dart';
import '../../../core/state/auth_status.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_gradient_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../dashboard/screens/dashboard_screen.dart';
import '../widgets/google_auth_button.dart';
import '../widgets/or_divider.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _completeLogin() {
    AuthStatus.logIn();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
      (route) => false,
    );
  }

  void _handleLogin() {
    // TODO: wire up real auth logic — for now, any input logs in
    _completeLogin();
  }

  void _handleGoogleLogin() {
    // TODO: wire up Google OAuth — for now, simulates a successful login
    _completeLogin();
  }

  void _goToSignup() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const SignupScreen()),
    );
  }

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
              const SizedBox(height: 8),

              Row(
                children: [
                  Text('Welcome back ', style: AppTypography.authTitle),
                  const Text('👋', style: TextStyle(fontSize: 24)),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Log in to continue',
                style: AppTypography.bodyMedium.copyWith(fontSize: 15),
              ),

              const SizedBox(height: 28),
              GoogleAuthButton(onPressed: _handleGoogleLogin),
              const SizedBox(height: 20),
              const OrDivider(),
              const SizedBox(height: 20),

              AppTextField(
                hintText: 'Email or Username',
                controller: _identifierController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 14),
              AppTextField(
                hintText: 'Password',
                controller: _passwordController,
                isPassword: true,
              ),
              const SizedBox(height: 12),

              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {
                    // TODO: forgot password flow
                  },
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  child: Text(
                    'Forgot password?',
                    style: AppTypography.linkMedium,
                  ),
                ),
              ),

              const SizedBox(height: 16),
              AppGradientButton(label: 'Log In', onPressed: _handleLogin),

              const Spacer(),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: RichText(
                    text: TextSpan(
                      style: AppTypography.bodyMedium,
                      children: [
                        const TextSpan(text: "Don't have an account? "),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: GestureDetector(
                            onTap: _goToSignup,
                            child: Text(
                              'Sign up',
                              style: AppTypography.linkBold,
                            ),
                          ),
                        ),
                      ],
                    ),
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
