import 'package:flutter/material.dart';
import '../state/auth_status.dart';
import '../theme/app_colors.dart';
import '../widgets/lock_prompt_card.dart';
import '../../features/auth/screens/login_screen.dart';

/// Centralized login gate. Call before any action that requires an
/// account (opening a login-required calculator, saving a result,
/// viewing calculation history, etc):
///
/// ```dart
/// final allowed = await ensureLoggedIn(context, featureName: 'Risk Reward Calculator');
/// if (!allowed) return;
/// // proceed with the gated action
/// ```
///
/// Returns true immediately if already logged in. If not, shows a
/// bottom sheet explaining why and offers Log In / Sign Up, then
/// returns false — the gated action doesn't proceed on this tap; the
/// user retries after logging in (LoginScreen returns to wherever it
/// was opened from once complete).
Future<bool> ensureLoggedIn(BuildContext context, {String? featureName}) async {
  if (AuthStatus.isLoggedIn.value) return true;

  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (sheetContext) => Padding(
      padding: EdgeInsets.only(
        left: 20, right: 20, bottom: MediaQuery.of(sheetContext).padding.bottom + 20, top: 8,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bgElevated,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(16),
        child: LockPromptCard(
          title: 'Login Required',
          message: featureName != null
              ? 'Log in or create an account to use $featureName.'
              : 'Log in or create an account to continue.',
          onLogIn: () {
            Navigator.of(sheetContext).pop();
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          },
        ),
      ),
    ),
  );

  return false;
}
