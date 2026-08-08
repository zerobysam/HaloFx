import 'package:flutter/foundation.dart';

/// Simple app-wide subscription flag. Swap for real purchase/entitlement
/// state (RevenueCat, in_app_purchase, backend flag, etc.) later — every
/// ad banner and paywall in the app reads from this single source.
class PremiumStatus {
  PremiumStatus._();

  static final ValueNotifier<bool> isPremium = ValueNotifier<bool>(false);

  static void unlock() => isPremium.value = true;
  static void lock() => isPremium.value = false;
}
