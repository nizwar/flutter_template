# Providers

This folder holds **global** providers — state that needs to be reachable from anywhere in the app, such as the authenticated user/session and theme settings. Widget- or screen-specific state should stay local (next to the widget), not here.

## AI Instructions (Providers)

1. Global providers only live in `lib/core/providers` and are registered in `main.dart`.
2. Add static `read` and `watch` helpers to every provider.
3. Keep each provider small and focused on one responsibility.
4. Expose immutable state; mutate it through methods that call `notifyListeners()`.
5. Don't call APIs directly from the UI; route them through providers or `*_http.dart` clients.

## Current providers (from code)

### ThemeProvider

- Takes a `Color` swatch in its constructor (the swatch is generated once and cached).
- Exposes `themeMode`, `colorSwatch`, and `isDarkMode(context)`.
- `setThemeMode(ThemeMode)` updates the mode, notifies listeners, and **persists** the choice to `Preferences`.
- `loadPersisted()` restores the saved mode at startup (called from `Root.initState`).
- Static helpers: `read(context)`, `watch(context)`, and `theme(context)`.

### UserProvider

- Holds a nullable `token` and exposes `isLoggedIn`.
- `setToken(token)` stores it in memory and persists it; `load()` restores it from storage.
- `logout(context)` clears the token from both memory and storage.
- The token is injected automatically as `Authorization: Bearer <token>` by `HttpConnection`.
- Static helpers: `read(context)` and `watch(context)`.

## Registering a provider

Declare global providers in the `MultiProvider` in `main.dart` so they're available app-wide:

```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (context) => ThemeProvider(AppConfig.read(context).color)),
    ChangeNotifierProvider(create: (context) => UserProvider()),
    // ...add your global providers here
  ],
  builder: (context, child) => MaterialApp.router(/* ... */),
)
```

## Standardize access with `read` / `watch`

Every provider should expose static helpers so call sites stay short and consistent:

```dart
class UserProvider extends ChangeNotifier {
  static UserProvider read(BuildContext context) => context.read<UserProvider>();
  static UserProvider watch(BuildContext context) => context.watch<UserProvider>();
}
```

Use `read` for one-off actions (inside callbacks) and `watch` to rebuild when the value changes:

```dart
// Rebuild when the user changes:
final user = UserProvider.watch(context);
if (user.isLoggedIn) { /* ... */ }

// Update the theme from a callback (no rebuild needed here):
ThemeProvider.read(context).setThemeMode(ThemeMode.dark);
```

## Key notes

1. **Global scope only.** Everything here is reachable across the whole app.
2. **Centralized registration.** Declaring providers in `main.dart` keeps state management clear and consistent.
3. **Separation of concerns.** Keep local/widget-specific providers next to their widget, not in this folder.
