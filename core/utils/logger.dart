import 'dart:developer';
import 'package:flutter/foundation.dart';

void clog(dynamic object) => kDebugMode ? log(object.toString()) : null;
void cprint(dynamic object) => kDebugMode ? print(object.toString()) : null;
