import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'core/providers/theme_provider.dart';
import 'core/providers/user_provider.dart';
import 'core/resources/environment.dart';
import 'core/resources/themes.dart';
import 'core/utils/app_config.dart';
import 'core/utils/route.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'ui/screens/main_screen.dart';
import 'ui/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(name: defaultFirebaseAppName, options: DefaultFirebaseOptions.currentPlatform);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(!kDebugMode);
  return runApp(AppConfig.builder(DevelopmentMode(), (context) => const Application()));
}

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ///TODO: Add your global providers here
        ChangeNotifierProvider(create: (context) => ThemeProvider(AppConfig.read(context).color)),
        ChangeNotifierProvider(create: (context) => UserProvider()),

        Provider(create: (context) => getRouter(context), dispose: (_, router) => router.dispose()),
      ],
      builder: (context, child) => MaterialApp.router(
        routerConfig: context.read<GoRouter>(),
        title: AppConfig.read(context).appName,
        themeMode: context.watch<ThemeProvider>().themeMode,
        debugShowCheckedModeBanner: false,
        theme: themeData(context, Brightness.light),
        darkTheme: themeData(context, Brightness.dark),
      ),
    );
  }
}
