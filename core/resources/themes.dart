import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/theme_provider.dart';

/// A custom extension on [BuildContext] to provide custom theme provider.
ThemeData themeData(BuildContext context, Brightness brightness) {
  ThemeProvider provider = themeProvider(context);
  ColorScheme colorScheme = ColorScheme.fromSwatch(primarySwatch: provider.colorSwatch, brightness: brightness);
  ThemeData output = ThemeData(useMaterial3: true, primarySwatch: themeProvider(context).colorSwatch, brightness: brightness);
  Color scaffoldBackground = brightness == Brightness.light ? Colors.white : Colors.grey.shade900;

  colorScheme = colorScheme.copyWith(
    shadow: Colors.grey.withValues(alpha: .5),
    onError: Colors.white,
    secondary: Colors.black,
    onSecondary: Colors.white,
    secondaryContainer: Colors.black,
    onSecondaryContainer: brightness == Brightness.light ? Colors.white : Colors.grey.shade300,
  );

  final Color dividerColor = brightness == Brightness.light ? Colors.grey.shade300 : Colors.grey.shade700;
  final inputBorder = OutlineInputBorder(
    borderSide: BorderSide(color: dividerColor, width: 1),
    borderRadius: BorderRadius.circular(10),
  );
  output = output.copyWith(
    textTheme: GoogleFonts.poppinsTextTheme(output.textTheme).apply(bodyColor: brightness == Brightness.light ? Colors.black : Colors.white),
    primaryTextTheme: GoogleFonts.poppinsTextTheme(output.primaryTextTheme).apply(bodyColor: brightness == Brightness.light ? Colors.black : Colors.white),
    iconTheme: output.iconTheme.copyWith(color: brightness == Brightness.light ? Colors.black : Colors.white),
    primaryIconTheme: output.primaryIconTheme.copyWith(color: brightness == Brightness.light ? Colors.black : Colors.white),
    sliderTheme: output.sliderTheme.copyWith(
      activeTrackColor: colorScheme.primary,
      inactiveTrackColor: colorScheme.primary.withValues(alpha: .3),
      thumbColor: colorScheme.primary,
      valueIndicatorColor: colorScheme.primary,
      inactiveTickMarkColor: dividerColor,
      activeTickMarkColor: colorScheme.primary,
    ),
  );
  return output.copyWith(
    primaryColor: colorScheme.primary,
    colorScheme: colorScheme.copyWith(),
    scaffoldBackgroundColor: scaffoldBackground,
    applyElevationOverlayColor: false,
    shadowColor: colorScheme.shadow,
    dividerColor: dividerColor,
    dividerTheme: DividerThemeData(color: dividerColor, space: 1, thickness: 1),
    popupMenuTheme: PopupMenuThemeData(
      color: brightness == Brightness.light ? Colors.white : Colors.grey.shade800,
      textStyle: output.textTheme.bodyMedium?.copyWith(color: output.textTheme.bodyMedium!.color),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    actionIconTheme: ActionIconThemeData(backButtonIconBuilder: (context) => Icon(CupertinoIcons.back, color: output.iconTheme.color)),
    cardColor: brightness == Brightness.light ? Colors.white : Colors.grey.shade800,
    listTileTheme: ListTileThemeData(
      iconColor: output.iconTheme.color,
      textColor: output.textTheme.bodyMedium!.color,
      contentPadding: EdgeInsets.zero,
      minTileHeight: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      titleTextStyle: output.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      subtitleTextStyle: output.textTheme.bodySmall,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.black,
      selectedItemColor: colorScheme.primary,
      unselectedItemColor: Colors.white,
      showSelectedLabels: false,
      showUnselectedLabels: false,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: output.textTheme.bodyMedium!.color,
      centerTitle: true,
      titleTextStyle: output.textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: brightness == Brightness.light ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(0, 45),
        elevation: 0,
        backgroundColor: colorScheme.secondary,
        foregroundColor: colorScheme.primary,
        textStyle: output.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      border: inputBorder,
      hintStyle: output.textTheme.bodyMedium?.copyWith(color: output.dividerColor),
      enabledBorder: inputBorder,
      labelStyle: output.textTheme.bodyMedium,
      focusedBorder: inputBorder.copyWith(borderSide: BorderSide(color: colorScheme.secondary, width: 2)),
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
