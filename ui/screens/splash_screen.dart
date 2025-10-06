import 'package:flutter/material.dart';

///Splash screen to show on root!
///Use this if you got something to do and make some delay or loading when app is open
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset("assets/icons/app_logo.png", width: 100, height: 100),
      ),
    );
  }
}
