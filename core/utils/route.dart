import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import '../../root.dart';
import '../../ui/screens/main_screen.dart';

GoRouter getRouter(BuildContext context) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(name: "root", path: '/', builder: (context, state) => Root()),
      GoRoute(name: "home", path: '/home', builder: (context, state) => MainScreen()),
    ],
  );
}
