import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mojang_nontr/core/models/model.dart';

class MataUji extends Model {
  final List<MataHasil>? mataHasil;
  final int? mataUjiUid;
  final int? tipeLayanan;
  final int? jenisInstalasiUid;
  final int? jenisLayananUid;
  final int? urutanTampilanLhppMataHasil;
  final dynamic createdAt;
  final dynamic createdBy;
  final dynamic updatedAt;
  final dynamic updatedBy;
  final dynamic deletedAt;
  final dynamic deletedBy;
  final String? isActive;
  final String? mataUji;
  final String? namaJenisInstalasi;
  final int? subBidangUid;
  final String? namaSubBidang;
  final int? bidangUid;
  final String? namaBidang;
  final int? jenisUsahaUid;
  final String? namaJenisUsaha;
  final String? namaJenisLayanan;
  final String? namaTipeLayanan;
  final List<HasilIsian>? arrSg3MataHasilIsian;
  final dynamic statusVerifikasi;
  final dynamic statusVerifikasiCatatan;
  final dynamic statusVerifikasiAt;
  final dynamic statusVerifikasiBy;
  final int? maxColIsian;
  final int? maxColKeterangan;
  final String? groupElementId;
  final dynamic lhppSloUid;
  final dynamic lhppSloIsSubmitted;

  MataUji({
    this.mataHasil,
    this.mataUjiUid,
    this.tipeLayanan,
    this.jenisInstalasiUid,
    this.jenisLayananUid,
    this.urutanTampilanLhppMataHasil,
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
    this.deletedAt,
    this.deletedBy,
    this.isActive,
    this.mataUji,
    this.namaJenisInstalasi,
    this.subBidangUid,
    this.namaSubBidang,
    this.bidangUid,
    this.namaBidang,
    this.jenisUsahaUid,
    this.namaJenisUsaha,
    this.namaJenisLayanan,
    this.namaTipeLayanan,
    this.arrSg3MataHasilIsian,
    this.statusVerifikasi,
    this.statusVerifikasiCatatan,
    this.statusVerifikasiAt,
    this.statusVerifikasiBy,
    this.maxColIsian,
    this.maxColKeterangan,
    this.groupElementId,
    this.lhppSloUid,
    this.lhppSloIsSubmitted,
  });

  MataUji copyWith({
    int? uidMataHasil,
    List<MataHasil>? mataHasil,
    int? mataUjiUid,
    int? tipeLayanan,
    int? jenisInstalasiUid,
    int? jenisLayananUid,
    int? urutanTampilanLhppMataHasil,
    dynamic createdAt,
    dynamic createdBy,
    dynamic updatedAt,
    dynamic updatedBy,
    dynamic deletedAt,
    dynamic deletedBy,
    String? isActive,
    String? mataUji,
    String? namaJenisInstalasi,
    int? subBidangUid,
    String? namaSubBidang,
    int? bidangUid,
    String? namaBidang,
    int? jenisUsahaUid,
    String? namaJenisUsaha,
    String? namaJenisLayanan,
    String? namaTipeLayanan,
    List<HasilIsian>? arrSg3MataHasilIsian,
    dynamic statusVerifikasi,
    dynamic statusVerifikasiCatatan,
    dynamic statusVerifikasiAt,
    dynamic statusVerifikasiBy,
    int? maxColIsian,
    int? maxColKeterangan,
    String? groupElementId,
    dynamic lhppSloUid,
    dynamic lhppSloIsSubmitted,
  }) =>
      MataUji(
        mataHasil: mataHasil ?? this.mataHasil,
        mataUjiUid: mataUjiUid ?? this.mataUjiUid,
        tipeLayanan: tipeLayanan ?? this.tipeLayanan,
        jenisInstalasiUid: jenisInstalasiUid ?? this.jenisInstalasiUid,
        jenisLayananUid: jenisLayananUid ?? this.jenisLayananUid,
        urutanTampilanLhppMataHasil: urutanTampilanLhppMataHasil ?? this.urutanTampilanLhppMataHasil,
        createdAt: createdAt ?? this.createdAt,
        createdBy: createdBy ?? this.createdBy,
        updatedAt: updatedAt ?? this.updatedAt,
        updatedBy: updatedBy ?? this.updatedBy,
        deletedAt: deletedAt ?? this.deletedAt,
        deletedBy: deletedBy ?? this.deletedBy,
        isActive: isActive ?? this.isActive,
        mataUji: mataUji ?? this.mataUji,
        namaJenisInstalasi: namaJenisInstalasi ?? this.namaJenisInstalasi,
        subBidangUid: subBidangUid ?? this.subBidangUid,
        namaSubBidang: namaSubBidang ?? this.namaSubBidang,
        bidangUid: bidangUid ?? this.bidangUid,
        namaBidang: namaBidang ?? this.namaBidang,
        jenisUsahaUid: jenisUsahaUid ?? this.jenisUsahaUid,
        namaJenisUsaha: namaJenisUsaha ?? this.namaJenisUsaha,
        namaJenisLayanan: namaJenisLayanan ?? this.namaJenisLayanan,
        namaTipeLayanan: namaTipeLayanan ?? this.namaTipeLayanan,
        arrSg3MataHasilIsian: arrSg3MataHasilIsian ?? this.arrSg3MataHasilIsian,
        statusVerifikasi: statusVerifikasi ?? this.statusVerifikasi,
        statusVerifikasiCatatan: statusVerifikasiCatatan ?? this.statusVerifikasiCatatan,
        statusVerifikasiAt: statusVerifikasiAt ?? this.statusVerifikasiAt,
        statusVerifikasiBy: statusVerifikasiBy ?? this.statusVerifikasiBy,
        maxColIsian: maxColIsian ?? this.maxColIsian,
        maxColKeterangan: maxColKeterangan ?? this.maxColKeterangan,
        groupElementId: groupElementId ?? this.groupElementId,
        lhppSloUid: lhppSloUid ?? this.lhppSloUid,
        lhppSloIsSubmitted: lhppSloIsSubmitted ?? this.lhppSloIsSubmitted,
      );

