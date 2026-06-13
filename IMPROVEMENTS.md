# Improvements Applied — flutter_template

Date: 2026-06-13 · Style: conservative (minimal diffs, structure & names preserved).
Findings reference: `DEEP_CHECK_REPORT.md`.

> ⚠️ These changes have **not** yet been verified with `flutter analyze`/`flutter test` (the SDK was unavailable in the editing environment). Run locally before merging:
> ```sh
> flutter analyze && dart fix --apply && flutter test
> ```

## Bug fixes (correctness)

| File | Change |
|---|---|
| `core/utils/app_config.dart` | `switchConfig` now actually copies the fields from `newConfig` into the active instance (was a no-op / self-assignment). |
| `core/utils/preferences.dart` | `token` setter is null-safe (null → `remove`, no crash). Added `saveToken`, `clearToken`, `clear`, plus `themeModeIndex`/`saveThemeModeIndex` for theme persistence. |
| `ui/components/adaptive_progress_indicator.dart` | Replaced `dart:io Platform.isIOS` with `kIsWeb` + `defaultTargetPlatform` (safe on Flutter Web; also supports macOS). |
| `core/https/http_connection.dart` | `ApiResponse.fromJson` accepts an optional `fromJsonT` to deserialize a typed `result`; `props` overridden per field; `success` preserved. `HttpErrorConnection` now separates `data` (response) from `body` (request). `paramsToString` URL-encodes, and requests use Dio `queryParameters` (automatic encoding). `_baseUrl` is initialized (it was a `late` field that was never set). The `Authorization: Bearer` header is injected automatically from `UserProvider`. |
| `core/utils/extensions.dart` | `DateTime` formatters use `String? locale` (not `Locale`), and the `context` parameter is now used to resolve the locale via `Localizations`. `jms` fixed. |
| `ui/components/custom_image.dart` | Guards null/empty `url` → shows the error widget instead of crashing; `fit` is no longer force-unwrapped. |
| `ui/components/custom_shimmer.dart` | `ShimmerContainer.child` is no longer force-unwrapped (`child!` → `SizedBox.shrink` fallback). |

## Performance

- `core/providers/theme_provider.dart`: the `MaterialColor` is cached (`late final`) — no longer recomputed on every theme rebuild.
- `ui/components/page_paginator.dart`: switched `ListView(children: [...List.generate])` → `ListView.builder` (lazy; only visible items are built).
- `core/resources/themes.dart`: `themeProvider(context)` & the swatch are computed once per call (previously twice).
- `core/https/http_connection.dart`: `ApiResponse.props` is per-field (previously inherited `Model.props` based on `toString()` — wasteful).

## New features

- **Automatic auth**: `HttpConnection` injects the `Bearer` token from `UserProvider`; `UserProvider` now has `setToken`/`load`/`logout`/`isLoggedIn` + persistence.
- **Theme persistence**: `ThemeProvider.setThemeMode` saves the choice; `loadPersisted()` is called from `Root.initState`.
- **Global provider**: `UserProvider` is registered in the `MultiProvider` (`main.dart`) — required for token injection to work.
- **`analysis_options.yaml`**: `flutter_lints` config + extra rules to enforce "zero warnings".
- **Non-blank splash**: `SplashScreen` shows the app name + an indicator (was an empty `Scaffold`).
- **`test/example_test.dart`**: example unit tests (`capitalize`, `ApiResponse`). Adjust the package import name, then `flutter test`.

## Robustness & DX

- `core/resources/styles.dart` (previously empty) → `AppStyles`: input decoration, card/pill decoration, title/caption text styles — all theme-driven.
- `core/providers/user_provider.dart`: `logout` actually clears the token (memory + storage).
- `.gitignore` extended: `generated_plugin_registrant.dart`, `*.g.dart`, `*.freezed.dart`, `.DS_Store`.
- Inline documentation (dartdoc) added/cleaned up in the touched files.

## Compatibility notes

- The `params` parameter type in `HttpConnection` changed from `Map<String, String>?` → `Map<String, dynamic>?` (wider, backward-compatible for old callers).
- The `DateTime` formatters changed the named param type from `Locale?` → `String?`. Callers that previously passed `locale:` (likely none, since the old code wouldn't compile) need to pass an ICU string (e.g. `'id_ID'`). Positional calls like `date.yMd(context)` are unchanged.
- `Model` (base) is intentionally unchanged; new models must still override `props` per field (see CLAUDE.md).
