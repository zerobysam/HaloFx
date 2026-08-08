# HaloFX Architecture

HaloFX uses Flutter with a feature-based structure.

## Structure

lib/

core/
- Theme
- Constants
- Utilities
- Shared widgets

features/

calculators/
- Models
- Calculation logic
- Providers
- Screens
- Widgets

accounts/
- Models
- Providers
- Screens
- Widgets

auth/
- Models
- Providers
- Screens

dashboard/
- Screens
- Widgets

## State

Riverpod manages application state.

UI
↓
Provider
↓
Repository / Service
↓
Data

Calculation logic should not live inside UI widgets.

Backend integration will be added through repositories/services.