  factory MataUji.fromJson(Map<String, dynamic> json) {
    return MataUji(
      mataHasil: json["mata_hasil"] == null ? [] : List<MataHasil>.from(json["mata_hasil"]!.map((x) => MataHasil.fromJson(x))),
      mataUjiUid: json["uid_mata_uji"],
      tipeLayanan: json["tipe_layanan"],
      jenisInstalasiUid: json["jenis_instalasi_uid"],
      jenisLayananUid: json["jenis_layanan_uid"],
      urutanTampilanLhppMataHasil: json["urutan_tampilan_lhpp_mata_hasil"],
      createdAt: json["created_at"],
      createdBy: json["created_by"],
      updatedAt: json["updated_at"],
      updatedBy: json["updated_by"],
      deletedAt: json["deleted_at"],
      deletedBy: json["deleted_by"],
      isActive: json["is_active"],
      mataUji: json["mata_uji"],
      namaJenisInstalasi: json["nama_jenis_instalasi"],
      subBidangUid: json["sub_bidang_uid"],
      namaSubBidang: json["nama_sub_bidang"],
      bidangUid: json["bidang_uid"],
      namaBidang: json["nama_bidang"],
      jenisUsahaUid: json["jenis_usaha_uid"],
      namaJenisUsaha: json["nama_jenis_usaha"],
      namaJenisLayanan: json["nama_jenis_layanan"],
      namaTipeLayanan: json["nama_tipe_layanan"],
      arrSg3MataHasilIsian: json["arr_sg3_mata_hasil_isian"] == null ? [] : List<HasilIsian>.from(json["arr_sg3_mata_hasil_isian"]!.map((x) => HasilIsian.fromJson(x))),
      statusVerifikasi: json["status_verifikasi"],
      statusVerifikasiCatatan: json["status_verifikasi_catatan"],
      statusVerifikasiAt: json["status_verifikasi_at"],
      statusVerifikasiBy: json["status_verifikasi_by"],
      maxColIsian: json["max_col_isian"],
      maxColKeterangan: json["max_col_keterangan"],
      groupElementId: json["group_element_id"],
      lhppSloUid: json["lhpp_slo_uid"],
      lhppSloIsSubmitted: json["lhpp_slo_is_submitted"],
    );
  }

