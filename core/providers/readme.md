# Providers
Providers stored here are strictly for global variables—data that needs to be accessible throughout the entire application. These providers are useful for managing application-wide states, such as user data, theme settings, or any shared resources.

## Implementation:
All global provider declarations should be added inside the main.dart file, ensuring that they are available across the app. This makes the data easily accessible from any part of the application without the need to redeclare or duplicate the logic.

### Simplifying Provider Access:
To streamline access to providers, include static methods (`read` and `watch`) within each provider. This makes it easier to retrieve or listen to provider values without redundant code.

```dart
// Static methods for simplified access
static UserProvider read(BuildContext context) => context.read<UserProvider>();
static UserProvider watch(BuildContext context) => context.watch<UserProvider>();
```

Global Provider Declaration in main.dart:
```dart
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: MyApp(),
    ),
  );
}
```

Accessing the Provider Anywhere in the App:
```dart
// Example of reading the user data
final userProvider = UserProvider.watch(context);
print(userProvider.userName);

// Example of updating the theme
final themeProvider = ThemeProvider.read(context);
themeProvider.toggleDarkMode();
```

## Key Notes:
1. Global Scope: Providers declared here are accessible across the entire application.
2. Centralized Declaration: Declaring providers in main.dart ensures clarity and consistency in managing global states.
3. Separation of Concerns: Avoid using this section for local or widget-specific providers. Use local providers only where needed for specific widgets or screens.

By following this approach, you ensure that your app's state management remains well-organized and scalable.