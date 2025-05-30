# Maxximum Flutter's Guidance

## BIG RULES

#### 1. Clean your warnings and clean your mind!
Do not use deprecated or unused imports, and avoid anything that clutters the warning list.

#### 2. Keep Updated
Spend 1-2 hours updating the project with the latest SDK, packages, and all. You might encounter some problems while doing it. Don't be silent... discuss them!

#### 3. Use Dev Tools like a Dev!
1. Watch your widget tree; don't make it like Rocket Science! Keep it clean and efficient.
2. Do not record network connections and print them on the Debug Console. Flutter has its own Dev Tools. Use them!
3. Monitor memory usage. You might need to compress some assets to avoid crashes due to memory overload. And yes, images with high resolution will crash the app.

#### 4. Use and Modify
You can modify the boilerplate as per application requirements, but ensure it remains in the same structure so all of us will be on the same page.

## Setup
Ensure everything is properly set up by using these recommended plugins!

### Required Packages
```yaml
  equatable: ^2.0.7
  dio: ^5.8.0+1
  provider: ^6.1.2
  shimmer: ^3.0.0
  cached_network_image: ^3.4.1
  shared_preferences: ^2.5.2
  ndialog: ^4.4.0
  pull_to_refresh_flutter3: ^2.0.2
  intl: ^0.20.2

  firebase_core: ^3.11.0
  firebase_analytics: ^11.4.2
  firebase_crashlytics: ^4.3.2
  firebase_performance: ^0.10.1
``` 

### Firebase Setup

Before running this command, ensure that you have updated the package name (for Android) and bundle ID (for iOS) to match your project.

Run the following command to initialize your Firebase project:

```sh 
flutterfire configure
```
### App Configuration

The `AppConfig` class is used to manage environment-specific configurations for the application. It includes properties such as the application name, API endpoint, and primary color. This allows for easy switching between different environments (e.g., development, production) without changing the core application code.

#### Example Usage:

```dart
import 'package:boilerplate/core/utils/app_config.dart';
import 'package:flutter/material.dart';

/// Development mode configuration.
class DevelopmentMode extends AppConfig {
  DevelopmentMode() : super(appName: 'App title', endpoint: 'https://api.dev.com', color: Colors.blue);
}

/// Production mode configuration.
class ProductionMode extends AppConfig {
  ProductionMode() : super(appName: 'App title', endpoint: 'https://api.prod.com', color: Colors.green);
}
```

You can easily switch the config by calling `AppConfig.switchConfig(context, YOUR_CONFIG)`

## Resources
The `lib/core/resources` directory contains various resources that are fundamental to the project. These include:
### Colors
Defines the color palette for the application. Centralizing colors here ensures consistency throughout the app and makes it easy to update or modify them as needed.
### Styles
Contains custom input box decorations, button styles, and other reusable UI components. This centralization simplifies maintaining a consistent design language across the application.
### Themes
Manages the application's themes, such as ThemeData for light and dark modes. It ensures seamless transitions between themes and makes it easier to implement global UI changes.

#### `USE THEME FEATURE, DO NOT HARDCODE THE COLORS` 
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

### Environment

Stores environment-specific data, such as API endpoints, configuration variables, or keys. This allows for easier management of environment-based settings (e.g., development, staging, production).

## State Management
State management is designed to optimize performance by preventing the unnecessary re-rendering of an entire screen when only a single widget needs to be updated.

While the choice of state management approach is up to you, most projects commonly use Provider or BLoC. Regardless of the method you choose, ensure it is implemented correctly to maximize efficiency and maintainability.

#### Standardize Access with Read and Watch
No matter what state management solution you use, ensure you create quick and consistent ways to access your state management. Achieve this by adding Read and Watch static functions to every provider or state management class.

For detailed explanations and examples, refer to the `core/providers/readme.md` file.

### Provider
#### Where to put them
There are two ways to organize your providers. To maintain an optimized and well-managed file structure, we categorize them into two types:

