import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mojang_nontr/core/providers/user_provider.dart';
import 'package:mojang_nontr/core/utils/extensions.dart';
import 'package:mojang_nontr/core/utils/navigations.dart';
import 'package:mojang_nontr/ui/screens/penugasan/penugasan_start_screen.dart';
import 'package:provider/provider.dart';

import '../../core/models/penugasan.dart';
import '../../core/resources/themes.dart';
import '../screens/penugasan/penugasan_detail_screen.dart';
import 'custom_card.dart';
import 'custom_divider.dart';

class PenugasanCard extends StatelessWidget {
  final Penugasan penugasan;
  const PenugasanCard(this.penugasan, {super.key});

  static Widget rowDetails(String title, String? value) {
    return Builder(builder: (context) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(title, style: textTheme(context).bodySmall)),
          SizedBox(
            width: 200,
            child: Text(
              value ?? "-",
              style: textTheme(context).bodySmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => startScreen(context, PenugasanDetailScreen(penugasan)),
      child: CustomCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(15),
              color: colorScheme(context).secondary,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      penugasan.noAgenda,
                      style: textTheme(context).bodySmall?.copyWith(color: colorScheme(context).onSecondary, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Icon(CupertinoIcons.right_chevron, color: colorScheme(context).onSecondary, size: 16),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                spacing: 5,
                children: [
                  rowDetails("Name", penugasan.namaPemohon),
                  rowDetails("Tipe Layanan", penugasan.namaTipeLayanan),
                  rowDetails("Tanggal Pengajuan", penugasan.tglPengajuan?.yMd()),
                  rowDetails("Waktu Pengajuan", penugasan.tglPengajuan?.jm()),
                  rowDetails("Alamat instalasi", penugasan.alamatInstalasi),
                  Consumer<UserProvider>(
                    builder: (BuildContext context, UserProvider value, Widget? child) {
                      if (value.currentPosition == null) {
                        return SizedBox.shrink();
                      }
                      return rowDetails("Jarak", penugasan.lokasi.distanceTo(value.currentPosition!.toLatLng));
                    },
                  ),
                  ColumnDivider(space: 10),
                  if (penugasan.statusPenugasan == "NEW")
                    Row(
                      spacing: 10,
                      children: [
                        ElevatedButton(
                          onPressed: _onKembalikanClicked,
                          style: ElevatedButton.styleFrom(backgroundColor: colorScheme(context).primary, foregroundColor: colorScheme(context).secondary),
                          child: Text("Kembalikan"),
                        ),
                        ElevatedButton(onPressed: () => _onMulaiClicked(context), child: Text("Mulai")),
                      ].map((item) => Expanded(child: item)).toList(),
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onMulaiClicked(BuildContext context) async {
    startScreen(context, PenugasanStartScreen(penugasan));
  }

  void _onKembalikanClicked() {}
}
