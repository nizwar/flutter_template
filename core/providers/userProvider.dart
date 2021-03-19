import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProvider extends ChangeNotifier {
  String? _token;

  String? get token => _token;
  set token(String? value) {
    _token = value;
    notifyListeners();
  }

  static UserProvider instance(BuildContext context) => Provider.of(context, listen: false);
}