  Future<Map<String, dynamic>> bodyToJson(int permohonanUid, List<MataHasil> mataHasilData) async {
    Map<String, dynamic> body = {};
    for (MataHasil item in mataHasilData) {
      for (HasilIsian isian in item.arrSg3MataHasilIsian ?? []) {
        String keyIsian1 = "lhpp_isian[${isian.lhppSloUid ?? "new"}][${isian.uidMataHasilIsian}][1][]";
        String keyIsian2 = "lhpp_isian[${isian.lhppSloUid ?? "new"}][${isian.uidMataHasilIsian}][2][]";
        String keyIsian3 = "lhpp_isian[${isian.lhppSloUid ?? "new"}][${isian.uidMataHasilIsian}][3][]";
        String keyKeterangan = "lhpp_isian[${isian.lhppSloUid ?? "new"}][${isian.uidMataHasilIsian}][keterangan][0]";

        body[keyIsian1] = [];
        body[keyIsian2] = [];
        body[keyIsian3] = [];

        if (isian.dataIsian1?.isi != null) {
          if (isian.dataIsian1!.isi is File) {
            body[keyIsian1].add(await MultipartFile.fromFile(isian.dataIsian1!.isi!.path, filename: isian.dataIsian1!.isi!.path.split('/').last));
            // body[keyIsian1] = isian.dataIsian1!.isi!.path;
          } else {
            if (isian.dataIsian1!.isi!.isNotEmpty) {
              body[keyIsian1].add(isian.dataIsian1?.isi ?? "");
              // body[keyIsian1] = isian.dataIsian1?.isi ?? "";
            }
          }
        }
        if (isian.dataIsian2?.isi != null) {
          if (isian.dataIsian2!.isi is File) {
            body[keyIsian2].add(await MultipartFile.fromFile(isian.dataIsian2!.isi!.path, filename: isian.dataIsian2!.isi!.path.split('/').last));
            // body[keyIsian2] = await MultipartFile.fromFile(isian.dataIsian2!.isi!.path, filename: isian.dataIsian2!.isi!.path.split('/').last);
            // body[keyIsian2] = isian.dataIsian2!.isi!.path;
          } else {
            if (isian.dataIsian2!.isi!.isNotEmpty) {
              body[keyIsian2].add(isian.dataIsian2?.isi ?? "");
              // body[keyIsian2] = isian.dataIsian2?.isi ?? "";
            }
          }
        }
        if (isian.dataIsian3?.isi != null) {
          if (isian.dataIsian3!.isi is File) {
            body[keyIsian3].add(await MultipartFile.fromFile(isian.dataIsian3!.isi!.path, filename: isian.dataIsian3!.isi!.path.split('/').last));
            // body[keyIsian3] = await MultipartFile.fromFile(isian.dataIsian3!.isi!.path, filename: isian.dataIsian3!.isi!.path.split('/').last);
            // body[keyIsian3] = isian.dataIsian3!.isi!.path;
          } else {
            if (isian.dataIsian3!.isi!.isNotEmpty) {
              body[keyIsian3].add(isian.dataIsian3?.isi ?? "");
              // body[keyIsian3] = isian.dataIsian2?.isi ?? "";
            }
          }
        }

        if (isian.children.isNotEmpty) {
          for (int i = 0; i < isian.children.length; i++) {
            HasilIsian child = isian.children[i];

            if (child.dataIsian1?.isi != null) {
              if (child.dataIsian1!.isi is File) {
                body[keyIsian1].add(await MultipartFile.fromFile(child.dataIsian1!.isi!.path));
                // body[keyIsian1] = await MultipartFile.fromFile(child.dataIsian1!.isi!.path);
              } else {
                if (child.dataIsian1!.isi!.isNotEmpty) {
                  body[keyIsian1].add(child.dataIsian1?.isi ?? "");
                  // body[keyIsian1] = child.dataIsian1?.isi ?? "";
                }
              }
            }
            if (child.dataIsian2?.isi != null) {
              if (child.dataIsian2!.isi is File) {
                // body[keyIsian2] = await MultipartFile.fromFile(child.dataIsian2!.isi!.path);
                body[keyIsian2].add(await MultipartFile.fromFile(child.dataIsian2!.isi!.path));
              } else {
                if (child.dataIsian2!.isi!.isNotEmpty) {
                  // body[keyIsian2] = child.dataIsian2?.isi ?? "";
                  body[keyIsian2].add(child.dataIsian2?.isi ?? "");
                }
              }
            }
            if (child.dataIsian3?.isi != null) {
              if (child.dataIsian3!.isi is File) {
                // body[keyIsian3] = await MultipartFile.fromFile(child.dataIsian3!.isi!.path);
                body[keyIsian3].add(await MultipartFile.fromFile(child.dataIsian3!.isi!.path));
              } else {
                if (child.dataIsian3!.isi!.isNotEmpty) {
                  // body[keyIsian3] = child.dataIsian3?.isi ?? "";
                  body[keyIsian3].add(child.dataIsian3?.isi ?? "");
                }
              }
            }
            if (child.isianKeterangan == true && child.keterangan.isNotEmpty) {
              body[keyKeterangan] = (child.keterangan.toString());
            }
          }
        }

        if (isian.isianKeterangan == true && isian.keterangan.isNotEmpty) {
          body[keyKeterangan] = (isian.keterangan.toString());
        }
      }
    }
    return {
      "submit_mode": "draft",
      "permohonan_uid": permohonanUid,
      "mata_hasil_uid": mataHasilData.first.uidMataHasil,
      ...body,
    };
  }

