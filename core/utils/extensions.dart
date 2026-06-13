import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ndialog/ndialog.dart';

import '../../ui/components/adaptive_progress_indicator.dart';
import '../../ui/components/custom_card.dart';

extension WidgetExtensions on Widget {
  /// A widget that dismisses the keyboard when tapped.
  ///
  /// Wrap other widgets to hide the keyboard when the user taps outside of a
  /// text field — useful on forms with multiple inputs.
  ///
  /// ```dart
  /// anyWidget.dismissKeyboardOnTap(context);
  /// ```
  Widget dismissKeyboardOnTap(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: this,
    );
  }
}

extension FutureProgressDialog<T> on Future<T> {
  /// Displays a custom progress dialog while this future is pending.
  ///
  /// Returns the future's value, or `null` when the dialog is dismissed.
  Future<T?> showProgress(BuildContext context) => showCustomProgressDialog(
        context,
        loadingWidget: CustomCard(
          padding: const EdgeInsets.all(15),
          child: const AdaptiveProgressIndicator(),
        ),
      );
}

/// Locale-aware [DateTime] formatting helpers built on `intl`'s [DateFormat].
///
/// Each method accepts a [BuildContext] (used to resolve the active locale via
/// [Localizations]) and an optional [locale] override as an ICU locale string
/// such as `"id_ID"` or `"en_US"`. When neither is available, `intl` falls back
/// to its default locale.
///
/// ```dart
/// DateTime.now().yMMMMd(context);            // uses app locale
/// DateTime.now().yMMMMd(context, locale: 'id'); // forces Indonesian
/// ```
extension DateTimeExtensions on DateTime {
  String _loc(BuildContext context, String? locale) =>
      locale ?? Localizations.maybeLocaleOf(context)?.toString() ?? Intl.getCurrentLocale();

  /// Day of the month (1-31).
  String d(BuildContext context, {String? locale}) => DateFormat.d(_loc(context, locale)).format(this);

  /// Abbreviated day of the week (Mon, Tue, ...).
  String E(BuildContext context, {String? locale}) => DateFormat.E(_loc(context, locale)).format(this);

  /// Full day of the week (Monday, Tuesday, ...).
  // ignore: non_constant_identifier_names
  String EEEE(BuildContext context, {String? locale}) => DateFormat.EEEE(_loc(context, locale)).format(this);

  /// Narrow day of the week (M, T, ...).
  // ignore: non_constant_identifier_names
  String EEEEE(BuildContext context, {String? locale}) => DateFormat.EEEEE(_loc(context, locale)).format(this);

  /// Abbreviated month (Jan, Feb, ...).
  // ignore: non_constant_identifier_names
  String LLL(BuildContext context, {String? locale}) => DateFormat.LLL(_loc(context, locale)).format(this);

  /// Full month (January, February, ...).
  // ignore: non_constant_identifier_names
  String LLLL(BuildContext context, {String? locale}) => DateFormat.LLLL(_loc(context, locale)).format(this);

  /// Numeric month (1-12).
  String M(BuildContext context, {String? locale}) => DateFormat.M(_loc(context, locale)).format(this);

  /// Numeric month and day.
  // ignore: non_constant_identifier_names
  String Md(BuildContext context, {String? locale}) => DateFormat.Md(_loc(context, locale)).format(this);

  /// Abbreviated weekday, numeric month and day.
  // ignore: non_constant_identifier_names
  String MEd(BuildContext context, {String? locale}) => DateFormat.MEd(_loc(context, locale)).format(this);

  /// Abbreviated month and day.
  // ignore: non_constant_identifier_names
  String MMM(BuildContext context, {String? locale}) => DateFormat.MMM(_loc(context, locale)).format(this);

  /// Abbreviated month and day.
  // ignore: non_constant_identifier_names
  String MMMd(BuildContext context, {String? locale}) => DateFormat.MMMd(_loc(context, locale)).format(this);

  /// Abbreviated weekday, month and day.
  // ignore: non_constant_identifier_names
  String MMMEd(BuildContext context, {String? locale}) => DateFormat.MMMEd(_loc(context, locale)).format(this);

  /// Full month.
  // ignore: non_constant_identifier_names
  String MMMM(BuildContext context, {String? locale}) => DateFormat.MMMM(_loc(context, locale)).format(this);

  /// Full month and day.
  // ignore: non_constant_identifier_names
  String MMMMd(BuildContext context, {String? locale}) => DateFormat.MMMMd(_loc(context, locale)).format(this);

