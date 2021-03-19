import 'package:flutter/material.dart';
import 'package:mobile_551/core/utils/preferences.dart';
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
        theme: ThemeData.light().copyWith(
          primaryColor: primaryColor,
          scaffoldBackgroundColor: Colors.white,
          accentColor: accentColor,
        ),
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
  void initState() {
    Preferences.instance().then((value) {
      if (value.token != null)
        UserProvider.instance(context).token = value.token;

      setState(() {
        _ready = true;
      });
    }).timeout(Duration(seconds: 5));
    super.initState();
  }

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
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/logo-new.png",
          height: 200,
        ),
      ),
    );
  }
}
