import 'package:flutter/material.dart';

///Build your own colors here!
///
///
/// A custom extension on [ThemeData] to provide custom color schemes.
///
/// as colorRedPrimary declared in the extension, you can call it in the code like this:
/// ```dart
/// theme(context).colorRedPrimary
/// ```
extension CustomColors on ThemeData {
  ///Example of a custom color scheme,
  ///You can add more custom color schemes here.
  ///
  ///Use brightness to determine the color scheme.
  Color get colorRedPrimary => brightness == Brightness.light ? const Color(0xFFD32F2F) : const Color(0xFFB71C1C);

  Color get shadowColor => Colors.black.withValues(alpha: .05);
  Color get background => brightness == Brightness.light ? Color(0xffF5F6FA) : Color(0xff202020);
}
