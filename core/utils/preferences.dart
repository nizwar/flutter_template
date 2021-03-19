import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  final SharedPreferences shared;

  Preferences(this.shared);

  //Just an example!, write your own!
  ///You can simply write this!
  set token(String? value) => shared.setString("token", value);

  //To get stored "token" data
  String? get token => shared.getString("token");

  static Future<Preferences> instance() => SharedPreferences.getInstance().then((value) => Preferences(value));
}
