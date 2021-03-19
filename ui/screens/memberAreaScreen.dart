import 'package:flutter/material.dart';
import 'package:mobile_551/core/providers/userProvider.dart';
import 'package:mobile_551/ui/screens/loginScreen.dart';
import 'package:provider/provider.dart';

import 'browserScreen.dart';

class MemberAreaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, value, child) {
        if (value.token != null) {
          return BrowserScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
