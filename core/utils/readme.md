# Utilities
Utilities serve as helper functions and tools designed to simplify and streamline development tasks. These reusable functions can be easily accessed and utilized throughout the project.

## AI Instructions (Utilities)
1. Keep utilities pure and side-effect free when possible.
2. Avoid UI dependencies in utility files.
3. Prefer extensions for small, reusable helpers.
4. Add logging through `logger.dart` instead of `print`.

This directory contains five essential files to aid in development:

## Extensions
Provides custom extensions to enhance existing classes and simplify common operations.

### Available Extensions
- `Widget.dismissKeyboardOnTap(context)` for keyboard dismissal on tap.
- `Future<T>.showProgress(context)` to show a progress dialog while awaiting a future.
- `DateTime` format helpers (e.g., `yMd()`, `MMM()`, `Hm()`, etc.).
- `String.capitalize` to title-case words in a string.

## Logger
A logging utility for debugging and tracking application behavior.

### Logging Helpers
- `clog(object)` for debug-only structured logging.
- `elog(object)` for error logging and Crashlytics reporting in release.
- `cprint(object)` for lightweight debug prints.

## Navigations
Simplifies navigation logic with predefined methods for seamless screen transitions.

### Navigation Helpers
- `startScreen(context, screen)` to push a new screen.
- `replaceScreen(context, screen)` to replace the current screen.
- `closeScreen(context, result)` to pop with optional result.

## Preferences
Handles shared preferences for storing and retrieving persistent data easily.

### Preferences Notes
- Use `Preferences.instance()` to obtain the shared instance.
- Current keys include `token` (string). Extend carefully to avoid key collisions.

## Utils
A collection of miscellaneous utility functions that don't fit into other categories but are essential for development.

## AppConfig
`app_config.dart` provides an environment-aware configuration with `endpoint`, `appName`, and `color`.
- `AppConfig.read(context)` retrieves the active config.
- `AppConfig.builder(config, builder)` injects config into the widget tree.
- `AppConfig.switchConfig(context, config)` updates the active config and notifies listeners.

### Utility Helpers
- `getMaterialColor(color)` to generate a `MaterialColor` swatch from any color.
- `size(context)` to read `MediaQuery` size.
- `randomString(length)` to generate a random alphanumeric string.

## Routing
`route.dart` defines the app router using `go_router` with `root` and `home` routes. Keep route names stable and update this file when adding new navigation paths.