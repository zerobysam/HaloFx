# TradRisk

## Setup
```bash
unzip tradrisk.zip && cd tradrisk
flutter create .
flutter pub get
flutter run
```

## What changed in this pass

**Login-gated calculators** — `CalculatorAccessLevel` enum
(`free` / `requiresLogin` / `premium`) on `CalculatorItem`
(`features/calculators/models/calculator_access_level.dart`). Add more
gated calculators by setting `accessLevel: CalculatorAccessLevel.requiresLogin`
on their entry in `calculator_items.dart` — no other code changes needed.
Currently gated: **Risk Reward**, **Drawdown Recovery**. Gated cards show
a small lock/premium badge in the grid.

**Centralized login gate** — `core/auth/access_control.dart` exports
`ensureLoggedIn(context, featureName:)`. Used in two places:
1. Hub screen, before opening any `requiresLogin` calculator
2. Every result screen's Save button — previously 5 of 7 had no Save
   button at all, and the other 2 had one with zero auth check. All 9
   result screens (Position Size, Futures, Pip Value, Margin, Risk
   Reward, Drawdown, Profit & Loss) now gate Save through this.

**Fixed the actual tab bug** — Calculators tab's bottom nav had
regressed to a no-op `onTap: (_) {}` and the guest upsell banner was
commented out. Both restored in `calculators_hub_screen.dart`.

**Journal removed, Calculation History added** — `journal_home_screen.dart`
and `add_trade_screen.dart` deleted. `features/journal/screens/save_setup_screen.dart`
stays (still used by every result screen's Save flow — it's not a nav
tab, just the save form). New: `core/state/calculation_history_store.dart`
(in-memory, same `ValueNotifier` pattern as `AuthStatus`/`PremiumStatus`)
+ `features/history/screens/calculation_history_screen.dart`, gated
behind login. Every Save action now also records a
`CalculationHistoryEntry`. Bottom nav: Dashboard / Accounts /
Calculators / **History** / More.

## Known gaps
- History is in-memory only — clears on app restart. TODO noted in
  `calculation_history_store.dart` for real persistence.
- `intl` was missing from `pubspec.yaml` despite being used by the
  Drawdown/Profit&Loss report screens — added (`^0.19.0`).
- `ensureLoggedIn` doesn't automatically retry the gated action after
  a successful login — the user taps Save/open again once logged in.
  Documented in the function's doc comment; upgrading this to
  auto-resume would need `LoginScreen` to return a result on pop.

## Latest pass: Accounts + Account Detail + Risk Calculator

Three screens rebuilt to match a new mockup exactly:

- **Risk Calculator** (`features/calculators/screens/risk_calculator_screen.dart`)
  — Position Size / Risk % / Pip Value segmented tabs (Position Size
  fully built; other two are placeholders), account + pair pickers,
  Entry/Stop Loss inputs, Risk %/Risk Amount with a swap toggle, a
  live result card, and a gradient risk meter with dynamic risk-level
  tip. Reachable as the "Calculator" tab.
- **Accounts** (`features/accounts/screens/accounts_screen.dart`) —
  filter chips (All/Prop Firms/Personal/Archived), account cards with
  a sparkline chart and per-account-type stat variants, "Add New
  Account" card.
- **Account Detail** (`features/accounts/screens/account_detail_screen.dart`)
  — Overview/Performance/Trades/Rules tabs (Overview fully built),
  equity curve chart with gradient fill, stats grid with progress
  bars, risk summary with a circular gauge, fixed bottom action bar
  (Add Trade / Calculator / Deposit).

New chart widgets (`core/widgets/`): `sparkline_chart.dart`,
`equity_curve_chart.dart`, `circular_gauge.dart` — all custom
`CustomPainter`s, no new chart package dependency.

**Bottom nav changed** to match this mockup: Home / Accounts /
Calculator / Community / Profile (previously Dashboard / Accounts /
Calculators / History / More). `CalculatorsHubScreen` (the older
multi-calculator grid) and `CalculationHistoryScreen` still exist and
work — they're just no longer primary tabs. History is now reached
via the clock icon in Risk Calculator's app bar. `CommunityScreen` is
a new placeholder.

Mock account data now lives in `core/state/accounts_store.dart`
(`AccountsStore`, `ValueNotifier`-based like `AuthStatus`) — 3 accounts
matching the mockup (FTMO Challenge, Personal Account, FundedNext Eval).


flutter run -d 45975A20-D0B1-44D8-A1FD-940B550C5C51