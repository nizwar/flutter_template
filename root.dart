import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'ui/screens/splash_screen.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  RootState createState() => RootState();
}

class RootState extends State<Root> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      ///TODO: Do your async task here like loading data from API, local storage, etc.
      ///After your task is complete, navigate to the main screen

      context.goNamed("home");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}
