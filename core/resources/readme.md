# Resources

The `lib/core/resources` directory holds the project's foundational design and configuration assets: colors, themes, shared styles, and environment config.

## `USE THE THEME, DO NOT HARDCODE COLORS`

Never hardcode colors in widgets. Always derive them from the active `ColorScheme`/`ThemeData` so light/dark mode and theme swaps work everywhere.

## AI Instructions (Resources)

1. Use the `theme(context)`, `textTheme(context)`, and `colorScheme(context)` helpers.
2. Never introduce hardcoded colors in the UI layer.
3. Put reusable styles in `styles.dart` (`AppStyles`) instead of duplicating them.
4. Add new colors to the `CustomColors` extension in `colors.dart` only when needed.

## What's inside (from code)

### colors.dart
- `CustomColors` extension on `ThemeData`.
- Provides `colorRedPrimary`, `shadowColor`, and `background` with light/dark variants.
- Access via `theme(context).background`, etc.

### themes.dart
- `themeData(context, brightness)` builds a Material 3 theme from the `ThemeProvider` swatch.
- Customizes the app bar, buttons, and input decoration defaults.
- Top-level helpers: `theme(context)`, `textTheme(context)`, `colorScheme(context)`.

### styles.dart
- `AppStyles` — a small library of theme-driven, reusable styles:
  - `AppStyles.inputDecoration(context, hint: ..., label: ...)`
  - `AppStyles.cardDecoration(context)` / `AppStyles.pillDecoration(context)`
  - `AppStyles.title(context)` / `AppStyles.caption(context)`
- Add new shared `InputDecoration`/`BoxDecoration`/`TextStyle` helpers here rather than inline.

### environment.dart
- `DevelopmentMode` and `ProductionMode` extend `AppConfig` with their own `endpoint`, `appName`, and `color`.
- Swap at runtime with `AppConfig.switchConfig(context, ProductionMode())`.
- Endpoints are currently hardcoded here — consider `--dart-define` (`String.fromEnvironment`) for secrets so they aren't committed.

## Theme helpers

```dart
ThemeData   currentTheme       = theme(context);
TextTheme   currentTextTheme   = textTheme(context);
ColorScheme currentColorScheme = colorScheme(context);
```

## Example usage

```dart
TextField(decoration: AppStyles.inputDecoration(context, hint: 'Email'));

Container(
  decoration: AppStyles.cardDecoration(context),
  child: Text('Hello', style: AppStyles.title(context)),
);
```

## Environment

`AppConfig` carries environment-specific data (API endpoint, app name, theme color). Use subclasses (`DevelopmentMode`, `ProductionMode`, or your own `StagingMode`) to manage settings per environment, and read the active one with `AppConfig.read(context)`.
