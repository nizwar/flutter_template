import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/preferences.dart';

/// Global provider for the authenticated user/session.
///
/// Holds the auth token consumed by [HttpConnection] for the `Authorization`
/// header. Persist the token via [load]/[setToken] so it survives restarts.
class UserProvider extends ChangeNotifier {
  String? _token;

  String? get token => _token;
  set token(String? value) {
    _token = value;
    notifyListeners();
  }

  bool get isLoggedIn => _token != null && _token!.isNotEmpty;

  /// Loads the persisted token into memory (call at startup if you persist it).
  Future<void> load() async {
    _token = (await Preferences.instance()).token;
    notifyListeners();
  }

  /// Stores [token] in memory and persists it.
  Future<void> setToken(String token) async {
    _token = token;
    notifyListeners();
    await (await Preferences.instance()).saveToken(token);
  }

  /// Clears the in-memory and persisted token.
  static Future<void> logout(BuildContext context) async {
    final provider = read(context);
    provider.token = null;
    await (await Preferences.instance()).clearToken();
  }

  static UserProvider read(BuildContext context) => context.read();
  static UserProvider watch(BuildContext context) => context.watch();
}
