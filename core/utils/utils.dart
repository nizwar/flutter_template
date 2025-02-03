import 'dart:math';

import 'package:flutter/material.dart';

export 'navigations.dart';
export 'preferences.dart';

/// Converts a [Color] to a [MaterialColor].
///
/// This function takes a [Color] object and generates a [MaterialColor]
/// object from it. A [MaterialColor] is a color swatch that includes
/// different shades of the primary color.
///
/// - Parameter color: The [Color] to convert to a [MaterialColor].
///
/// - Returns: A [MaterialColor] object that represents the given [Color].
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

/// Returns the size of the media in the given [BuildContext].
///
/// This function uses the [MediaQuery] widget to obtain the size of the 
/// screen or parent widget in the provided [context].
///
/// Example usage:
/// ```dart
/// Size screenSize = size(context);
/// ```
///
/// - Parameter context: The [BuildContext] from which to obtain the media size.
/// - Returns: A [Size] object representing the width and height of the media.
Size size(BuildContext context) => MediaQuery.of(context).size;

/// Generates a random string of the specified length.
///
/// The generated string will contain a mix of uppercase and lowercase
/// letters, as well as digits.
///
/// [length] specifies the length of the generated string. It must be a
/// positive integer.
///
/// Returns a random string of the specified length.
///
/// Example:
/// ```dart
/// String result = randomString(10);
/// print(result); // Output: a random string of 10 characters
/// ```
String randomString(int length) {
  const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random rnd = Random();
  return String.fromCharCodes(Iterable.generate(length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
}
