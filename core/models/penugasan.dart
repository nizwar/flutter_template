import 'package:latlong2/latlong.dart';
import 'package:mojang_nontr/core/models/model.dart';

class Penugasan extends Model {
  final String uidPermohonan;
  final String namaPelanggan;
  final String namaBadanUsaha;
  final DateTime? tglPengajuan;
  final String noAgenda;
  final String namaPemohon;
  final String noTelp;
  final String noPonsel;
  final int besaranKapasitasUid;
  final DateTime? tglPermohonan;
  final String alamatInstalasi;
  final int kotaUid;
  final int kecamatanUid;
  final int kelurahanUid;
  final double latitude;
  final double longitude;
  final int tipeLayanan;
  final String selisih;
  final String namaTipeLayanan;
  final String namaJenisInstalasi;
  final int uidJenisInstalasi;
  final String typePenugasan;
  final String statusPenugasan;
  final String? besarKapasitas;

  Penugasan({
    required this.uidPermohonan,
    required this.namaPelanggan,
    required this.namaBadanUsaha,
    required this.tglPengajuan,
    required this.noAgenda,
    required this.namaPemohon,
    required this.noTelp,
    required this.noPonsel,
    required this.besaranKapasitasUid,
    required this.tglPermohonan,
    required this.alamatInstalasi,
    required this.kotaUid,
    required this.kecamatanUid,
    required this.kelurahanUid,
    required this.latitude,
    required this.longitude,
    required this.tipeLayanan,
    required this.selisih,
    required this.namaTipeLayanan,
    required this.namaJenisInstalasi,
    required this.uidJenisInstalasi,
    required this.typePenugasan,
    required this.statusPenugasan,
    this.besarKapasitas,
  });

  // Computed property for LatLng location
  LatLng get lokasi => LatLng(latitude, longitude);

