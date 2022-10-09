import 'package:flutter/material.dart';
import 'colors.dart';

ThemeData get lightThemeData => ThemeData.light().copyWith(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: lightBackground,
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: const RoundedRectangleBorder(),
          foregroundColor: ThemeData.light().textTheme.button!.color,
        ),
      ),
      colorScheme: const ColorScheme.light().copyWith(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: Colors.white,
      ),
    );

ThemeData get darkThemeData => ThemeData.dark().copyWith(
      primaryColor: darkPrimaryColor,
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: const RoundedRectangleBorder(),
          foregroundColor: ThemeData.dark().textTheme.button!.color,
        ),
      ),
      scaffoldBackgroundColor: darkBackground,
      colorScheme: const ColorScheme.light().copyWith(
        primary: darkPrimaryColor,
        secondary: secondaryColor,
        surface: Colors.grey.shade800,
      ),
    );
