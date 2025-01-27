import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/utils.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  final Color _colorSwatch;

  ThemeProvider(this._colorSwatch);

  MaterialColor get colorSwatch => getMaterialColor(_colorSwatch);

  ///Check if the current theme is dark mode
  ///
  ///Instead of ThemeMode.dark we use the brightness of the theme instead, because when the theme mode is system
  ///and the brightness can be dark.
  bool isDarkMode(BuildContext context) => theme(context).brightness == Brightness.dark;

  ///Get the current theme
  void setThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }

  static ThemeProvider read(BuildContext context) => context.read();
  static ThemeProvider watch(BuildContext context) => context.watch();
  static ThemeData theme(BuildContext context) => Theme.of(context);
}

ThemeProvider themeProvider(context) => ThemeProvider.read(context);