  factory Penugasan.fromJson(Map<String, dynamic> json) {
    return Penugasan(
      uidPermohonan: json['uid_permohonan'] ?? 0,
      namaPelanggan: json['nama_pelanggan'] ?? '',
      namaBadanUsaha: json['nama_badan_usaha'] ?? '',
      tglPengajuan: json['tgl_pengajuan'] != null ? DateTime.parse(json['tgl_pengajuan']) : null,
      noAgenda: json['no_agenda'] ?? '',
      namaPemohon: json['nama_pemohon'] ?? '',
      noTelp: json['no_telp'] ?? '',
      noPonsel: json['no_ponsel'] ?? '',
      besaranKapasitasUid: json['besaran_kapasitas_uid'] ?? 0,
      tglPermohonan: json['tgl_permohonan'] != null ? DateTime.parse(json['tgl_permohonan']) : null,
      alamatInstalasi: json['alamat_instalasi'] ?? '',
      kotaUid: json['kota_uid'] ?? 0,
      kecamatanUid: json['kecamatan_uid'] ?? 0,
      kelurahanUid: json['kelurahan_uid'] ?? 0,
      latitude: double.tryParse(json['latitude']?.toString() ?? '0') ?? 0.0,
      longitude: double.tryParse(json['longitude']?.toString() ?? '0') ?? 0.0,
      tipeLayanan: json['tipe_layanan'] ?? 0,
      selisih: json['selisih'] ?? '',
      namaTipeLayanan: json['nama_tipe_layanan'] ?? '',
      namaJenisInstalasi: json['nama_jenis_instalasi'] ?? '',
      uidJenisInstalasi: json['uid_jenis_instalasi'] ?? 0,
      typePenugasan: json['type_penugasan'] ?? '',
      statusPenugasan: json['status_penugasan'] ?? '',
      besarKapasitas: json['besar_kapasitas']?.toString(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'uid_permohonan': uidPermohonan,
      'nama_pelanggan': namaPelanggan,
      'nama_badan_usaha': namaBadanUsaha,
      'tgl_pengajuan': tglPengajuan,
      'no_agenda': noAgenda,
      'nama_pemohon': namaPemohon,
      'no_telp': noTelp,
      'no_ponsel': noPonsel,
      'besaran_kapasitas_uid': besaranKapasitasUid,
      'tgl_permohonan': tglPermohonan,
      'alamat_instalasi': alamatInstalasi,
      'kota_uid': kotaUid,
      'kecamatan_uid': kecamatanUid,
      'kelurahan_uid': kelurahanUid,
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'tipe_layanan': tipeLayanan,
      'selisih': selisih,
      'nama_tipe_layanan': namaTipeLayanan,
      'nama_jenis_instalasi': namaJenisInstalasi,
      'uid_jenis_instalasi': uidJenisInstalasi,
      'type_penugasan': typePenugasan,
      'status_penugasan': statusPenugasan,
      'besar_kapasitas': besarKapasitas,
    };
  }

  Penugasan copyWith({
    String? uidPermohonan,
    String? namaPelanggan,
    String? namaBadanUsaha,
    DateTime? tglPengajuan,
    String? noAgenda,
    String? namaPemohon,
    String? noTelp,
    String? noPonsel,
    int? besaranKapasitasUid,
    DateTime? tglPermohonan,
    String? alamatInstalasi,
    int? kotaUid,
    int? kecamatanUid,
    int? kelurahanUid,
    double? latitude,
    double? longitude,
    int? tipeLayanan,
    String? selisih,
    String? namaTipeLayanan,
    String? namaJenisInstalasi,
    int? uidJenisInstalasi,
    String? typePenugasan,
    String? statusPenugasan,
    String? besarKapasitas,
  }) {
    return Penugasan(
      uidPermohonan: uidPermohonan ?? this.uidPermohonan,
      namaPelanggan: namaPelanggan ?? this.namaPelanggan,
      namaBadanUsaha: namaBadanUsaha ?? this.namaBadanUsaha,
      tglPengajuan: tglPengajuan ?? this.tglPengajuan,
      noAgenda: noAgenda ?? this.noAgenda,
      namaPemohon: namaPemohon ?? this.namaPemohon,
      noTelp: noTelp ?? this.noTelp,
      noPonsel: noPonsel ?? this.noPonsel,
      besaranKapasitasUid: besaranKapasitasUid ?? this.besaranKapasitasUid,
      tglPermohonan: tglPermohonan ?? this.tglPermohonan,
      alamatInstalasi: alamatInstalasi ?? this.alamatInstalasi,
      kotaUid: kotaUid ?? this.kotaUid,
      kecamatanUid: kecamatanUid ?? this.kecamatanUid,
      kelurahanUid: kelurahanUid ?? this.kelurahanUid,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      tipeLayanan: tipeLayanan ?? this.tipeLayanan,
      selisih: selisih ?? this.selisih,
      namaTipeLayanan: namaTipeLayanan ?? this.namaTipeLayanan,
      namaJenisInstalasi: namaJenisInstalasi ?? this.namaJenisInstalasi,
      uidJenisInstalasi: uidJenisInstalasi ?? this.uidJenisInstalasi,
      typePenugasan: typePenugasan ?? this.typePenugasan,
      statusPenugasan: statusPenugasan ?? this.statusPenugasan,
      besarKapasitas: besarKapasitas ?? this.besarKapasitas,
    );
  }

  @override
  List<Object?> get props => [
        uidPermohonan,
        namaPelanggan,
        namaBadanUsaha,
        tglPengajuan,
        noAgenda,
        namaPemohon,
        noTelp,
        noPonsel,
        besaranKapasitasUid,
        tglPermohonan,
        alamatInstalasi,
        kotaUid,
        kecamatanUid,
        kelurahanUid,
        latitude,
        longitude,
        tipeLayanan,
        selisih,
        namaTipeLayanan,
        namaJenisInstalasi,
        uidJenisInstalasi,
        typePenugasan,
        statusPenugasan,
        besarKapasitas,
      ];

  factory Penugasan.dummy() => Penugasan(
        uidPermohonan: "57858",
        namaPelanggan: "Gema Iriandus Pahalawan",
        namaBadanUsaha: "PT. BADAK NATURAL GAS LIQUEFACTION",
        tglPengajuan: DateTime.parse("2023-11-06 08:45:40.378559"),
        noAgenda: "00LUS.06-11-2023.2",
        namaPemohon: "PEMBANGKIT LISTRIK TENAGA UAP (PLTU), 31-PG-6, PT BADAK NGL",
        noTelp: "62548551300",
        noPonsel: "62548551300",
        besaranKapasitasUid: 4,
        tglPermohonan: DateTime.parse("2023-11-06"),
        alamatInstalasi: "Bontang 75324\r\nKalimantan Timur, Indonesia",
        kotaUid: 6474,
        kecamatanUid: 647402,
        kelurahanUid: 6474021004,
        latitude: 0.1007132458977929,
        longitude: 117.47124262559095,
        tipeLayanan: 2,
        selisih: "200",
        namaTipeLayanan: "Perpanjangan",
        namaJenisInstalasi: "INSTALASI PEMBANGKIT LISTRIK TENAGA UAP (PLTU)",
        uidJenisInstalasi: 321,
        typePenugasan: "SLO NON-TR",
        statusPenugasan: "NEW",
      );
}
