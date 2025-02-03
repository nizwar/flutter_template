import 'package:boilerplate/core/utils/app_config.dart';
import 'package:flutter/material.dart';

/// Development mode configuration.
class DevelopmentMode extends AppConfig {
  /// Creates a new instance of [DevelopmentMode].
  DevelopmentMode() : super(appName: 'App title', endpoint: 'https://api.dev.com', color: Colors.blue);
}

/// Production mode configuration.
class ProductionMode extends AppConfig {
  /// Creates a new instance of [ProductionMode].
  ProductionMode() : super(appName: 'App title', endpoint: 'https://api.prod.com', color: Colors.green);
}