##### 1. Global Provider
Global providers are used for managing data or state that needs to be accessed across the entire project.

Example:

1. `UserProvider`: Manages user-related data, such as authentication status, and makes it accessible throughout the app.
2. `ThemeProvider`: Allows you to manage themes, such as changing the ThemeMode or ColorSeed. When updated, the entire UI will automatically reflect the changes.

Storage Location: `lib/core/providers/`

##### 2. Local Provider
Local providers are used specifically within the widget you're currently working on.

Example: Screen with a Form
Local providers can be implemented in two ways:

* `Single Provider`: Store the provider in the same file as the widget.
* `Multiple Providers`: Create a providers folder at the same directory level as the widget and store the relevant providers there.

### BLoC
The BLoC (Business Logic Component) pattern separates the application's business logic from its UI, making it more maintainable and testable. It uses Streams to manage state and ensures a reactive, event-driven architecture.

#### Where to Put Them

Refer to the Provider's Description for guidance on where to place BLoC files. Similar to Providers, BLoC files can be categorized as either Global or Local, depending on their scope and usage.

#### 1. Global BLoC
Used for state and logic that needs to be shared across the entire application.
Typically stored in `lib/core/bloc/`.
Example: AuthBloc or ThemeBloc to manage authentication or theming across the app.

#### 2. Local BLoC
Used for state and logic specific to a particular screen or widget.
Stored in the same file as the widget or in a dedicated bloc folder at the same level as the widget.

Example: `FormBloc` for managing a specific form's state.

## Widget Utilities
Simplify your works with these Widgets

### Custom Dividers
Utilize `ColumnDivider` and `RowDivider` to create spacing between widgets. The default spacing is set to 10, but you can modify it in `ui/components/custom_divider.dart`.

### Shimmer Effects
Our shimmer utilities include `ShimmerObject`, `ShimmeringObject`, and `ShimmerContainer`. 
 
### Custom Image
The `CustomImage` widget simplifies the process of displaying images using `cached_network_image`. It provides an easy and efficient solution for handling images.

### Custom Card
Need enhanced shadow effects compared to the default Card widget? Use CustomCard for a more visually appealing result.

### Paginator Page
The Paginator Page widget provides a quick and efficient way to implement paginated lists in your application. It simplifies handling pagination with minimal configuration and allows seamless integration with API responses. 

## Function & Utilities
### HttpConnection
HttpConnection is an abstract class that simplifies HTTP communication. Extend this class to utilize its features. Here’s a quick example:

```dart
    class UserHttp extends HttpConnection{
        // The context is passed to the HttpConnection constructor,
        // providers, or any data that require context to access.
        UserHttp(BuildContext context) : super(context);

        // Example: Login function
        Future<User> login({String username, String password}) async {
            // The 'post' method is inherited from HttpConnection
            var resp = await post<ApiResponse>(endpoint + "/login", body:{"username": username, "password": password});

            // ApiResponse is a custom model defined in https/httpConnection.dart.
            // Example API response:
            // {
            //   success: true,
            //   message: "Success",
            //   data: {"name": "nizwar", ...},
            // }
            
            if(resp.success) return User.fromJson(resp.data);            
            return null;
        }
    }
```

### Preferences
The `Preferences` class simplifies the management of SharedPreferences.

```dart
    Future initData() async {
        Preferences pref = await Preferences.instance();

        // Save a token
        pref.token = "XXXX";

        // Alternatively, use a dedicated save function
        pref.saveToken("XXXX");

        // Retrieve the token
        String token = pref.token;
    }
```

### Navigations
Simplify navigation with the following functions:

* `startScreen(context, YourScreen())` : Open a new screen.
* `replaceScreen(context, YourScreen())` : Replace the current screen with a new one.
* `closeScreen(context)` : Close the current screen.

```dart
    startScreen(context, YourScreen());
    replaceScreen(context, YourScreen());
    closeScreen(context);
```