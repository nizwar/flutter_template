import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../resources/colors.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  ///TODO: Change color here
  MaterialColor get colorSwatch => getMaterialColor(primaryColor);

  bool isDarkMode(BuildContext context) => theme(context).brightness == Brightness.dark;

  void setThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }

  static ThemeProvider read(BuildContext context) => context.read();
  static ThemeProvider watch(BuildContext context) => context.watch();
  static ThemeData theme(BuildContext context) => Theme.of(context);
}

ThemeProvider themeProvider(context) => ThemeProvider.read(context);
