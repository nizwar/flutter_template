import 'dart:math';

import 'package:flutter/material.dart';

export 'navigations.dart';
export 'preferences.dart';

MaterialColor getMaterialColor(Color color) {
  int float(double number) {
    return (number * 255).round();
  }

  final int red = float(color.r);
  final int green = float(color.g);
  final int blue = float(color.b);

  // Function to lighten or darken color
  Color adjustBrightness(Color color, double factor) {
    int r = (float(color.r) * factor).clamp(0, 255).toInt();
    int g = (float(color.g) * factor).clamp(0, 255).toInt();
    int b = (float(color.b) * factor).clamp(0, 255).toInt();
    return Color.fromRGBO(r, g, b, 1);
  }

  final Map<int, Color> shades = {
    50: adjustBrightness(color, 1.2), // Lighter shade
    100: adjustBrightness(color, 1.1),
    200: adjustBrightness(color, 1.05),
    300: color, // Base color
    400: adjustBrightness(color, 0.95),
    500: adjustBrightness(color, 0.9),
    600: adjustBrightness(color, 0.85),
    700: adjustBrightness(color, 0.8), // Darker shade
    800: adjustBrightness(color, 0.75),
    900: adjustBrightness(color, 0.7),
  };

  int colorInt = (255 << 24) | (red << 16) | (green << 8) | blue;
  return MaterialColor(colorInt, shades);
}

Size size(BuildContext context) => MediaQuery.of(context).size;

String randomString(int length) {
  const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random rnd = Random();
  return String.fromCharCodes(Iterable.generate(length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
}
