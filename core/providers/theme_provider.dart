import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/utils.dart'; // re-exports preferences.dart (Preferences)

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  final Color _colorSwatch;

  /// The generated swatch is cached once instead of being recomputed on every
  /// theme rebuild (it was previously rebuilt each access via the getter).
  late final MaterialColor _materialColor = getMaterialColor(_colorSwatch);

  ThemeProvider(this._colorSwatch);

  MaterialColor get colorSwatch => _materialColor;

  /// Checks whether the current theme resolves to dark mode.
  ///
  /// Uses the resolved [Brightness] rather than [ThemeMode.dark] directly, so
  /// `ThemeMode.system` is handled correctly.
  bool isDarkMode(BuildContext context) => theme(context).brightness == Brightness.dark;

  /// Updates the theme mode, notifies listeners, and persists the choice.
  void setThemeMode(ThemeMode themeMode) {
    if (_themeMode == themeMode) return;
    _themeMode = themeMode;
    notifyListeners();
    // Fire-and-forget persistence; failures here must not break theming.
    Preferences.instance().then((p) => p.saveThemeModeIndex(themeMode.index)).catchError((_) => false);
  }

  /// Loads the persisted theme mode (if any) and applies it. Call once at
  /// startup, e.g. from `Root.initState`.
  Future<void> loadPersisted() async {
    final index = (await Preferences.instance()).themeModeIndex;
    if (index != null && index >= 0 && index < ThemeMode.values.length) {
      setThemeMode(ThemeMode.values[index]);
    }
  }

  static ThemeProvider read(BuildContext context) => context.read();
  static ThemeProvider watch(BuildContext context) => context.watch();
  static ThemeData theme(BuildContext context) => Theme.of(context);
}

ThemeProvider themeProvider(BuildContext context) => ThemeProvider.read(context);
