import 'package:flutter/material.dart';
import '../providers/theme_provider.dart';

/// A custom extension on [BuildContext] to provide custom theme provider.
ThemeData themeData(BuildContext context, Brightness brightness) {
  ThemeProvider provider = themeProvider(context);
  ColorScheme colorScheme = ColorScheme.fromSwatch(primarySwatch: provider.colorSwatch, brightness: brightness);
  ThemeData output = ThemeData(useMaterial3: true, primarySwatch: themeProvider(context).colorSwatch, brightness: brightness);
  Color scaffoldBackground = brightness == Brightness.light ? Colors.white : Colors.grey.shade900;

  return output.copyWith(
    primaryColor: colorScheme.primary,
    colorScheme: colorScheme.copyWith(onError: Colors.white),
    scaffoldBackgroundColor: scaffoldBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: output.textTheme.bodyMedium!.color,
      centerTitle: true,
      titleTextStyle: output.textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(0, 45),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: output.dividerColor)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: output.dividerColor)),
      suffixIconColor: output.dividerColor,
    ),
    buttonTheme: ButtonThemeData(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), buttonColor: colorScheme.primary),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: colorScheme.primary,
        side: BorderSide(color: colorScheme.primary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(shape: const RoundedRectangleBorder(), foregroundColor: colorScheme.onPrimary)),
  );
}

ThemeData theme(BuildContext context) => Theme.of(context);
TextTheme textTheme(BuildContext context) => Theme.of(context).textTheme;
ColorScheme colorScheme(BuildContext context) => Theme.of(context).colorScheme;
