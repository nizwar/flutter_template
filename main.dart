import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/providers/globals/user_provider.dart';
import 'ui/screens/main_screen.dart';

main() {
  return runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Root(),
      ),
    ),
  );
}

class Root extends StatefulWidget {
  const Root({Key? key}) : super(key: key);

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  bool _ready = false;

  @override
  void initState() {
    // TODO: Do something to make _ready true
    _ready = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _ready ? const MainScreen() : const SplashScreen();
  }
}

///Splash screen to show on root!
///Use this if you got something to do and make some delay or loading when app is open
class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
