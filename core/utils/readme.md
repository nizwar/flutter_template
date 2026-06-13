# Utilities

Helper functions, extensions, and small services that simplify everyday development. They are reusable and shared across the project.

## AI Instructions (Utilities)

1. Keep utilities pure and side-effect free where possible.
2. Avoid UI dependencies in utility files (except intentional `Widget`/`BuildContext` extensions).
3. Prefer extensions for small, reusable helpers.
4. Log through `logger.dart`, never `print`.

## Extensions (`extensions.dart`)

- `Widget.dismissKeyboardOnTap(context)` — wrap a widget to unfocus the keyboard on tap.
- `Future<T>.showProgress(context)` — show a progress dialog while the future runs; returns its value.
- `DateTime` formatters — `yMd(context)`, `MMMd(context)`, `Hm(context)`, `jm(context)`, etc. Each takes the `BuildContext` (used to resolve the active locale via `Localizations`) and an optional `locale:` override as an ICU string (e.g. `'id_ID'`):
  ```dart
  DateTime.now().yMMMMd(context);             // app locale
  DateTime.now().yMMMMd(context, locale: 'id'); // forced
  ```
- `String.capitalize` — title-cases each word.

## Logger (`logger.dart`)

- `clog(object)` — debug-only structured logging (pretty JSON for `Map`/`List`).
- `elog(object)` — logs in debug; reports to Crashlytics in release.
- `cprint(object)` — lightweight `debugPrint` in debug only.

## Navigations (`navigations.dart`)

Imperative `Navigator` helpers (use go_router via `route.dart` for declarative routing):

- `startScreen(context, screen)` — push a new screen.
- `replaceScreen(context, screen)` — replace the current screen.
- `closeScreen(context, [result])` — pop with an optional result.

## Preferences (`preferences.dart`)

A thin wrapper over `SharedPreferences`.

```dart
final prefs = await Preferences.instance();
prefs.token = 'abc123';            // setter; passing null removes the key
await prefs.saveToken('abc123');   // awaitable variant
final String? token = prefs.token;
await prefs.clearToken();          // remove just the token
await prefs.clear();               // wipe everything
```

- Built-in keys: `token` and `themeModeIndex` (used by `ThemeProvider`).
- Add new keys as `static const` to avoid collisions and typos.

## AppConfig (`app_config.dart`)

Environment-aware config exposing `endpoint`, `appName`, and `color`.

- `AppConfig.read(context)` — read the active config.
- `AppConfig.builder(config, builder)` — inject a config into the widget tree (used in `main.dart`).
- `AppConfig.switchConfig(context, newConfig)` — copy `newConfig`'s fields into the active config and notify listeners.

## Utils (`utils.dart`)

- `getMaterialColor(color)` — generate a `MaterialColor` swatch from any `Color`.
- `size(context)` — shorthand for `MediaQuery.of(context).size`.
- `randomString(length)` — random alphanumeric string.
- Re-exports `navigations.dart` and `preferences.dart` for convenience.

## Routing (`route.dart`)

Defines the app router with `go_router`. Ships with `root` (`/`) and `home` (`/home`) routes.

- Add new routes as `GoRoute` entries in `getRouter()`.
- Navigate with `context.goNamed("home")` / `context.pushNamed(...)`.
- Keep route names stable; other code references them by name.
