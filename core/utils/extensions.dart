import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';

import '../../ui/components/adaptive_progress_indicator.dart';

extension KeyboardDismisser on Widget {
  Widget dismissKeyboardOnTap(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: this,
    );
  }
}

extension FutureProgressDialog<T> on Future<T> {
  Future<T?> showProgress(BuildContext context) => showCustomProgressDialog(context, loadingWidget: const AdaptiveProgressIndicator());
}