  @override
  Map<String, dynamic> toJson() => {
        "mata_hasil": mataHasil,
        "uid_mata_uji": mataUjiUid,
        "tipe_layanan": tipeLayanan,
        "jenis_instalasi_uid": jenisInstalasiUid,
        "jenis_layanan_uid": jenisLayananUid,
        "urutan_tampilan_lhpp_mata_hasil": urutanTampilanLhppMataHasil,
        "created_at": createdAt,
        "created_by": createdBy,
        "updated_at": updatedAt,
        "updated_by": updatedBy,
        "deleted_at": deletedAt,
        "deleted_by": deletedBy,
        "is_active": isActive,
        "mata_uji": mataUji,
        "nama_jenis_instalasi": namaJenisInstalasi,
        "sub_bidang_uid": subBidangUid,
        "nama_sub_bidang": namaSubBidang,
        "bidang_uid": bidangUid,
        "nama_bidang": namaBidang,
        "jenis_usaha_uid": jenisUsahaUid,
        "nama_jenis_usaha": namaJenisUsaha,
        "nama_jenis_layanan": namaJenisLayanan,
        "nama_tipe_layanan": namaTipeLayanan,
        "arr_sg3_mata_hasil_isian": arrSg3MataHasilIsian == null ? [] : List<dynamic>.from(arrSg3MataHasilIsian!.map((x) => x.toJson())),
        "status_verifikasi": statusVerifikasi,
        "status_verifikasi_catatan": statusVerifikasiCatatan,
        "status_verifikasi_at": statusVerifikasiAt,
        "status_verifikasi_by": statusVerifikasiBy,
        "max_col_isian": maxColIsian,
        "max_col_keterangan": maxColKeterangan,
        "group_element_id": groupElementId,
        "lhpp_slo_uid": lhppSloUid,
        "lhpp_slo_is_submitted": lhppSloIsSubmitted,
      };
}

class MataHasil {
  final int? uidMataHasil;
  final String? mataHasil;
  final int? mataUjiUid;
  final int? tipeLayanan;
  final int? jenisInstalasiUid;
  final int? jenisLayananUid;
  final int? urutanTampilanLhppMataHasil;
  final dynamic createdAt;
  final dynamic createdBy;
  final dynamic updatedAt;
  final dynamic updatedBy;
  final dynamic deletedAt;
  final dynamic deletedBy;
  final String? isActive;
  final String? mataUji;
  final String? namaJenisInstalasi;
  final int? subBidangUid;
  final String? namaSubBidang;
  final int? bidangUid;
  final String? namaBidang;
  final int? jenisUsahaUid;
  final String? namaJenisUsaha;
  final String? namaJenisLayanan;
  final String? namaTipeLayanan;
  final List<HasilIsian>? arrSg3MataHasilIsian;
  final dynamic statusVerifikasi;
  final dynamic statusVerifikasiCatatan;
  final dynamic statusVerifikasiAt;
  final dynamic statusVerifikasiBy;
  final int? maxColIsian;
  final int? maxColKeterangan;
  final String? groupElementId;
  final dynamic lhppSloUid;
  final dynamic lhppSloIsSubmitted;

  MataHasil({
    this.uidMataHasil,
    this.mataHasil,
    this.mataUjiUid,
    this.tipeLayanan,
    this.jenisInstalasiUid,
    this.jenisLayananUid,
    this.urutanTampilanLhppMataHasil,
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
    this.deletedAt,
    this.deletedBy,
    this.isActive,
    this.mataUji,
    this.namaJenisInstalasi,
    this.subBidangUid,
    this.namaSubBidang,
    this.bidangUid,
    this.namaBidang,
    this.jenisUsahaUid,
    this.namaJenisUsaha,
    this.namaJenisLayanan,
    this.namaTipeLayanan,
    this.arrSg3MataHasilIsian,
    this.statusVerifikasi,
    this.statusVerifikasiCatatan,
    this.statusVerifikasiAt,
    this.statusVerifikasiBy,
    this.maxColIsian,
    this.maxColKeterangan,
    this.groupElementId,
    this.lhppSloUid,
    this.lhppSloIsSubmitted,
  });

