import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ndialog/ndialog.dart';

import '../../ui/components/adaptive_progress_indicator.dart';
import '../../ui/components/custom_card.dart';
import 'navigations.dart';

extension WidgetExtensions on Widget {
  /// A widget that dismisses the keyboard when tapped.
  ///
  /// This widget can be used to wrap other widgets to provide the functionality
  /// of dismissing the keyboard when the user taps outside of a text field.
  ///
  /// Example usage:
  /// ```dart
  /// anyWidget.dismissKeyboardOnTap(context);
  /// ```
  ///
  /// This is particularly useful in forms or screens with multiple input fields
  /// where you want to hide the keyboard when the user taps outside of the input fields.
  ///
  /// Parameters:
  /// - `context`: The build context of the widget.
  Widget dismissKeyboardOnTap(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: this,
    );
  }
}

extension FutureProgressDialog<T> on Future<T> {
  /// Displays a custom progress dialog.
  ///
  /// This method shows a custom progress dialog in the given [context].
  ///
  /// Returns a [Future] that completes with a value of type [T] or `null`
  /// when the dialog is dismissed.
  ///
  /// [context] - The build context in which to show the progress dialog.
  Future<T?> showProgress(BuildContext context) => showCustomProgressDialog(
        context,
        loadingWidget: CustomCard(padding: const EdgeInsets.all(15), child: const AdaptiveProgressIndicator()),
        onProgressError: (error) {
          closeScreen(context);
          throw error;
        },
      );
}

extension DateTimeExtensions on DateTime {
  /// Formats the date as a day of the month (1-31).
  String d({locale}) => DateFormat.d(locale).format(this);

  /// Formats the date as an abbreviated day of the week (Mon, Tue, etc.).
  String E({locale}) => DateFormat.E(locale).format(this);

  /// Formats the date as a full day of the week (Monday, Tuesday, etc.).
  // ignore: non_constant_identifier_names
  String EEEE({locale}) => DateFormat.EEEE(locale).format(this);

  /// Formats the date as a narrow day of the week (M, T, etc.).
  // ignore: non_constant_identifier_names
  String EEEEE({locale}) => DateFormat.EEEEE(locale).format(this);

  /// Formats the date as an abbreviated month (Jan, Feb, etc.).
  // ignore: non_constant_identifier_names
  String LLL({locale}) => DateFormat.LLL(locale).format(this);

  /// Formats the date as a full month (January, February, etc.).
  // ignore: non_constant_identifier_names
  String LLLL({locale}) => DateFormat.LLLL(locale).format(this);

  /// Formats the date as a numeric month (1-12).
  String M({locale}) => DateFormat.M(locale).format(this);

  /// Formats the date as a numeric month and day (MM/dd).
  // ignore: non_constant_identifier_names
  String Md({locale}) => DateFormat.Md(locale).format(this);

  /// Formats the date as an abbreviated day of the week, numeric month, and day (EEE, MM/dd).
  // ignore: non_constant_identifier_names
  String MEd({locale}) => DateFormat.MEd(locale).format(this);

  /// Formats the date as an abbreviated month and day (MMM dd).
  // ignore: non_constant_identifier_names
  String MMM({locale}) => DateFormat.MMM(locale).format(this);

  /// Formats the date as an abbreviated month, day, and year (MMM dd, yyyy).
  // ignore: non_constant_identifier_names
  String MMMd({locale}) => DateFormat.MMMd(locale).format(this);

  /// Formats the date as an abbreviated day of the week, month, and day (EEE, MMM dd).
  // ignore: non_constant_identifier_names
  String MMMEd({locale}) => DateFormat.MMMEd(locale).format(this);

  /// Formats the date as a full month (MMMM).
  // ignore: non_constant_identifier_names
  String MMMM({locale}) => DateFormat.MMMM(locale).format(this);

  /// Formats the date as a full month and day (MMMM dd).
  // ignore: non_constant_identifier_names
  String MMMMd({locale}) => DateFormat.MMMMd(locale).format(this);

