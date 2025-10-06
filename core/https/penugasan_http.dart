import 'package:dio/dio.dart';
import 'package:mojang_nontr/core/https/http_connection.dart';
import 'package:mojang_nontr/core/models/form_lhpp/form_lhpp.dart';
import 'package:mojang_nontr/core/models/form_lhpp/mata_uji.dart';
import 'package:mojang_nontr/core/models/penugasan.dart';

import '../utils/logger.dart';

class PenugasanHttp extends HttpConnection {
  PenugasanHttp(super.context);

  /// - $1 Penugasan Baru
  /// - $2 Penugasan Selesai
  Future<(List<Penugasan>, List<Penugasan>)> getHomePenugasan() async {
    ApiResponse response = await get("/penugasan");
    return (
      (response.result['baru'] as List<dynamic>?)?.map((e) => Penugasan.fromJson(e as Map<String, dynamic>)).toList() ?? [],
      (response.result['selesai'] as List<dynamic>?)?.map((e) => Penugasan.fromJson(e as Map<String, dynamic>)).toList() ?? [],
    );
  }

  Future<FormLhpp> getDetailPenugasan(String noAgenda) async {
    ApiResponse response = await get("/form-lhpp", params: {
      "no_agenda": noAgenda,
    });
    return FormLhpp.fromJson(response.result as Map<String, dynamic>);
  }

  Future<void> submitFormLhpp(int permohonanUid, MataUji mataUji, List<MataHasil> mataHasil) async {
    clog(await mataUji.bodyToJson(permohonanUid, mataHasil));
    ApiResponse response = await post("/submit-lhpp-isian", body: FormData.fromMap(await mataUji.bodyToJson(permohonanUid, mataHasil)));
  }

  // Future<(List<Penugasan>, List<Penugasan>)> getHomePenugasan({
  //   int page = 1,
  //   int limit = 10,
  //   Position? currentPosition,
  //   String? statusPenugasan,
  //   String? typePenugasan,
  //   String? search,
  //   String? uidPermohonan,
  // }) async {
  //   ApiResponse response = await get("penugasan", params: {
  //     "page": "$page",
  //     "limit": "$limit",
  //     if (currentPosition != null) "current_latitude": "${currentPosition.latitude}",
  //     if (currentPosition != null) "current_longitude": "${currentPosition.longitude}",
  //     if (statusPenugasan != null) "status_penugasan": statusPenugasan,
  //     if (typePenugasan != null) "type_penugasan": typePenugasan,
  //     if (search != null) "search": search,
  //     if (uidPermohonan != null) "uid_permohonan": uidPermohonan,
  //   });
  // }
}
