
# Resources 
The `lib/core/resources` directory contains various resources that are fundamental to the project. These include:
## Colors
Defines the color palette for the application. Centralizing colors here ensures consistency throughout the app and makes it easy to update or modify them as needed.
## Styles
Contains custom input box decorations, button styles, and other reusable UI components. This centralization simplifies maintaining a consistent design language across the application.
## Themes
Manages the application's themes, such as ThemeData for light and dark modes. It ensures seamless transitions between themes and makes it easier to implement global UI changes.

### `USE THEME FEATURE, DO NOT HARDCODE THE COLORS` 
Avoid hardcoding colors in your widgets. Instead, leverage the theme's ColorScheme or ThemeData to ensure consistency and adaptability across the application.

To simplify access to theme-related properties, the following utility functions are provided:

* Retrieves the current ThemeData for the application
```dart 
ThemeData currentTheme = theme(context);
 ```
* Fetches the TextTheme from the current theme, enabling easy styling for text elements. 
```dart
TextTheme currentTextTheme = textTheme(context);
```
* Accesses the ColorScheme from the current theme
```dart 
ColorScheme currentColorScheme = colorScheme(context);
 ```

## Environment

Stores environment-specific data, such as API endpoints, configuration variables, or keys. This allows for easier management of environment-based settings (e.g., development, staging, production).