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
/// Preferences prefs = await Preferences.instance();
/// prefs.token = 'abc123';
/// String username = prefs.token;
/// ```
/// 
/// Note: Ensure that the preferences are properly initialized before using
/// any of the methods provided by this class.
class Preferences {
  final SharedPreferences shared;

  Preferences(this.shared);

  set token(String? value) => shared.setString("token", value!);

  String? get token => shared.getString("token");

  static Future<Preferences> instance() => SharedPreferences.getInstance().then((value) => Preferences(value));
}
