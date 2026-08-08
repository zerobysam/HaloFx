/// Access tier for a single calculator. Set per-item in calculator_items.dart
/// so adding a new gated calculator is a one-line change, not new logic.
enum CalculatorAccessLevel {
  free,
  requiresLogin,
  premium,
}
