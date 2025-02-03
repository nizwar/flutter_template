import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// An abstract class that represents the configuration of the application.
///
/// This class extends [ChangeNotifier] to allow listening to changes in the configuration.
///
/// Properties:
/// - `endpoint`: The API endpoint for the application.
/// - `appName`: The name of the application.
/// - `color`: The primary color of the application.
///
/// Constructor:
/// - `AppConfig({required this.endpoint, required this.appName, required this.color})`:
///   Initializes the configuration with the given endpoint, app name, and color.
///
/// Methods:
/// - `static AppConfig read(BuildContext context)`: Reads the current [AppConfig] from the given [BuildContext].
/// - `static builder(AppConfig appConfig, Widget Function(BuildContext context) builder)`:
///   A builder method that provides the [AppConfig] to the widget tree using [ChangeNotifierProvider].
/// - `static switchConfig(BuildContext context, AppConfig config)`:
///   Switches the current configuration to the new [AppConfig] and notifies listeners.
abstract class AppConfig extends ChangeNotifier {
  late String endpoint;
  late String appName;
  late Color color;

  /// Creates a new instance of [AppConfig].
  AppConfig({required this.endpoint, required this.appName, required this.color});

  /// Reads the current [AppConfig] from the given [BuildContext].
  static AppConfig read(BuildContext context) => context.read<AppConfig>();

  /// A builder method that provides the [AppConfig] to the widget tree using [ChangeNotifierProvider].
  static builder(AppConfig appConfig, Widget Function(BuildContext context) builder) {
    return ChangeNotifierProvider(create: (_) => appConfig, builder: (context, child) => builder(context));
  }

  /// Switches the current configuration to the new [AppConfig] and notifies listeners.
  static switchConfig(BuildContext context, AppConfig config) {
    var config = context.read<AppConfig>();
    config.endpoint = config.endpoint;
    config.appName = config.appName;
    config.color = config.color;
    config.notifyListeners();
  }
}
