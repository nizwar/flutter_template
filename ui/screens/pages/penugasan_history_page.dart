import 'package:flutter/material.dart';

import '../penugasan/penugasan_list_screen.dart';

class PenugasanHistoryPage extends StatelessWidget {
  const PenugasanHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(title: Text("Penugasan"), automaticallyImplyLeading: false),
        Expanded(child: PenugasanListScreen.body(context)),
      ],
    );
  }
}
