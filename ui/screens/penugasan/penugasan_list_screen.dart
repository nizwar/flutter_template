import 'package:flutter/material.dart';
import 'package:mojang_nontr/core/providers/penugasan_provider.dart';
import 'package:mojang_nontr/ui/components/penugasan_card.dart';
import 'package:provider/provider.dart';
import '../../../core/resources/themes.dart';

class PenugasanListScreen extends StatelessWidget {
  const PenugasanListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Penugasan")),
      body: body(context),
    );
  }

  static Widget body(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TabBar(
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: colorScheme(context).primary,
              ),
              dividerColor: Colors.transparent,
              labelColor: colorScheme(context).secondary,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Tab(text: "Baru"),
                Tab(text: "Selesai"),
              ],
            ),
          ),
          Expanded(
            child: Consumer<PenugasanProvider>(
              builder: (context, value, child) => TabBarView(
                children: [
                  SingleChildScrollView(padding: EdgeInsets.all(20), child: Column(spacing: 20, children: value.penugasanBaru.map((e) => PenugasanCard(e)).toList())),
                  SingleChildScrollView(padding: EdgeInsets.all(20), child: Column(spacing: 20, children: value.penugasanSelesai.map((e) => PenugasanCard(e)).toList())),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
