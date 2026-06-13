import 'package:flutter/material.dart';

import 'themes.dart';

/// Centralised, theme-driven UI styles.
///
/// Keep reusable `InputDecoration`s, `TextStyle`s, and `BoxDecoration`s here so
/// the design language stays consistent. Everything is derived from the active
/// [ThemeData]/[ColorScheme] — never hardcode colors.
///
/// ```dart
/// TextField(decoration: AppStyles.inputDecoration(context, hint: 'Email'));
/// Container(decoration: AppStyles.cardDecoration(context));
/// ```
class AppStyles {
  const AppStyles._();

  /// Standard input decoration. Overrides the theme defaults only where needed.
  static InputDecoration inputDecoration(
    BuildContext context, {
    String? hint,
    String? label,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      labelText: label,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: theme(context).cardColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
    );
  }

  /// Rounded card decoration with a soft shadow, matching [CustomCard].
  static BoxDecoration cardDecoration(
    BuildContext context, {
    double radius = 10,
    Color? color,
  }) {
    return BoxDecoration(
      color: color ?? theme(context).cardColor,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [BoxShadow(blurRadius: 5, color: theme(context).shadowColor)],
    );
  }

  /// Pill-shaped decoration, e.g. for chips or tags.
  static BoxDecoration pillDecoration(BuildContext context, {Color? color}) {
    return BoxDecoration(
      color: color ?? colorScheme(context).primary.withValues(alpha: .12),
      borderRadius: BorderRadius.circular(100),
    );
  }

  /// Bold title text style derived from the theme.
  static TextStyle? title(BuildContext context) =>
      textTheme(context).titleMedium?.copyWith(fontWeight: FontWeight.bold);

  /// Muted secondary/caption text style.
  static TextStyle? caption(BuildContext context) => textTheme(context).bodySmall?.copyWith(
        color: textTheme(context).bodySmall?.color?.withValues(alpha: .6),
      );
}
