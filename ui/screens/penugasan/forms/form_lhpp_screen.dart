import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mojang_nontr/core/models/form_lhpp/form_lhpp.dart';
import 'package:mojang_nontr/core/utils/utils.dart';
import 'package:mojang_nontr/ui/components/custom_card.dart';

import '../../../../core/models/form_lhpp/mata_uji.dart';
import 'form_matauji_screen.dart';

class FormLhppScreen extends StatefulWidget {
  final FormLhpp formLhpp;
  const FormLhppScreen({super.key, required this.formLhpp});

  @override
  State<FormLhppScreen> createState() => _FormLhppScreenState();
}

class _FormLhppScreenState extends State<FormLhppScreen> {
  @override
  void initState() {
    if (widget.formLhpp.metaUji == null || widget.formLhpp.metaUji!.isNotEmpty) {
      if (widget.formLhpp.metaUji!.length == 1) {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          replaceScreen(context, FormMataUjiScreen(widget.formLhpp.permohonanUid, widget.formLhpp.metaUji!.first));
        });
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Form LHP")),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: widget.formLhpp.metaUji!.map((item) => itemCard(context, item)).toList(),
      ),
    );
  }

  Widget itemCard(BuildContext context, MataUji data) {
    return CustomCard(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: EdgeInsets.only(bottom: 20),
      borderRadius: 20,
      child: ListTile(title: Text(data.mataUji ?? "-"), onTap: () => startScreen(context, FormMataUjiScreen(widget.formLhpp.permohonanUid, data))),
    );
  }
}
