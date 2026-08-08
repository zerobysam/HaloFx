import 'package:flutter/foundation.dart';

/// Simple app-wide auth flag. Swap for real session/auth state later —
/// every "locked" guest screen (Accounts, Calculation History, Save
/// Setup, More) reads from this single source.
class AuthStatus {
  AuthStatus._();

  static final ValueNotifier<bool> isLoggedIn = ValueNotifier<bool>(false);

  static void logIn() => isLoggedIn.value = true;
  static void logOut() => isLoggedIn.value = false;
}
