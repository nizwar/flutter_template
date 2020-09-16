import 'package:flutter/material.dart';
import 'ui/screens/mainScreen.dart';

main() {}

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  //If you got something todo before mainscreen appear
  //e.g loadUserData or check if user already loged in

  @override
  Widget build(BuildContext context) {
    return MainScreen();
  }
}


///Splash screen to show on root!
///Use this if you got something to do and make some delay or loading when app is open
class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}