  MataHasil copyWith({
    int? uidMataHasil,
    String? mataHasil,
    int? mataUjiUid,
    int? tipeLayanan,
    int? jenisInstalasiUid,
    int? jenisLayananUid,
    int? urutanTampilanLhppMataHasil,
    dynamic createdAt,
    dynamic createdBy,
    dynamic updatedAt,
    dynamic updatedBy,
    dynamic deletedAt,
    dynamic deletedBy,
    String? isActive,
    String? mataUji,
    String? namaJenisInstalasi,
    int? subBidangUid,
    String? namaSubBidang,
    int? bidangUid,
    String? namaBidang,
    int? jenisUsahaUid,
    String? namaJenisUsaha,
    String? namaJenisLayanan,
    String? namaTipeLayanan,
    List<HasilIsian>? arrSg3MataHasilIsian,
    dynamic statusVerifikasi,
    dynamic statusVerifikasiCatatan,
    dynamic statusVerifikasiAt,
    dynamic statusVerifikasiBy,
    int? maxColIsian,
    int? maxColKeterangan,
    String? groupElementId,
    dynamic lhppSloUid,
    dynamic lhppSloIsSubmitted,
  }) =>
      MataHasil(
        uidMataHasil: uidMataHasil ?? this.uidMataHasil,
        mataHasil: mataHasil ?? this.mataHasil,
        mataUjiUid: mataUjiUid ?? this.mataUjiUid,
        tipeLayanan: tipeLayanan ?? this.tipeLayanan,
        jenisInstalasiUid: jenisInstalasiUid ?? this.jenisInstalasiUid,
        jenisLayananUid: jenisLayananUid ?? this.jenisLayananUid,
        urutanTampilanLhppMataHasil: urutanTampilanLhppMataHasil ?? this.urutanTampilanLhppMataHasil,
        createdAt: createdAt ?? this.createdAt,
        createdBy: createdBy ?? this.createdBy,
        updatedAt: updatedAt ?? this.updatedAt,
        updatedBy: updatedBy ?? this.updatedBy,
        deletedAt: deletedAt ?? this.deletedAt,
        deletedBy: deletedBy ?? this.deletedBy,
        isActive: isActive ?? this.isActive,
        mataUji: mataUji ?? this.mataUji,
        namaJenisInstalasi: namaJenisInstalasi ?? this.namaJenisInstalasi,
        subBidangUid: subBidangUid ?? this.subBidangUid,
        namaSubBidang: namaSubBidang ?? this.namaSubBidang,
        bidangUid: bidangUid ?? this.bidangUid,
        namaBidang: namaBidang ?? this.namaBidang,
        jenisUsahaUid: jenisUsahaUid ?? this.jenisUsahaUid,
        namaJenisUsaha: namaJenisUsaha ?? this.namaJenisUsaha,
        namaJenisLayanan: namaJenisLayanan ?? this.namaJenisLayanan,
        namaTipeLayanan: namaTipeLayanan ?? this.namaTipeLayanan,
        arrSg3MataHasilIsian: arrSg3MataHasilIsian ?? this.arrSg3MataHasilIsian,
        statusVerifikasi: statusVerifikasi ?? this.statusVerifikasi,
        statusVerifikasiCatatan: statusVerifikasiCatatan ?? this.statusVerifikasiCatatan,
        statusVerifikasiAt: statusVerifikasiAt ?? this.statusVerifikasiAt,
        statusVerifikasiBy: statusVerifikasiBy ?? this.statusVerifikasiBy,
        maxColIsian: maxColIsian ?? this.maxColIsian,
        maxColKeterangan: maxColKeterangan ?? this.maxColKeterangan,
        groupElementId: groupElementId ?? this.groupElementId,
        lhppSloUid: lhppSloUid ?? this.lhppSloUid,
        lhppSloIsSubmitted: lhppSloIsSubmitted ?? this.lhppSloIsSubmitted,
      );

  factory MataHasil.fromJson(Map<String, dynamic> json) => MataHasil(
        uidMataHasil: json["uid_mata_hasil"],
        mataHasil: json["mata_hasil"],
        mataUjiUid: json["mata_uji_uid"],
        tipeLayanan: json["tipe_layanan"],
        jenisInstalasiUid: json["jenis_instalasi_uid"],
        jenisLayananUid: json["jenis_layanan_uid"],
        urutanTampilanLhppMataHasil: json["urutan_tampilan_lhpp_mata_hasil"],
        createdAt: json["created_at"],
        createdBy: json["created_by"],
        updatedAt: json["updated_at"],
        updatedBy: json["updated_by"],
        deletedAt: json["deleted_at"],
        deletedBy: json["deleted_by"],
        isActive: json["is_active"],
        mataUji: json["mata_uji"],
        namaJenisInstalasi: json["nama_jenis_instalasi"],
        subBidangUid: json["sub_bidang_uid"],
        namaSubBidang: json["nama_sub_bidang"],
        bidangUid: json["bidang_uid"],
        namaBidang: json["nama_bidang"],
        jenisUsahaUid: json["jenis_usaha_uid"],
        namaJenisUsaha: json["nama_jenis_usaha"],
        namaJenisLayanan: json["nama_jenis_layanan"],
        namaTipeLayanan: json["nama_tipe_layanan"],
        arrSg3MataHasilIsian: json["arr_sg3_mata_hasil_isian"] == null ? [] : List<HasilIsian>.from(json["arr_sg3_mata_hasil_isian"]!.map((x) => HasilIsian.fromJson(x))),
        statusVerifikasi: json["status_verifikasi"],
        statusVerifikasiCatatan: json["status_verifikasi_catatan"],
        statusVerifikasiAt: json["status_verifikasi_at"],
        statusVerifikasiBy: json["status_verifikasi_by"],
        maxColIsian: json["max_col_isian"],
        maxColKeterangan: json["max_col_keterangan"],
        groupElementId: json["group_element_id"],
        lhppSloUid: json["lhpp_slo_uid"],
        lhppSloIsSubmitted: json["lhpp_slo_is_submitted"],
      );

