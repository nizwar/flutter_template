import 'package:shared_preferences/shared_preferences.dart';

/// A class that handles the application's preferences and settings.
/// 
/// This class provides methods to save, retrieve, and manage user preferences
/// and settings within the application. It acts as a wrapper around the 
/// underlying storage mechanism, making it easier to work with preferences.
/// 
/// Example usage:
///
/// ```dart
/// final prefs = await Preferences.instance();
/// prefs.token = 'abc123';          // setter (fire-and-forget)
/// await prefs.saveToken('abc123'); // awaitable alternative
/// final String? token = prefs.token;
/// ```
///
/// Note: Ensure that the preferences are properly initialized before using
/// any of the methods provided by this class.
class Preferences {
  static const _kToken = "token";
  static const _kThemeMode = "theme_mode";

  final SharedPreferences shared;

  Preferences(this.shared);

  /// The persisted auth token, or `null` if none is stored.
  ///
  /// Setting `null` removes the stored token instead of crashing.
  String? get token => shared.getString(_kToken);
  set token(String? value) =>
      value == null ? shared.remove(_kToken) : shared.setString(_kToken, value);

  /// Awaitable variant of the [token] setter. Returns once the write completes.
  Future<bool> saveToken(String token) => shared.setString(_kToken, token);

  /// The persisted theme mode index (see [ThemeMode.index]), or `null`.
  int? get themeModeIndex => shared.getInt(_kThemeMode);
  Future<bool> saveThemeModeIndex(int index) => shared.setInt(_kThemeMode, index);

  /// Removes the auth token (e.g. on logout).
  Future<bool> clearToken() => shared.remove(_kToken);

  /// Clears every stored preference.
  Future<bool> clear() => shared.clear();

  static Future<Preferences> instance() => SharedPreferences.getInstance().then((value) => Preferences(value));
}
