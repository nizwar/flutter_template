import 'package:flutter/material.dart';

import '../utils/app_config.dart';

/// Development mode configuration.
class DevelopmentMode extends AppConfig {
  /// Creates a new instance of [DevelopmentMode].
  DevelopmentMode() : super(appName: 'Mojang Non-TR DEV', endpoint: 'https://dev-ujang.artristik.co.id/non-tr/api', color: Color(0xffFFFF00));
}

/// Production mode configuration.
class ProductionMode extends AppConfig {
  /// Creates a new instance of [ProductionMode].
  ProductionMode() : super(appName: 'Mojang Non-TR', endpoint: 'https://api.prod.com', color: Color(0xffFFFF00));
}
