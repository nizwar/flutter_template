import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:mojang_nontr/core/https/penugasan_http.dart';
import 'package:mojang_nontr/core/resources/themes.dart';
import 'package:mojang_nontr/core/utils/extensions.dart';
import 'package:mojang_nontr/core/utils/logger.dart';
import 'package:mojang_nontr/ui/components/custom_card.dart';
import 'package:provider/provider.dart';

import '../../../../core/models/form_lhpp/mata_uji.dart';
import '../../../../core/utils/utils.dart';
import '../../../components/custom_divider.dart';

class FormMataUjiScreen extends StatelessWidget {
  final int permohonanUid;
  final MataUji mataUji;
  const FormMataUjiScreen(this.permohonanUid, this.mataUji, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FormMataUjiProvider(mataUji.mataHasil ?? <MataHasil>[]),
      builder: (context, child) => Scaffold(
        appBar: AppBar(
          title: Text(mataUji.mataUji ?? "-"),
          actions: [
            IconButton(
              onPressed: () async {
                // clog(mataUji.uidMataHasil);
                PenugasanHttp(context).submitFormLhpp(permohonanUid, mataUji, context.read<FormMataUjiProvider>().listMataUji).showProgress(context).then((value) {
                  showSuccessSnackbar(context, "Berhasil menyimpan data");
                }).catchError((e) {
                  showErrorSnackbar(context, e.toString());
                });
              },
              icon: Icon(Icons.save),
            )
          ],
        ),
        body: Consumer<FormMataUjiProvider>(
          builder: (context, value, child) => Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ListView.builder(
              itemCount: value.listMataUji.length,
              padding: EdgeInsets.all(10),
              itemBuilder: (context, index) => itemCard(index, context, value),
            ),
          ),
        ),
      ),
    );
  }

  Widget itemCard(int index, BuildContext context, FormMataUjiProvider provider) {
    final item = provider.listMataUji[index];
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: theme(context).dividerTheme.color!)),
      child: ExpansionTile(
        initiallyExpanded: false,
        leading: Image.asset("assets/icons/form_icon.png", width: 30),
        iconColor: colorScheme(context).onSurface,
        tilePadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        childrenPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        title: Text("${index + 1}. ${item.mataHasil ?? "-"}", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        children: List.generate(
          item.arrSg3MataHasilIsian?.length ?? 0,
          (indexIsian) {
            final mataHasilIsianForm = item.arrSg3MataHasilIsian![indexIsian];
            Widget addButton() {
              return Row(
                children: [
                  RowDivider(),
                  SizedBox(
                    height: 25,
                    width: 25,
                    child: OutlinedButton(
                      onPressed: () {
                        provider.listMataUji[index].arrSg3MataHasilIsian?[indexIsian].children.add(HasilIsian.fromJson(mataHasilIsianForm.toJson()).fresh());
                        provider.refresh();
                      },
                      style: OutlinedButton.styleFrom(side: BorderSide(color: colorScheme(context).onSecondaryContainer), shape: CircleBorder(), padding: EdgeInsets.zero),
                      child: Icon(Icons.add, color: colorScheme(context).onSecondaryContainer),
                    ),
                  )
                ],
              );
            }

            Widget removeButton(int selectedIndex) {
              return SizedBox(
                height: 30,
                width: 30,
                child: IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: () {
                    provider.listMataUji[index].arrSg3MataHasilIsian?[indexIsian].children.removeAt(selectedIndex);
                    provider.refresh();
                  },
                  icon: Icon(Icons.delete),
                ),
              );
            }

            return CustomCard(
              margin: EdgeInsets.only(bottom: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(color: colorScheme(context).secondaryContainer),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            mataHasilIsianForm.textDataIsian ?? "-",
                            style: textTheme(context).bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme(context).onSecondaryContainer),
                          ),
                        ),
                        if (mataHasilIsianForm.tambahIsian ?? false) addButton(),
                      ],
                    ),
                  ),
                  ColumnDivider(),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (mataHasilIsianForm.dataIsian1 != null) ...[formField(index, indexIsian, 1, mataHasilIsianForm.dataIsian1!), ColumnDivider()],
                        if (mataHasilIsianForm.dataIsian2 != null) ...[formField(index, indexIsian, 2, mataHasilIsianForm.dataIsian2!), ColumnDivider()],
                        if (mataHasilIsianForm.dataIsian3 != null) ...[formField(index, indexIsian, 3, mataHasilIsianForm.dataIsian3!)],
                        if (mataHasilIsianForm.isianKeterangan ?? false) ...[formField(index, indexIsian, -1, null)],
                        if (mataHasilIsianForm.children.isNotEmpty) ...[
                          ColumnDivider(),
                          Column(
                            spacing: 10,
                            children: List.generate(mataHasilIsianForm.children.length, (indexChildren) {
                              final child = mataHasilIsianForm.children[index];
                              return Column(
                                children: [
                                  Divider(),
                                  ColumnDivider(),
                                  Row(
                                    children: [
                                      Expanded(child: Text(mataHasilIsianForm.textDataIsian ?? "-", style: TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
                                      RowDivider(),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                        decoration: BoxDecoration(color: colorScheme(context).secondaryContainer, borderRadius: BorderRadius.circular(5)),
                                        child: Text(
                                          "Form ${index + 2}",
                                          style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme(context).onSecondaryContainer),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      RowDivider(),
                                      removeButton(index),
                                    ],
                                  ),
                                  ColumnDivider(),
                                  if (child.dataIsian1 != null) ...[formField(index, indexIsian, 1, child.dataIsian1!, indexChildren), ColumnDivider()],
                                  if (child.dataIsian2 != null) ...[formField(index, indexIsian, 2, child.dataIsian2!, indexChildren), ColumnDivider()],
                                  if (child.dataIsian3 != null) ...[formField(index, indexIsian, 3, child.dataIsian3!, indexChildren)],
                                  if (child.isianKeterangan ?? false) ...[formField(index, indexIsian, -1, null, indexChildren)],
                                ],
                              );
                            }),
                          )
                        ]
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget formField(int indexSection, int indexIsian, int dataIsianKe, DataIsian? dataIsian, [int? childrenIndex]) {
    FormFieldType? data = dataIsian?.jenisDataIsian;
    List<String>? pilihan = dataIsian?.pilihan;
    dynamic value = dataIsian?.isi;
    return Builder(builder: (context) {
      FormMataUjiProvider provider = context.read();
      if (childrenIndex != null) {
        switch (dataIsianKe) {
          case -1:
            value = provider.listMataUji[indexSection].arrSg3MataHasilIsian?[indexIsian].children[childrenIndex].keterangan;
          case 1:
            value = provider.listMataUji[indexSection].arrSg3MataHasilIsian?[indexIsian].children[childrenIndex].dataIsian1?.isi;
            break;
          case 2:
            value = provider.listMataUji[indexSection].arrSg3MataHasilIsian?[indexIsian].children[childrenIndex].dataIsian2?.isi;
            break;
          case 3:
            value = provider.listMataUji[indexSection].arrSg3MataHasilIsian?[indexIsian].children[childrenIndex].dataIsian3?.isi;
            break;
        }
      }
      switch (dataIsianKe) {
        case -1:
          value = provider.listMataUji[indexSection].arrSg3MataHasilIsian?[indexIsian].keterangan;
        case 1:
          value = provider.listMataUji[indexSection].arrSg3MataHasilIsian?[indexIsian].dataIsian1?.isi;
          break;
        case 2:
          value = provider.listMataUji[indexSection].arrSg3MataHasilIsian?[indexIsian].dataIsian2?.isi;
          break;
        case 3:
          value = provider.listMataUji[indexSection].arrSg3MataHasilIsian?[indexIsian].dataIsian3?.isi;
          break;
      }
      void setValue(dynamic value) {
        if (childrenIndex != null) {
          switch (dataIsianKe) {
            case -1:
              provider.listMataUji[indexSection].arrSg3MataHasilIsian?[indexIsian].keterangan = value;
              return;
            case 1:
              provider.listMataUji[indexSection].arrSg3MataHasilIsian?[indexIsian].children[childrenIndex].dataIsian1?.isi = value;
              break;
            case 2:
              provider.listMataUji[indexSection].arrSg3MataHasilIsian?[indexIsian].children[childrenIndex].dataIsian2?.isi = value;
              break;
            case 3:
              provider.listMataUji[indexSection].arrSg3MataHasilIsian?[indexIsian].children[childrenIndex].dataIsian3?.isi = value;
              break;
          }
        } else {
          switch (dataIsianKe) {
            case -1:
              provider.listMataUji[indexSection].arrSg3MataHasilIsian?[indexIsian].keterangan = value;
              return;
            case 1:
              provider.listMataUji[indexSection].arrSg3MataHasilIsian?[indexIsian].dataIsian1?.isi = value;
              break;
            case 2:
              provider.listMataUji[indexSection].arrSg3MataHasilIsian?[indexIsian].dataIsian2?.isi = value;
              break;
            case 3:
              provider.listMataUji[indexSection].arrSg3MataHasilIsian?[indexIsian].dataIsian3?.isi = value;
              break;
          }
        }
      }

      switch (data) {
        case null:
          return TextField(
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(hintText: "Masukkan keterangan disini"),
            controller: TextEditingController(text: value),
            onChanged: setValue,
          );
        case FormFieldType.picker:
          return DropdownButtonFormField(
            key: UniqueKey(),
            items: pilihan!.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
            initialValue: value,
            decoration: InputDecoration(hintText: "Pilih salah satu"),
            onChanged: setValue,
          );
        case FormFieldType.imageUpload:
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            spacing: 10,
            children: [
              Builder(builder: (context) {
                if (value != null) {
                  String previewValue = value is File ? value.path : value;
                  clog(previewValue);
                  final mimeType = lookupMimeType(previewValue);

                  if (mimeType != null && mimeType.startsWith("image/")) {
                    return Container(
                      decoration: BoxDecoration(color: Colors.grey.withValues(alpha: .1), borderRadius: BorderRadius.circular(10)),
                      child: Builder(builder: (context) {
                        if (value is File) {
                          return Image.file(File(previewValue), height: 200, fit: BoxFit.contain);
                        }
                        return Image.network(previewValue, height: 200, fit: BoxFit.contain);
                      }),
                    );
                  } else {
                    return Container(
                      height: 200,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Colors.grey.withValues(alpha: .1), borderRadius: BorderRadius.circular(10)),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.insert_drive_file, size: 120, color: Colors.grey.shade600),
                          SizedBox(height: 10),
                          Text(previewValue.split("/").last, style: textTheme(context).bodyMedium?.copyWith(color: Colors.grey), textAlign: TextAlign.center, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    );
                  }
                }
                return Container(
                  height: 200,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Colors.grey.withValues(alpha: .1), borderRadius: BorderRadius.circular(10)),
                  alignment: Alignment.center,
                  child: Icon(Icons.image, size: 120, color: Colors.grey.shade600),
                );
              }),
              Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: theme(context).dividerTheme.color!),
                ),
                child: Row(
                  children: [
                    CupertinoButton(
                      minSize: 0,
                      padding: EdgeInsets.zero,
                      onPressed: () => pickAttachment(context).then((value) {
                        setValue(value);
                        provider.refresh();
                      }),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        color: Colors.grey.withValues(alpha: .2),
                        child: Text("Browse", style: textTheme(context).bodyMedium),
                      ),
                    ),
                    RowDivider(),
                    Expanded(
                      child: Builder(builder: (context) {
                        if (value is String) {
                          return Text(value.split("/").last, overflow: TextOverflow.ellipsis);
                        }
                        return Text((value as File?)?.path.split("/").last ?? "No file selected", overflow: TextOverflow.ellipsis);
                      }),
                    ),
                    RowDivider(),
                    Icon(Icons.folder, color: Colors.grey.shade600),
                    RowDivider(),
                  ],
                ),
              ),
            ],
          );
        case FormFieldType.keterangan:
        case FormFieldType.text:
          return TextField(
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(hintText: "Masukkan keterangan disini"),
            controller: TextEditingController(text: value),
            onChanged: setValue,
          );
      }
    });
  }
}

class FormMataUjiProvider with ChangeNotifier {
  List<MataHasil> listMataUji;

  FormMataUjiProvider(this.listMataUji);

  void refresh() {
    notifyListeners();
  }
}
