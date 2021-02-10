import 'package:flutter/material.dart';

Future<T> startScreen<T>(BuildContext context, Widget screen) => Navigator.push<T>(context, MaterialPageRoute(builder: (context) => screen));
Future<T> replaceScreen<T, TO>(BuildContext context, Widget screen) => Navigator.pushReplacement<T, TO>(context, MaterialPageRoute(builder: (context) => screen));

void closeScreen<T>(BuildContext context, [T value]) => Navigator.pop<T>(context, value);
