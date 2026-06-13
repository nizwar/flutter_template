import 'package:flutter/material.dart';

import '../../core/resources/themes.dart';
import '../../core/utils/app_config.dart';
import '../components/adaptive_progress_indicator.dart';
import '../components/custom_divider.dart';

/// Splash screen shown by [Root] while startup work runs.
///
/// Replace the placeholder content (app name + spinner) with your branding/logo.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppConfig.read(context).appName,
              style: textTheme(context).headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const ColumnDivider(space: 24),
            const SizedBox(width: 28, height: 28, child: AdaptiveProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
