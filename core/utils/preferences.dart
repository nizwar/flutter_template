import 'package:flutter/material.dart';
import 'package:mobile_551/core/providers/userProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  final SharedPreferences shared;

  Preferences(this.shared);

  //Just an example!, write your own!
  ///You can simply write this!
  set token(String value) => shared.setString("token", value);

  ///Or something like this!
  void saveToken(String value) => shared.setString("token", value);

  //To get stored "token" data
  String get token => shared.getString("token");

  static logout(BuildContext context) {
    instance().then((value) {
      value.token = null;
      UserProvider.instance(context).token = null;
    });
  }

  static Future<Preferences> instance() =>
      SharedPreferences.getInstance().then((value) => Preferences(value));
}
