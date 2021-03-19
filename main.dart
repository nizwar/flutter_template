import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/providers/userProvider.dart';
import 'core/resources/myColors.dart';
import 'ui/screens/mainScreen.dart';

main() {
  return runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Root(),
      ),
    ),
  );
}

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  bool _ready = false;

  @override
  Widget build(BuildContext context) {
    return _ready ? MainScreen() : SplashScreen();
  }
}

///Splash screen to show on root!
///Use this if you got something to do and make some delay or loading when app is open
class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