  Map<String, dynamic> toJson() => {
        "uid_mata_hasil": uidMataHasil,
        "mata_hasil": mataHasil,
        "mata_uji_uid": mataUjiUid,
        "tipe_layanan": tipeLayanan,
        "jenis_instalasi_uid": jenisInstalasiUid,
        "jenis_layanan_uid": jenisLayananUid,
        "urutan_tampilan_lhpp_mata_hasil": urutanTampilanLhppMataHasil,
        "created_at": createdAt,
        "created_by": createdBy,
        "updated_at": updatedAt,
        "updated_by": updatedBy,
        "deleted_at": deletedAt,
        "deleted_by": deletedBy,
        "is_active": isActive,
        "mata_uji": mataUji,
        "nama_jenis_instalasi": namaJenisInstalasi,
        "sub_bidang_uid": subBidangUid,
        "nama_sub_bidang": namaSubBidang,
        "bidang_uid": bidangUid,
        "nama_bidang": namaBidang,
        "jenis_usaha_uid": jenisUsahaUid,
        "nama_jenis_usaha": namaJenisUsaha,
        "nama_jenis_layanan": namaJenisLayanan,
        "nama_tipe_layanan": namaTipeLayanan,
        "arr_sg3_mata_hasil_isian": arrSg3MataHasilIsian == null ? [] : List<dynamic>.from(arrSg3MataHasilIsian!.map((x) => x.toJson())),
        "status_verifikasi": statusVerifikasi,
        "status_verifikasi_catatan": statusVerifikasiCatatan,
        "status_verifikasi_at": statusVerifikasiAt,
        "status_verifikasi_by": statusVerifikasiBy,
        "max_col_isian": maxColIsian,
        "max_col_keterangan": maxColKeterangan,
        "group_element_id": groupElementId,
        "lhpp_slo_uid": lhppSloUid,
        "lhpp_slo_is_submitted": lhppSloIsSubmitted,
      };
}

// ignore: must_be_immutable
class HasilIsian extends Model {
  final int key;
  final int? uidMataHasilIsian;
  final int? mataHasilUid;
  final String? textDataIsian;
  final String? subTextDataIsian;
  final DataIsian? dataIsian1;
  final DataIsian? dataIsian2;
  final DataIsian? dataIsian3;
  final bool? tampilDiSertifikat;
  final int? urutanTampilDiSertifikat;
  final int? urutanTampilanLhppMataHasilIsian;
  final bool? isianKeterangan;
  final bool? tambahIsian;
  final bool? removable;
  final dynamic createdAt;
  final dynamic updatedAt;
  final dynamic deletedAt;
  final dynamic mataHasilIsianUid;
  final dynamic lhppSloUid;
  final bool isSubmitted;
  final dynamic uidLhppSloDetail;
  String keterangan;
  final dynamic statusVerifikasi;
  final dynamic statusVerifikasiCatatan;
  final dynamic statusVerifikasiAt;
  final dynamic statusVerifikasiBy;
  final List<String>? arrPilihan1;
  final List<String>? arrPilihan2;
  final List<String>? arrPilihan3;
  final int? colTotal;
  final int? colIsian;
  final List<HasilIsian> children = [];

  HasilIsian({
    this.key = 0,
    this.uidMataHasilIsian,
    this.mataHasilUid,
    this.textDataIsian,
    this.subTextDataIsian,
    this.dataIsian1,
    this.dataIsian2,
    this.dataIsian3,
    this.removable,
    this.tampilDiSertifikat,
    this.urutanTampilDiSertifikat,
    this.urutanTampilanLhppMataHasilIsian,
    this.isianKeterangan,
    this.tambahIsian,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.mataHasilIsianUid,
    this.lhppSloUid,
    this.isSubmitted = false,
    this.uidLhppSloDetail,
    this.keterangan = "",
    this.statusVerifikasi,
    this.statusVerifikasiCatatan,
    this.statusVerifikasiAt,
    this.statusVerifikasiBy,
    this.arrPilihan1,
    this.arrPilihan2,
    this.arrPilihan3,
    this.colTotal,
    this.colIsian,
  });

