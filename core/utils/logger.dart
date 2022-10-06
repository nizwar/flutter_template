import 'dart:developer';
import 'package:flutter/foundation.dart';

void clog(dynamic object) => kDebugMode ? log(object.toString()) : null;
void cprint(dynamic object) => kDebugMode ? debugPrint(object.toString()) : null;
