# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Toolchain

Flutter is managed via **FVM** and is **not installed system-wide**. Always invoke through FVM from the project root:

```bash
fvm flutter pub get          # install dependencies
fvm flutter run              # launch on the connected device
fvm flutter analyze          # static analysis (uses analysis_options.yaml)
fvm flutter test             # run all tests
fvm flutter test test/widget_test.dart    # run a single test file
fvm flutter test --plain-name "Login screen renders"  # run a single test by name
```

The Flutter channel is pinned in `.fvmrc` (`stable`). Dart SDK constraint: `^3.11.4`.

## Stack (locked-in choices — do not swap without asking)

- **State management:** `flutter_riverpod ^3.3.1`. The app is wrapped in `ProviderScope` (`lib/main.dart`). Screens are `ConsumerWidget` so providers can drop in later — most screens currently take `WidgetRef` but don't read anything yet.
- **Routing:** `go_router ^17.2.0` using `StatefulShellRoute.indexedStack`.
- **Fonts:** `google_fonts` (Roboto), built into the `TextTheme` in `lib/core/theme/app_typography.dart`.
- **Material 3** with a hand-tuned `ColorScheme` (see Theme section). Do **not** switch to `ColorScheme.fromSeed` — the palette comes from Figma `material-theme/sys/light-medium-contrast` and is hand-picked.

## Architecture

Feature-first layout under `lib/`:

```
lib/
  main.dart          # runApp(ProviderScope(child: ElectrifyApp()))
  app.dart           # MaterialApp.router wiring theme + appRouter
  core/
    router/          # app_router.dart (GoRouter), app_routes.dart (path constants)
    theme/           # app_colors.dart, app_typography.dart, app_theme.dart
    widgets/         # XrAppBar, XrBottomNav, XrAppDrawer (shared chrome)
  features/
    auth/            presentation/login_screen.dart
    charging/        presentation/{active_charging,connector_selection,location_details,session_summary}_screen.dart
    history/         presentation/{charging_history,session_details}_screen.dart
    home/            presentation/home_screen.dart, presentation/widgets/location_dial.dart
    map/             presentation/{map,map_search}_screen.dart
    notifications/   presentation/notifications_screen.dart
    profile/         presentation/profile_screen.dart
```

Each feature currently has only a `presentation/` layer. The `data/` and `domain/` layers will be added later — keep that in mind when introducing new code so the slot stays clean.

### Routing model

`lib/core/router/app_router.dart` defines a single `GoRouter`:

- `/login` is a top-level route **outside** the shell.
- A `StatefulShellRoute.indexedStack` wraps three branches with their own navigator keys so each tab keeps an independent back stack:
  - **Branch 0 — Profile (`Asetukset`)**: `/profile` → `notifications`, `history`, `history/:id`
  - **Branch 1 — Home (`Koti`)**: `/home` → `connector`, `location/:id`, `charging`, `summary/:id`
  - **Branch 2 — Map (`Kartta`)**: `/map` → `search`, `location/:id`
- The shell renders `_ShellScaffold`, which mounts `XrBottomNav` and `XrAppDrawer` once.
- All paths and `*For(id)` builders live in `lib/core/router/app_routes.dart` — **always** add new routes there rather than hardcoding strings at call sites.

Note that `LocationDetailsScreen` is reused under both the Home and Map branches with different parameter ids — see "Parameterize Figma variants" below.

### Theme

`lib/core/theme/app_theme.dart` builds a single `AppTheme.light` using:

- `AppColors` — explicit Figma tokens (primary `#497847`, surface `#FFFFFF`, surfaceContainer `#E6E9E0`, etc.). Don't introduce new color literals at call sites; add tokens here.
- `AppTypography.build()` — Roboto via `google_fonts` with a 6-style scale matching Figma (`headlineMedium`, `titleLarge`, `bodyLarge`, `bodyMedium`, `labelLarge`, `labelMedium`).
- `navigationBarTheme` and `filledButtonTheme` are pre-styled (pill button, 52px tall, 26 radius). Use `FilledButton` for primary CTAs to inherit the styling.

### Shared chrome widgets

- **`XrAppBar`** (`lib/core/widgets/xr_app_bar.dart`) — pill-shaped Material 3 app bar (376×72, radius 36, primary-container background) implementing `PreferredSizeWidget`. The leading icon defaults to `menu` (drawer), trailing defaults to `notifications`. Pass `leadingIcon: Icons.arrow_back` + `onLeadingTap: () => context.pop()` for back navigation.
- **`XrBottomNav`** — Material 3 `NavigationBar`, 3 destinations in Figma order: Asetukset · Koti · Kartta. The default selected tab is **Koti (index 1)**.
- **`XrAppDrawer`** — full menu with `context.go(...)` to switch tabs / log out.

## Project conventions

### Language

UI strings are in **Finnish** (the source Figma is Finnish). Do **not** introduce `intl`/`arb` localization unless explicitly asked — keep strings inline.

### Parameterize Figma variants

The Figma file (key `96qOukJ8ov08DQkicRndaC`, "Electrify") has 36 frames but only 14 unique screens. Variants like "Paikka valittu 02..10" map to a single parameterized screen (e.g., `LocationDetailsScreen({required this.locationId})`). When implementing a new screen that has visual variants in Figma, prefer a single screen with constructor parameters over duplicating files.

### Out of scope until explicitly requested

This project is the **visual + navigation scaffold**. Real logic comes later. Do **not**, without being asked:

- Wire `flutter_riverpod` providers to actual data sources or add a backend HTTP client
- Add `google_maps_flutter` (the map screen is a placeholder)
- Add BLE, payments, persistence, or auth integrations
- Introduce `intl`/`arb`
- Restructure the feature-first layout

`// TODO(logic):` markers in screens mark the places where real providers/data will slot in later.

## Testing

`test/widget_test.dart` boots the full app via `ProviderScope(child: ElectrifyApp())` and asserts the `LoginScreen` renders (`'Tervetuloa Electrifyyn'`, `'Kirjaudu sisään'`). New screen tests should follow the same pattern: pump the real `ElectrifyApp` and navigate via `go_router`, rather than constructing screens in isolation, so router + theme behavior is exercised end-to-end.