  /// Formats the date as a full day of the week, month, and day (EEEE, MMMM dd).
  // ignore: non_constant_identifier_names
  String MMMMEEEEd({locale}) => DateFormat.MMMMEEEEd(locale).format(this);

  /// Formats the date as an abbreviated quarter (Q1, Q2, etc.).
  // ignore: non_constant_identifier_names
  String QQQ({locale}) => DateFormat.QQQ(locale).format(this);

  /// Formats the date as a full quarter (1st quarter, 2nd quarter, etc.).
  // ignore: non_constant_identifier_names
  String QQQQ({locale}) => DateFormat.QQQQ(locale).format(this);

  /// Formats the date as a numeric year (yyyy).
  String y({locale}) => DateFormat.y(locale).format(this);

  /// Formats the date as a numeric year and month (yyyy-MM).
  String yM({locale}) => DateFormat.yM(locale).format(this);

  /// Formats the date as a numeric year, month, and day (yyyy-MM-dd).
  String yMd({locale}) => DateFormat.yMd(locale).format(this);

  /// Formats the date as an abbreviated day of the week, numeric year, month, and day (EEE, yyyy-MM-dd).
  String yMEd({locale}) => DateFormat.yMEd(locale).format(this);

  /// Formats the date as an abbreviated year, month, and day (MMM yyyy).
  String yMMM({locale}) => DateFormat.yMMM(locale).format(this);

  /// Formats the date as an abbreviated year, month, and day (MMM dd, yyyy).
  String yMMMd({locale}) => DateFormat.yMMMd(locale).format(this);

  /// Formats the date as an abbreviated day of the week, year, month, and day (EEE, MMM dd, yyyy).
  String yMMMEd({locale}) => DateFormat.yMMMEd(locale).format(this);

  /// Formats the date as a full year and month (MMMM yyyy).
  String yMMMM({locale}) => DateFormat.yMMMM(locale).format(this);

  /// Formats the date as a full year, month, and day (MMMM dd, yyyy).
  String yMMMMd({locale}) => DateFormat.yMMMMd(locale).format(this);

  /// Formats the date as a full day of the week, year, month, and day (EEEE, MMMM dd, yyyy).
  String yMMMMEEEEd({locale}) => DateFormat.yMMMMEEEEd(locale).format(this);

  /// Formats the date as an abbreviated year and quarter (Q1 yyyy).
  String yQQQ({locale}) => DateFormat.yQQQ(locale).format(this);

  /// Formats the date as a full year and quarter (1st quarter yyyy).
  String yQQQQ({locale}) => DateFormat.yQQQQ(locale).format(this);

  /// Formats the time as a 24-hour clock hour (0-23).
  String H({locale}) => DateFormat.H(locale).format(this);

  /// Formats the time as a 24-hour clock hour and minute (HH:mm).
  // ignore: non_constant_identifier_names
  String Hm({locale}) => DateFormat.Hm(locale).format(this);

  /// Formats the time as a 24-hour clock hour, minute, and second (HH:mm:ss).
  // ignore: non_constant_identifier_names
  String Hms({locale}) => DateFormat.Hms(locale).format(this);

  /// Formats the time as a 12-hour clock hour (1-12).
  String j({locale}) => DateFormat.j(locale).format(this);

  /// Formats the time as a 12-hour clock hour and minute (h:mm a).
  String jm({locale}) => DateFormat.jm(locale).format(this);

  /// Formats the time as a 12-hour clock hour, minute, and second (h:mm:ss a).
  String jms([locale]) => DateFormat.jms([locale]).format(this);
}

extension StringExtensions on String {
  /// An extension property that capitalizes the first letter of a string.
  ///
  /// Returns a new string with the first letter converted to uppercase and the
  /// remaining letters unchanged. If the string is empty, it returns the
  /// original string.
  String get capitalize {
    if (contains(" ")) {
      return split(' ')
          .map((word) => word.isNotEmpty ? word[0].toUpperCase() + word.substring(1).toLowerCase() : '') // Capitalize the first letter and make the rest lowercase
          .join(' ');
    } else {
      return isNotEmpty ? this[0].toUpperCase() + substring(1).toLowerCase() : '';
    }
  }
}
