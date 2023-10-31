import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/resources/themes.dart';

class AdaptiveProgressIndicator extends StatelessWidget {
  const AdaptiveProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoActivityIndicator(color: theme(context).colorScheme.onSurface);
    } else {
      return CircularProgressIndicator(color: theme(context).colorScheme.onSurface);
    }
  }
}
