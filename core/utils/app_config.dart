import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

abstract class AppConfig {
  final String endpoint;
  final String appName;
  final Color color;

  AppConfig({required this.endpoint, required this.appName, required this.color});

  static AppConfig read(BuildContext context) => context.read<AppConfig>();

  static builder(AppConfig appConfig, Widget Function(BuildContext context) builder) {
    return Provider(create: (_) => appConfig, builder: (context, child) => builder(context));
  }
}
