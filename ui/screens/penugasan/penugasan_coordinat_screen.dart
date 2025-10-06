import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:mojang_nontr/core/models/penugasan.dart';
import 'package:mojang_nontr/core/resources/themes.dart';
import 'package:mojang_nontr/core/utils/extensions.dart';
import 'package:mojang_nontr/core/utils/utils.dart';
import 'package:mojang_nontr/ui/components/custom_divider.dart';
import 'package:mojang_nontr/ui/screens/penugasan/forms/form_lhpp_screen.dart';

import '../../../core/https/penugasan_http.dart';

class PenugasanCoordinatScreen extends StatelessWidget {
  final Penugasan penugasan;
  final ValueNotifier<Position?> currentPosition = ValueNotifier(null);

  PenugasanCoordinatScreen(this.penugasan, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Koordinat")),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          _buildMapWidget(),
          ColumnDivider(space: 30),
          _coordinatWidget(context),
        ],
      ),
    );
  }

  Widget _buildMapWidget() {
    return ValueListenableBuilder(
      valueListenable: currentPosition,
      builder: (context, value, child) => IgnorePointer(
        child: Container(
          height: 200,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: FlutterMap(
            key: UniqueKey(),
            options: MapOptions(
              initialCenter: value != null ? LatLng(value.latitude, value.longitude) : const LatLng(-6.9057765, 107.6250668),
            ),
            children: [
              TileLayer(
                urlTemplate: "https://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}",
                subdomains: ['mt0', 'mt1', 'mt2', 'mt3'],
              ),
              MarkerLayer(markers: [
                if (value != null)
                  Marker(
                    point: LatLng(value.latitude, value.longitude),
                    width: 25,
                    height: 25,
                    child: Transform.translate(
                      offset: Offset(0, -12.5),
                      child: Image.asset("assets/icons/placemark.png"),
                    ),
                  ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _coordinatWidget(BuildContext context) {
    Widget coordinatText(String label, String value) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 5,
        children: [
          Text(label, style: textTheme(context).bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: theme(context).dividerColor)),
            child: Text(value, style: textTheme(context).bodyMedium),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Titik Koordinat", style: textTheme(context).titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        ColumnDivider(),
        ValueListenableBuilder(
          valueListenable: currentPosition,
          builder: (context, value, child) => Row(
            spacing: 10,
            children: [
              coordinatText("Latitude", value?.latitude.toString() ?? "-"),
              coordinatText("Longitude", value?.longitude.toString() ?? "-"),
            ].map((item) => Expanded(child: item)).toList(),
          ),
        ),
        ColumnDivider(space: 20),
        ElevatedButton(
          onPressed: () => _onGetLocationClicked(context),
          style: ElevatedButton.styleFrom(backgroundColor: colorScheme(context).primary, foregroundColor: colorScheme(context).onPrimary),
          child: Text("Ambil Koordinat Saya"),
        ),
        ColumnDivider(space: 20),
        ValueListenableBuilder(
          valueListenable: currentPosition,
          builder: (context, value, child) => ElevatedButton(
            onPressed: value != null ? () => _onIsiLHPPClicked(context) : null,
            child: Text("Isi LHPP"),
          ),
        ),
      ],
    );
  }

  void _onGetLocationClicked(BuildContext context) {
    getMyLocation().showProgress(context).then((value) {
      currentPosition.value = value?.$1;
    }).catchError((e) {
      showErrorSnackbar(context, "Gagal mendapatkan lokasi: ${e.toString()}");
    });
  }

  void _onIsiLHPPClicked(BuildContext context) async {
    final formLhpp = await PenugasanHttp(context).getDetailPenugasan(penugasan.noAgenda).showProgress(context);
    if (formLhpp == null) {
      showErrorSnackbar(context, "Gagal memuat data LHPP");
      return;
    }
    startScreen(context, FormLhppScreen(formLhpp: formLhpp));
  }
}
