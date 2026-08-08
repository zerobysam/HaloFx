import 'package:flutter/foundation.dart';
import '../../features/history/models/calculation_history_entry.dart';

/// App-wide calculation history — every calculator's gated Save
/// action (see access_control.dart) records here once the user is
/// confirmed logged in. In-memory for now; TODO: persist locally and
/// sync through a real backend once available, same pattern as
/// AuthStatus/PremiumStatus.
class CalculationHistoryStore {
  CalculationHistoryStore._();

  static final ValueNotifier<List<CalculationHistoryEntry>> entries =
      ValueNotifier<List<CalculationHistoryEntry>>([]);

  static void record(CalculationHistoryEntry entry) {
    entries.value = [entry, ...entries.value];
  }

  static void clear() => entries.value = [];
}