  HasilIsian copyWith({
    int? key,
    int? uidMataHasilIsian,
    int? mataHasilUid,
    String? textDataIsian,
    String? subTextDataIsian,
    FormFieldType? jenisDataIsian1,
    DataIsian? dataIsian1,
    DataIsian? dataIsian2,
    DataIsian? dataIsian3,
    bool? tampilDiSertifikat,
    int? urutanTampilDiSertifikat,
    int? urutanTampilanLhppMataHasilIsian,
    bool? isianKeterangan,
    bool? tambahIsian,
    bool? removable,
    dynamic createdAt,
    dynamic updatedAt,
    dynamic deletedAt,
    dynamic mataHasilIsianUid,
    dynamic lhppSloUid,
    bool? isSubmitted = true,
    dynamic uidLhppSloDetail,
    dynamic keterangan,
    dynamic statusVerifikasi,
    dynamic statusVerifikasiCatatan,
    dynamic statusVerifikasiAt,
    dynamic statusVerifikasiBy,
    List<String>? arrPilihan1,
    List<String>? arrPilihan2,
    List<String>? arrPilihan3,
    int? colTotal,
    int? colIsian,
  }) =>
      HasilIsian(
        uidMataHasilIsian: uidMataHasilIsian ?? this.uidMataHasilIsian,
        mataHasilUid: mataHasilUid ?? this.mataHasilUid,
        textDataIsian: textDataIsian ?? this.textDataIsian,
        subTextDataIsian: subTextDataIsian ?? this.subTextDataIsian,
        dataIsian1: dataIsian1 ?? this.dataIsian1,
        dataIsian2: dataIsian2 ?? this.dataIsian2,
        dataIsian3: dataIsian3 ?? this.dataIsian3,
        tampilDiSertifikat: tampilDiSertifikat ?? this.tampilDiSertifikat,
        urutanTampilDiSertifikat: urutanTampilDiSertifikat ?? this.urutanTampilDiSertifikat,
        urutanTampilanLhppMataHasilIsian: urutanTampilanLhppMataHasilIsian ?? this.urutanTampilanLhppMataHasilIsian,
        isianKeterangan: isianKeterangan ?? this.isianKeterangan,
        tambahIsian: tambahIsian ?? this.tambahIsian,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt ?? this.deletedAt,
        mataHasilIsianUid: mataHasilIsianUid ?? this.mataHasilIsianUid,
        lhppSloUid: lhppSloUid ?? this.lhppSloUid,
        isSubmitted: isSubmitted ?? this.isSubmitted,
        uidLhppSloDetail: uidLhppSloDetail ?? this.uidLhppSloDetail,
        keterangan: keterangan ?? this.keterangan,
        statusVerifikasi: statusVerifikasi ?? this.statusVerifikasi,
        statusVerifikasiCatatan: statusVerifikasiCatatan ?? this.statusVerifikasiCatatan,
        statusVerifikasiAt: statusVerifikasiAt ?? this.statusVerifikasiAt,
        statusVerifikasiBy: statusVerifikasiBy ?? this.statusVerifikasiBy,
        arrPilihan1: arrPilihan1 ?? this.arrPilihan1,
        arrPilihan2: arrPilihan2 ?? this.arrPilihan2,
        arrPilihan3: arrPilihan3 ?? this.arrPilihan3,
        colTotal: colTotal ?? this.colTotal,
        colIsian: colIsian ?? this.colIsian,
        removable: removable ?? this.removable,
        key: key ?? this.key,
      );

  HasilIsian fresh() => copyWith(
        dataIsian1: null,
        dataIsian2: null,
        dataIsian3: null,
        key: key + 1,

        // dataIsian1: dataIsian1?.copyWith(isi: null),
        // dataIsian2: dataIsian2?.copyWith(isi: null),
        // dataIsian3: dataIsian3?.copyWith(isi: null),
      );

