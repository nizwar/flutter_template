import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mojang_nontr/core/providers/main_screen_provider.dart';
import 'package:mojang_nontr/core/providers/user_provider.dart';
import 'package:mojang_nontr/ui/screens/auth/login_screen.dart';
import 'core/providers/penugasan_provider.dart';
import 'core/providers/theme_provider.dart';
import 'core/resources/environment.dart';
import 'core/resources/themes.dart';
import 'core/utils/app_config.dart';
// import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'ui/screens/main_screen.dart';
import 'ui/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(name: defaultFirebaseAppName, options: DefaultFirebaseOptions.currentPlatform);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(!kDebugMode);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  return runApp(AppConfig.builder(DevelopmentMode(), (context) => const Application()));
}

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider(AppConfig.read(context).color)),
        ChangeNotifierProvider(create: (context) => MainScreenProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => PenugasanProvider()),
      ],
      builder: (context, child) => MaterialApp(
        title: AppConfig.read(context).appName,
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
    Future.delayed(Duration.zero, () {
      UserProvider.initialize(context).then((value) {
        setState(() {
          _ready = true;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) {
      return Consumer<UserProvider>(builder: (context, user, child) {
        if (!user.isLoggedIn) {
          return LoginScreen();
        } else {
          return const MainScreen();
        }
      });
    } else {
      return const SplashScreen();
    }
  }
}
