import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/resources/themes.dart';

/// A progress indicator that adapts to the platform.
///
/// Shows a [CupertinoActivityIndicator] on iOS/macOS and a
/// [CircularProgressIndicator] everywhere else. Uses [defaultTargetPlatform]
/// (guarded by [kIsWeb]) instead of `dart:io Platform`, so it is safe on
/// Flutter Web where `dart:io` is unavailable.
class AdaptiveProgressIndicator extends StatelessWidget {
  const AdaptiveProgressIndicator({super.key});

  bool get _useCupertino =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS);

  @override
  Widget build(BuildContext context) {
    final color = theme(context).colorScheme.onSurface;
    if (_useCupertino) {
      return CupertinoActivityIndicator(color: color);
    }
    return CircularProgressIndicator(color: color);
  }
}