  factory HasilIsian.fromJson(Map<String, dynamic> json) => HasilIsian(
        uidMataHasilIsian: json["uid_mata_hasil_isian"],
        mataHasilUid: json["mata_hasil_uid"],
        textDataIsian: json["text_data_isian"],
        subTextDataIsian: json["sub_text_data_isian"],
        dataIsian1: FormFieldType.fromString(json["jenis_data_isian_1"]) == null ? null : DataIsian.fromJson(1, json),
        dataIsian2: FormFieldType.fromString(json["jenis_data_isian_2"]) == null ? null : DataIsian.fromJson(2, json),
        dataIsian3: FormFieldType.fromString(json["jenis_data_isian_3"]) == null ? null : DataIsian.fromJson(3, json),
        tampilDiSertifikat: json["tampil_di_sertifikat"],
        urutanTampilDiSertifikat: json["urutan_tampil_di_sertifikat"],
        urutanTampilanLhppMataHasilIsian: json["urutan_tampilan_lhpp_mata_hasil_isian"],
        isianKeterangan: json["isian_keterangan"] == "1",
        tambahIsian: json["tambah_isian"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        deletedAt: json["deleted_at"],
        mataHasilIsianUid: json["mata_hasil_isian_uid"],
        lhppSloUid: json["lhpp_slo_uid"],
        isSubmitted: json["is_submitted"] == "1",
        uidLhppSloDetail: json["uid_lhpp_slo_detail"],
        keterangan: json["keterangan"] ?? "",
        statusVerifikasi: json["status_verifikasi"],
        statusVerifikasiCatatan: json["status_verifikasi_catatan"],
        statusVerifikasiAt: json["status_verifikasi_at"],
        statusVerifikasiBy: json["status_verifikasi_by"],
        arrPilihan1: json["arr_pilihan_1"] == null ? [] : List<String>.from(json["arr_pilihan_1"]!.map((x) => x)),
        arrPilihan2: json["arr_pilihan_2"] == null ? [] : List<String>.from(json["arr_pilihan_2"]!.map((x) => x)),
        arrPilihan3: json["arr_pilihan_3"] == null ? [] : List<String>.from(json["arr_pilihan_3"]!.map((x) => x)),
        colTotal: json["_col_total"],
        colIsian: json["_col_isian"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "key": key,
        "uid_mata_hasil_isian": uidMataHasilIsian,
        "mata_hasil_uid": mataHasilUid,
        "text_data_isian": textDataIsian,
        "sub_text_data_isian": subTextDataIsian,
        "data_isian_1": dataIsian1?.toJson(),
        "data_isian_2": dataIsian2?.toJson(),
        "data_isian_3": dataIsian3?.toJson(),
        "is_active_1": (dataIsian1?.isActive ?? false) ? "1" : "0",
        "is_active_2": (dataIsian2?.isActive ?? false) ? "1" : "0",
        "is_active_3": (dataIsian3?.isActive ?? false) ? "1" : "0",
        "pilihan_1": jsonEncode(dataIsian1?.pilihan),
        "pilihan_2": jsonEncode(dataIsian1?.pilihan),
        "pilihan_3": jsonEncode(dataIsian1?.pilihan),
        "mandatory_1": dataIsian1?.mandatory,
        "mandatory_2": dataIsian2?.mandatory,
        "mandatory_3": dataIsian3?.mandatory,
        "jenis_data_isian_1": dataIsian1?.jenisDataIsian?.name,
        "jenis_data_isian_2": dataIsian2?.jenisDataIsian?.name,
        "jenis_data_isian_3": dataIsian3?.jenisDataIsian?.name,
        "tampil_di_sertifikat": tampilDiSertifikat,
        "urutan_tampil_di_sertifikat": urutanTampilDiSertifikat,
        "urutan_tampilan_lhpp_mata_hasil_isian": urutanTampilanLhppMataHasilIsian,
        "isian_keterangan": isianKeterangan,
        "tambah_isian": tambahIsian,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "deleted_at": deletedAt,
        "mata_hasil_isian_uid": mataHasilIsianUid,
        "lhpp_slo_uid": lhppSloUid,
        "is_submitted": isSubmitted,
        "uid_lhpp_slo_detail": uidLhppSloDetail,
        "keterangan": keterangan,
        "status_verifikasi": statusVerifikasi,
        "status_verifikasi_catatan": statusVerifikasiCatatan,
        "status_verifikasi_at": statusVerifikasiAt,
        "status_verifikasi_by": statusVerifikasiBy,
        "arr_pilihan_1": arrPilihan1 == null ? [] : List<dynamic>.from(arrPilihan1!.map((x) => x)),
        "arr_pilihan_2": arrPilihan2 == null ? [] : List<dynamic>.from(arrPilihan2!.map((x) => x)),
        "arr_pilihan_3": arrPilihan3 == null ? [] : List<dynamic>.from(arrPilihan3!.map((x) => x)),
        "_col_total": colTotal,
        "_col_isian": colIsian,
      };
}

class DataIsian {
  final FormFieldType? jenisDataIsian;
  final bool? isActive;
  final List<String>? pilihan;
  final bool? mandatory;
  dynamic isi;

  DataIsian({
    this.jenisDataIsian,
    this.isActive,
    this.pilihan,
    this.mandatory,
    this.isi,
  });

  DataIsian copyWith({
    FormFieldType? jenisDataIsian,
    bool? isActive,
    List<String>? pilihan,
    bool? mandatory,
    dynamic isi,
  }) =>
      DataIsian(
        jenisDataIsian: jenisDataIsian ?? this.jenisDataIsian,
        isActive: isActive ?? this.isActive,
        pilihan: pilihan ?? this.pilihan,
        mandatory: mandatory ?? this.mandatory,
        isi: isi,
      );

  factory DataIsian.fromJson(int number, Map<String, dynamic> json) => DataIsian(
        jenisDataIsian: FormFieldType.fromString(json["jenis_data_isian_$number"]),
        isActive: json["is_active_$number"] == "1",
        pilihan: json["pilihan_$number"] != null ? List<String>.from(jsonDecode(json["pilihan_$number"])!.map((x) => x)) : null,
        mandatory: json["mandatory_$number"],
        isi: (json["isi_$number"].toString().trim().isEmpty || json["isi_$number"].toString() == "null") ? null : json["isi_$number"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "jenis_data_isian": jenisDataIsian?.name,
        "is_active": isActive,
        "pilihan": pilihan,
        "mandatory": mandatory,
        "isi": isi,
      };
}

enum FormFieldType {
  picker("Pilihan"),
  imageUpload("Upload Dokumen"),
  text("Text"),
  keterangan("Keterangan");

  final String name;

  const FormFieldType(this.name);

  static FormFieldType? fromString(String? type) {
    switch (type?.toLowerCase().replaceAll(" ", "_")) {
      case 'pilihan':
        return FormFieldType.picker;
      case 'upload_dokumen':
        return FormFieldType.imageUpload;
      case 'text':
        return FormFieldType.text;
      default:
        return null;
    }
  }
}
