import 'dart:convert';
import 'dart:developer';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

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

void elog(dynamic object) {
  if (kDebugMode) {
    clog(object);
  } else {
    FirebaseCrashlytics.instance.log(object);
  }
}

void cprint(dynamic object) => kDebugMode ? debugPrint(object.toString()) : null;
