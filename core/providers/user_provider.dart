import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mojang_nontr/core/https/auth_http.dart';
import 'package:mojang_nontr/core/models/auth.dart';
import 'package:mojang_nontr/core/models/user.dart';
import 'package:mojang_nontr/core/utils/utils.dart';
import 'package:provider/provider.dart';

class UserProvider extends ChangeNotifier {
  Auth? _auth;
  User? _user;

  Auth? get auth => _auth;
  User get user => _user!;

  bool get isLoggedIn => _auth != null && _user != null;

  Position? _currentPosition;
  Position? get currentPosition => _currentPosition;

  static void logout(BuildContext context) {
    final provider = read(context);
    provider._auth = null;
    provider._user = null;
    provider.notifyListeners();
    Preferences.instance().then((value) {
      value.auth = null;
    });
  }

  static UserProvider read(BuildContext context) => context.read();
  static UserProvider watch(BuildContext context) => context.watch();

  static Future<User> refresh(context) async {
    final provider = read(context);
    getMyLocation().then((value) {
      provider._currentPosition = value?.$1;
      provider.notifyListeners();
    });
    return AuthHttp(context).getProfile().then((value) {
      provider._user = value;
      provider.notifyListeners();
      return value;
    });
  }

  static Future<bool> login(context, String nik, String password) {
    final provider = read(context);
    return AuthHttp(context).login(nik, password).then((value) {
      provider._auth = value;
      provider.notifyListeners();
      Preferences.instance().then((value) {
        value.auth = provider._auth;
      });
      return refresh(context).then((value) => true);
    });
  }

  static Future initialize(BuildContext context) async {
    final auth = await Preferences.instance().then((value) => value.auth);
    if (auth != null) {
      final provider = read(context);
      provider._auth = auth;
      provider.notifyListeners();
      return refresh(context);
    }
  }
}
