# Screens

A screen is a full page shown to the user. Every screen starts from a `Scaffold`, which provides the structure for app bars, drawers, floating action buttons, and body content.

## AI Instructions (Screens)

1. Always start from `Scaffold` and keep the widget tree shallow.
2. Style with `theme(context)`, `textTheme(context)`, and `colorScheme(context)` — never hardcode.
3. Reuse components from `lib/ui/components` before building new widgets.
4. Keep screens small; extract sub-widgets (private `_Foo` widgets) for clarity and reuse.
5. Handle API errors in the widget layer and render friendly empty/error/loading states.

## App entry flow

- `main.dart` initializes Firebase/Crashlytics and wraps the app in `MultiProvider` + `MaterialApp.router`.
- `root.dart` (`Root`) is the initial route (`/`): it runs startup work in a post-frame callback (e.g. restoring the persisted theme), then navigates with `context.goNamed("home")`.
- `SplashScreen` is shown by `Root` during that startup work — replace its placeholder content with your branding.
- `MainScreen` is the `home` route; build your first real screen here.

## Recommended structure

```dart
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(
        child: SingleChildScrollView( // only when content can overflow
          padding: const EdgeInsets.all(16),
          child: Column(
            children: const [_Header(), ColumnDivider(space: 16), _Details()],
          ),
        ),
      ),
    );
  }
}
```

- `Scaffold` → `SafeArea` → (`SingleChildScrollView` when needed) → content split into private widgets.

## Adding a screen

1. Create the screen widget in `lib/ui/screens/`.
2. Register a `GoRoute` for it in `core/utils/route.dart`.
3. Navigate to it with `context.pushNamed("yourRoute")` / `context.goNamed("yourRoute")`.

## State management

Prefer Provider for screen-level state. Keep local providers inside the screen's folder when the state isn't global; promote to `core/providers/` only when it's truly app-wide.

## Anti-patterns to avoid

- Hardcoded colors or text styles.
- Network calls directly inside `build()`.
- Huge `build` methods with no sub-widget extraction.
