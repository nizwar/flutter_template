import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'core/providers/theme_provider.dart';
import 'core/resources/themes.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'core/providers/user_provider.dart';
import 'ui/screens/main_screen.dart';
import 'ui/screens/splash_screen.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: defaultFirebaseAppName,
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(!kDebugMode);

  return runApp(const Application());
}

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      builder: (context, child) => MaterialApp(
        title: 'App title',
        themeMode: context.watch<ThemeProvider>().themeMode,
        debugShowCheckedModeBanner: false,
        theme: themeData(context, Brightness.light),
        darkTheme: themeData(context, Brightness.dark),
        home: const Root(),
      ),
    );
  }
}

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  RootState createState() => RootState();
}

class RootState extends State<Root> {
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