  /// Full weekday, month and day.
  // ignore: non_constant_identifier_names
  String MMMMEEEEd(BuildContext context, {String? locale}) => DateFormat.MMMMEEEEd(_loc(context, locale)).format(this);

  /// Abbreviated quarter (Q1, Q2, ...).
  // ignore: non_constant_identifier_names
  String QQQ(BuildContext context, {String? locale}) => DateFormat.QQQ(_loc(context, locale)).format(this);

  /// Full quarter (1st quarter, ...).
  // ignore: non_constant_identifier_names
  String QQQQ(BuildContext context, {String? locale}) => DateFormat.QQQQ(_loc(context, locale)).format(this);

  /// Numeric year.
  String y(BuildContext context, {String? locale}) => DateFormat.y(_loc(context, locale)).format(this);

  /// Numeric year and month.
  // ignore: non_constant_identifier_names
  String yM(BuildContext context, {String? locale}) => DateFormat.yM(_loc(context, locale)).format(this);

  /// Numeric year, month and day.
  // ignore: non_constant_identifier_names
  String yMd(BuildContext context, {String? locale}) => DateFormat.yMd(_loc(context, locale)).format(this);

  /// Abbreviated weekday, numeric year, month and day.
  // ignore: non_constant_identifier_names
  String yMEd(BuildContext context, {String? locale}) => DateFormat.yMEd(_loc(context, locale)).format(this);

  /// Abbreviated year, month and day.
  // ignore: non_constant_identifier_names
  String yMMM(BuildContext context, {String? locale}) => DateFormat.yMMM(_loc(context, locale)).format(this);

  /// Abbreviated year, month and day.
  // ignore: non_constant_identifier_names
  String yMMMd(BuildContext context, {String? locale}) => DateFormat.yMMMd(_loc(context, locale)).format(this);

  /// Abbreviated weekday, year, month and day.
  // ignore: non_constant_identifier_names
  String yMMMEd(BuildContext context, {String? locale}) => DateFormat.yMMMEd(_loc(context, locale)).format(this);

  /// Full year and month.
  // ignore: non_constant_identifier_names
  String yMMMM(BuildContext context, {String? locale}) => DateFormat.yMMMM(_loc(context, locale)).format(this);

  /// Full year, month and day.
  // ignore: non_constant_identifier_names
  String yMMMMd(BuildContext context, {String? locale}) => DateFormat.yMMMMd(_loc(context, locale)).format(this);

  /// Full weekday, year, month and day.
  // ignore: non_constant_identifier_names
  String yMMMMEEEEd(BuildContext context, {String? locale}) => DateFormat.yMMMMEEEEd(_loc(context, locale)).format(this);

  /// Abbreviated year and quarter.
  // ignore: non_constant_identifier_names
  String yQQQ(BuildContext context, {String? locale}) => DateFormat.yQQQ(_loc(context, locale)).format(this);

  /// Full year and quarter.
  // ignore: non_constant_identifier_names
  String yQQQQ(BuildContext context, {String? locale}) => DateFormat.yQQQQ(_loc(context, locale)).format(this);

  /// 24-hour clock hour (0-23).
  // ignore: non_constant_identifier_names
  String H(BuildContext context, {String? locale}) => DateFormat.H(_loc(context, locale)).format(this);

  /// 24-hour clock hour and minute.
  // ignore: non_constant_identifier_names
  String Hm(BuildContext context, {String? locale}) => DateFormat.Hm(_loc(context, locale)).format(this);

  /// 24-hour clock hour, minute and second.
  // ignore: non_constant_identifier_names
  String Hms(BuildContext context, {String? locale}) => DateFormat.Hms(_loc(context, locale)).format(this);

  /// 12-hour clock hour (1-12).
  String j(BuildContext context, {String? locale}) => DateFormat.j(_loc(context, locale)).format(this);

  /// 12-hour clock hour and minute.
  String jm(BuildContext context, {String? locale}) => DateFormat.jm(_loc(context, locale)).format(this);

  /// 12-hour clock hour, minute and second.
  String jms(BuildContext context, {String? locale}) => DateFormat.jms(_loc(context, locale)).format(this);
}

extension StringExtensions on String {
  /// Capitalizes the first letter of each space-separated word, lower-casing
  /// the rest. Returns the original string when empty.
  String get capitalize {
    if (contains(" ")) {
      return split(' ')
          .map((word) => word.isNotEmpty ? word[0].toUpperCase() + word.substring(1).toLowerCase() : '')
          .join(' ');
    } else {
      return isNotEmpty ? this[0].toUpperCase() + substring(1).toLowerCase() : '';
    }
  }
}
