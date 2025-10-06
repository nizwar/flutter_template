import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mojang_nontr/core/models/penugasan.dart';
import 'package:mojang_nontr/core/utils/utils.dart';
import 'package:mojang_nontr/ui/components/adaptive_progress_indicator.dart';
import 'package:mojang_nontr/ui/components/custom_card.dart';
import 'package:mojang_nontr/ui/components/custom_divider.dart';
import 'package:mojang_nontr/ui/screens/penugasan/penugasan_coordinat_screen.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';

import '../../../core/resources/themes.dart';
import 'providers/penugasan_start_provider.dart';

class PenugasanStartScreen extends StatelessWidget {
  final Penugasan penugasan;
  const PenugasanStartScreen(this.penugasan, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Penugasan"),
        actions: [IconButton(onPressed: () => replaceScreen(context, PenugasanCoordinatScreen(penugasan)), icon: Icon(Icons.face))],
      ),
      body: ChangeNotifierProvider(
        create: (context) => PenugasanStartProvider()..initialize().catchError((e) => showErrorSnackbar(context, e.toString())),
        builder: (context, child) => Padding(
          padding: EdgeInsetsGeometry.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Text("Petugas Pemeriksa Instalasi", style: textTheme(context).titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                    ColumnDivider(space: 15),
                    _cameraBuilderWidget(),
                    ColumnDivider(space: 30),
                    Consumer<PenugasanStartProvider>(
                      builder: (context, value, child) {
                        return Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(color: colorScheme(context).secondaryContainer.withValues(alpha: .1), borderRadius: BorderRadius.circular(10)),
                          child: Text(value.prompt, style: textTheme(context).bodyMedium, textAlign: TextAlign.center),
                        );
                      },
                    ),
                    ColumnDivider(space: 30),
                    _informationWidget(context),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(50),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(20),
                    backgroundColor: colorScheme(context).secondaryContainer,
                    foregroundColor: colorScheme(context).onSecondaryContainer,
                    elevation: 5,
                  ),
                  onPressed: () => _onScannerClicked(context),
                  child: Image.asset("assets/icons/camera.png", width: 41),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _informationWidget(BuildContext context) {
    return CustomCard(
      child: IntrinsicHeight(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10).copyWith(right: 10),
          child: Row(
            spacing: 10,
            children: [
              Container(
                width: 10,
                decoration: BoxDecoration(
                  color: colorScheme(context).primary,
                  borderRadius: BorderRadius.horizontal(right: Radius.circular(10)),
                ),
              ),
              Expanded(child: Text("Pastikan kondisi pencahayaan terang dan foto diambil dengan jelas agar data dapat diverifikasi dengan baik."))
            ],
          ),
        ),
      ),
    );
  }

  Widget _cameraBuilderWidget() {
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: Consumer<PenugasanStartProvider>(
          builder: (context, value, child) {
            return Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Builder(builder: (context) {
                if (!value.scannerReady) {
                  return Center(child: AdaptiveProgressIndicator());
                } else {
                  return Center(
                    child: Transform.scale(
                      scale: 1.5,
                      child: CameraPreview(value.cameraController),
                    ),
                  );
                }
              }),
            );
          },
        ),
      ),
    );
  }

  void _onScannerClicked(BuildContext context) {
    context.read<PenugasanStartProvider>().startScanning(context).then((value) {
      _showSuccessAlert(context).show(context).then((value) {
        replaceScreen(context, PenugasanCoordinatScreen(penugasan));
      });
    }).catchError((e) {
      _showFailsAlert(context, e.toString()).show(context);
    });
  }

  AlertDialog _showSuccessAlert(BuildContext context) {
    return AlertDialog(
      content: AspectRatio(
        aspectRatio: 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset("assets/icons/park_success.png", width: 100, height: 100),
                    ColumnDivider(space: 10),
                    Text("Verifikasi wajah selesai", style: textTheme(context).titleMedium?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
            ElevatedButton(onPressed: () => closeScreen(context), child: Text("Lanjutkan"))
          ],
        ),
      ),
    );
  }

  AlertDialog _showFailsAlert(BuildContext context, String e) {
    return AlertDialog(
      content: AspectRatio(
        aspectRatio: 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset("assets/icons/park_fails.png", width: 100, height: 100),
                    ColumnDivider(space: 10),
                    Text("Verifikasi wajah gagal", style: textTheme(context).titleMedium?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    ColumnDivider(space: 5),
                    Text(e.toString(), style: textTheme(context).bodySmall, textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
            ElevatedButton(onPressed: () => closeScreen(context), child: Text("Tutup"))
          ],
        ),
      ),
    );
  }
}
