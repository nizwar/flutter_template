import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProvider extends ChangeNotifier {
  String? _token;

  String? get token => _token;
  set token(String? value) {
    _token = value;
    notifyListeners();
  }

  static void logout(BuildContext context) {
    ///Do some logout here
  }

  static UserProvider of(BuildContext context) => context.read();
}
