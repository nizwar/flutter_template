import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:mojang_nontr/core/models/penugasan.dart';
import 'package:mojang_nontr/core/utils/extensions.dart';
import 'package:mojang_nontr/core/utils/utils.dart';

import '../../../core/resources/themes.dart';
import '../../components/custom_card.dart';
import '../../components/custom_divider.dart';
import '../../components/penugasan_card.dart';
import 'penugasan_start_screen.dart';

class PenugasanDetailScreen extends StatelessWidget {
  final Penugasan penugasan;
  const PenugasanDetailScreen(this.penugasan, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detail Penugasan")),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: _detailPenugasanWidget(context)),
            if (penugasan.statusPenugasan == "NEW")
              Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  spacing: 10,
                  children: [
                    ElevatedButton(
                      onPressed: _onKembalikanClicked,
                      style: ElevatedButton.styleFrom(backgroundColor: colorScheme(context).primary, foregroundColor: colorScheme(context).secondary),
                      child: Text("Kembalikan"),
                    ),
                    ElevatedButton(onPressed: () => _onMulaiClicked(context), child: Text("Mulai")),
                  ].map((item) => Expanded(child: item)).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _detailPenugasanWidget(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(20),
      children: [
        CustomCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.all(15),
                color: colorScheme(context).secondary,
                child: Text(penugasan.noAgenda, style: textTheme(context).bodySmall?.copyWith(color: colorScheme(context).onSecondary, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 5,
                  children: [
                    PenugasanCard.rowDetails("Name", penugasan.namaPelanggan),
                    PenugasanCard.rowDetails("Tipe Layanan", penugasan.namaTipeLayanan),
                    PenugasanCard.rowDetails("Tanggal Pengajuan", penugasan.tglPengajuan?.yMd()),
                    PenugasanCard.rowDetails("Waktu Pengajuan", penugasan.tglPengajuan?.jm()),
                    ColumnDivider(space: 10),
                    Text("Detail Pemohon", style: textTheme(context).bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                    PenugasanCard.rowDetails("Nama Pemohon", penugasan.namaPemohon),
                    PenugasanCard.rowDetails("Tanggal Permohonan", penugasan.tglPermohonan?.yMd()),
                    PenugasanCard.rowDetails("Besar Kapasitas", penugasan.besarKapasitas),
                    PenugasanCard.rowDetails("Alamat Instalasi", penugasan.alamatInstalasi),
                    PenugasanCard.rowDetails("Latitude", penugasan.lokasi.latitude.toString()),
                    PenugasanCard.rowDetails("Longitude", penugasan.lokasi.longitude.toString()),
                  ],
                ),
              ),
            ],
          ),
        ),
        ColumnDivider(),
        SizedBox(
          height: 200,
          child: IgnorePointer(
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: FlutterMap(
                options: MapOptions(initialCenter: penugasan.lokasi),
                children: [
                  TileLayer(urlTemplate: "https://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}", subdomains: ['mt0', 'mt1', 'mt2', 'mt3']),
                  MarkerLayer(markers: [
                    Marker(
                      point: penugasan.lokasi,
                      width: 25,
                      height: 25,
                      child: Transform.translate(offset: Offset(0, -12.5), child: Image.asset("assets/icons/placemark.png")),
                    ),
                  ]),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  void _onKembalikanClicked() {}

  void _onMulaiClicked(BuildContext context) => startScreen(context, PenugasanStartScreen(penugasan));
}
