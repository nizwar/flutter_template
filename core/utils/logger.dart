import 'dart:convert';
import 'dart:developer';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// Logs the given [object] to the console if the application is in `DEBUG MODE`.
///
/// If the [object] is a [Map] or [List], it will be pretty-printed as JSON.
/// Otherwise, the [object]'s `toString` method will be used for logging.
///
/// This function uses the `log` function from the `dart:developer` package
/// and checks the `kDebugMode` constant to determine if logging should occur.
///
/// Example usage:
/// ```dart
/// clog('This is a debug message');
/// clog({'key': 'value'});
/// clog([1, 2, 3]);
/// ```
void clog(dynamic object) {
  if (kDebugMode) {
    if (object is Map || object is List) {
      try {
        log(const JsonEncoder.withIndent("    ").convert(object));
        return;
      } catch (_) {}
    }
    log(object.toString());
  }
}

/// Logs an error message to the console.
///
/// This function takes a dynamic object as input and logs it as an error message.
/// It is useful for debugging and tracking errors in the application.
///
/// Example usage:
/// ```dart
/// elog('An error occurred');
/// ```
///
/// - Parameter object: The object to be logged as an error message. It can be of any type.
void elog(dynamic object) {
  if (kDebugMode) {
    clog(object);
  } else {
    FirebaseCrashlytics.instance.log(object.toString());
  }
}

/// Prints the given [object] to the console if the application is in `DEBUG MODE`.
///
/// This function uses [debugPrint] to print the [object]'s string representation
/// when the application is running in debug mode (i.e., [kDebugMode] is true).
/// If the application is not in debug mode, this function does nothing.
///
/// Example usage:
/// ```dart
/// cprint('This is a debug message');
/// ```
///
/// - Parameter object: The object to be printed to the console.
void cprint(dynamic object) => kDebugMode ? debugPrint(object.toString()) : null;
