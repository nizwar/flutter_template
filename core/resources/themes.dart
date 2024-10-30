import 'package:flutter/material.dart';
import 'colors.dart';

ThemeData get lightThemeData => ThemeData.light().copyWith(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: lightBackground,
      textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(shape: const RoundedRectangleBorder(), foregroundColor: ThemeData.light().textTheme.labelLarge!.color)),
    );

ThemeData get darkThemeData => ThemeData.dark().copyWith(
      primaryColor: darkPrimaryColor,
      textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(shape: const RoundedRectangleBorder(), foregroundColor: ThemeData.dark().textTheme.labelLarge!.color)),
      scaffoldBackgroundColor: darkBackground,
    );

ThemeData theme(BuildContext context) => Theme.of(context);
TextTheme textTheme(BuildContext context) => Theme.of(context).textTheme;
ColorScheme colorScheme(BuildContext context) => Theme.of(context).colorScheme;
