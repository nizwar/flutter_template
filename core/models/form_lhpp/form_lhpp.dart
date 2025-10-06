import 'package:mojang_nontr/core/models/form_lhpp/mata_uji.dart';
import 'package:mojang_nontr/core/models/model.dart';

class FormLhpp extends Model {
  final int permohonanUid;
  final Header? header;
  final Permohonan? permohonan;
  final Instalasi? instalasi;
  final List<MataUji>? metaUji;

  FormLhpp({this.header, this.permohonan, this.instalasi, this.metaUji, this.permohonanUid = 0});

  FormLhpp copyWith({
    int? permohonanUid,
    Header? header,
    Permohonan? permohonan,
    Instalasi? instalasi,
    List<MataUji>? metaUji,
  }) =>
      FormLhpp(
        permohonanUid: permohonanUid ?? this.permohonanUid,
        header: header ?? this.header,
        permohonan: permohonan ?? this.permohonan,
        instalasi: instalasi ?? this.instalasi,
        metaUji: metaUji ?? this.metaUji,
      );

  factory FormLhpp.fromJson(Map<String, dynamic> json) {
    return FormLhpp(
      permohonanUid: json["permohonan_uid"] ?? 0,
      header: json["header"] == null ? null : Header.fromJson(json["header"]),
      permohonan: json["permohonan"] == null ? null : Permohonan.fromJson(json["permohonan"]),
      instalasi: json["instalasi"] == null ? null : Instalasi.fromJson(json["instalasi"]),
      metaUji: json["mata_uji"] == null ? [] : List<MataUji>.from(json["mata_uji"]!.map((x) => MataUji.fromJson(x))),
    );
  }

  @override
  Map<String, dynamic> toJson() => {"header": header?.toJson(), "permohonan": permohonan?.toJson(), "instalasi": instalasi?.toJson(), "mata_uji": metaUji?.map((e) => e.toJson()).toList()};
}

class Header extends Model {
  final String? noAgenda;
  final String? namaPemilik;
  final dynamic namaInstalasiRev;
  final String? namaInstalasi;
  final String? namaJenisInstalasi;
  final int? besaranKapasitasUid;
  final String? besaranKapasitasLainnya;
  final String? namaBesaranKapasitas;
  final String? besaran;
  final int? peruntukanUid;
  final String? namaPeruntukan;
  final String? peruntukanLainnya;
  final String? nidiBangsang;
  final String? namaTipeLayanan;
  final int? tipeLayanan;
  final String? reffNoRegistrasiSlo;
  final String? badanUsahaPemroses;

  Header({
    this.noAgenda,
    this.namaPemilik,
    this.namaInstalasiRev,
    this.namaInstalasi,
    this.namaJenisInstalasi,
    this.besaranKapasitasUid,
    this.besaranKapasitasLainnya,
    this.namaBesaranKapasitas,
    this.besaran,
    this.peruntukanUid,
    this.namaPeruntukan,
    this.peruntukanLainnya,
    this.nidiBangsang,
    this.namaTipeLayanan,
    this.tipeLayanan,
    this.reffNoRegistrasiSlo,
    this.badanUsahaPemroses,
  });

  Header copyWith({
    String? noAgenda,
    String? namaPemilik,
    dynamic namaInstalasiRev,
    String? namaInstalasi,
    String? namaJenisInstalasi,
    int? besaranKapasitasUid,
    String? besaranKapasitasLainnya,
    String? namaBesaranKapasitas,
    String? besaran,
    int? peruntukanUid,
    String? namaPeruntukan,
    String? peruntukanLainnya,
    String? nidiBangsang,
    String? namaTipeLayanan,
    int? tipeLayanan,
    String? reffNoRegistrasiSlo,
    String? badanUsahaPemroses,
  }) =>
      Header(
        noAgenda: noAgenda ?? this.noAgenda,
        namaPemilik: namaPemilik ?? this.namaPemilik,
        namaInstalasiRev: namaInstalasiRev ?? this.namaInstalasiRev,
        namaInstalasi: namaInstalasi ?? this.namaInstalasi,
        namaJenisInstalasi: namaJenisInstalasi ?? this.namaJenisInstalasi,
        besaranKapasitasUid: besaranKapasitasUid ?? this.besaranKapasitasUid,
        besaranKapasitasLainnya: besaranKapasitasLainnya ?? this.besaranKapasitasLainnya,
        namaBesaranKapasitas: namaBesaranKapasitas ?? this.namaBesaranKapasitas,
        besaran: besaran ?? this.besaran,
        peruntukanUid: peruntukanUid ?? this.peruntukanUid,
        namaPeruntukan: namaPeruntukan ?? this.namaPeruntukan,
        peruntukanLainnya: peruntukanLainnya ?? this.peruntukanLainnya,
        nidiBangsang: nidiBangsang ?? this.nidiBangsang,
        namaTipeLayanan: namaTipeLayanan ?? this.namaTipeLayanan,
        tipeLayanan: tipeLayanan ?? this.tipeLayanan,
        reffNoRegistrasiSlo: reffNoRegistrasiSlo ?? this.reffNoRegistrasiSlo,
        badanUsahaPemroses: badanUsahaPemroses ?? this.badanUsahaPemroses,
      );

  factory Header.fromJson(Map<String, dynamic> json) => Header(
        noAgenda: json["no_agenda"],
        namaPemilik: json["nama_pemilik"],
        namaInstalasiRev: json["nama_instalasi_rev"],
        namaInstalasi: json["nama_instalasi"],
        namaJenisInstalasi: json["nama_jenis_instalasi"],
        besaranKapasitasUid: json["besaran_kapasitas_uid"],
        besaranKapasitasLainnya: json["besaran_kapasitas_lainnya"],
        namaBesaranKapasitas: json["nama_besaran_kapasitas"],
        besaran: json["besaran"],
        peruntukanUid: json["peruntukan_uid"],
        namaPeruntukan: json["nama_peruntukan"],
        peruntukanLainnya: json["peruntukan_lainnya"],
        nidiBangsang: json["nidi_bangsang"],
        namaTipeLayanan: json["nama_tipe_layanan"],
        tipeLayanan: json["tipe_layanan"],
        reffNoRegistrasiSlo: json["reff_no_registrasi_slo"],
        badanUsahaPemroses: json["badan_usaha_pemroses"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "no_agenda": noAgenda,
        "nama_pemilik": namaPemilik,
        "nama_instalasi_rev": namaInstalasiRev,
        "nama_instalasi": namaInstalasi,
        "nama_jenis_instalasi": namaJenisInstalasi,
        "besaran_kapasitas_uid": besaranKapasitasUid,
        "besaran_kapasitas_lainnya": besaranKapasitasLainnya,
        "nama_besaran_kapasitas": namaBesaranKapasitas,
        "besaran": besaran,
        "peruntukan_uid": peruntukanUid,
        "nama_peruntukan": namaPeruntukan,
        "peruntukan_lainnya": peruntukanLainnya,
        "nidi_bangsang": nidiBangsang,
        "nama_tipe_layanan": namaTipeLayanan,
        "tipe_layanan": tipeLayanan,
        "reff_no_registrasi_slo": reffNoRegistrasiSlo,
        "badan_usaha_pemroses": badanUsahaPemroses,
      };
}

class Instalasi extends Model {
  final String? namaInstalasi;
  final dynamic namaInstalasiRev;
  final String? namaProvinsi;
  final String? namaKota;
  final String? namaKecamatan;
  final String? namaKelurahan;
  final String? alamatInstalasi;
  final String? kodePos;
  final String? latitude;
  final String? longitude;

  Instalasi({
    this.namaInstalasi,
    this.namaInstalasiRev,
    this.namaProvinsi,
    this.namaKota,
    this.namaKecamatan,
    this.namaKelurahan,
    this.alamatInstalasi,
    this.kodePos,
    this.latitude,
    this.longitude,
  });

  Instalasi copyWith({
    String? namaInstalasi,
    dynamic namaInstalasiRev,
    String? namaProvinsi,
    String? namaKota,
    String? namaKecamatan,
    String? namaKelurahan,
    String? alamatInstalasi,
    String? kodePos,
    String? latitude,
    String? longitude,
  }) =>
      Instalasi(
        namaInstalasi: namaInstalasi ?? this.namaInstalasi,
        namaInstalasiRev: namaInstalasiRev ?? this.namaInstalasiRev,
        namaProvinsi: namaProvinsi ?? this.namaProvinsi,
        namaKota: namaKota ?? this.namaKota,
        namaKecamatan: namaKecamatan ?? this.namaKecamatan,
        namaKelurahan: namaKelurahan ?? this.namaKelurahan,
        alamatInstalasi: alamatInstalasi ?? this.alamatInstalasi,
        kodePos: kodePos ?? this.kodePos,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
      );

  factory Instalasi.fromJson(Map<String, dynamic> json) => Instalasi(
        namaInstalasi: json["nama_instalasi"],
        namaInstalasiRev: json["nama_instalasi_rev"],
        namaProvinsi: json["nama_provinsi"],
        namaKota: json["nama_kota"],
        namaKecamatan: json["nama_kecamatan"],
        namaKelurahan: json["nama_kelurahan"],
        alamatInstalasi: json["alamat_instalasi"],
        kodePos: json["kode_pos"],
        latitude: json["latitude"],
        longitude: json["longitude"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "nama_instalasi": namaInstalasi,
        "nama_instalasi_rev": namaInstalasiRev,
        "nama_provinsi": namaProvinsi,
        "nama_kota": namaKota,
        "nama_kecamatan": namaKecamatan,
        "nama_kelurahan": namaKelurahan,
        "alamat_instalasi": alamatInstalasi,
        "kode_pos": kodePos,
        "latitude": latitude,
        "longitude": longitude,
      };
}

class Permohonan extends Model {
  final String? tipeIdentitas;
  final String? npwpBadanUsaha;
  final String? namaBadanUsaha;
  final String? namaPerseorangan;
  final String? jenisKewarganegaraan;
  final String? jenisIdentitas;
  final String? nomorIdentitas;

  Permohonan({
    this.tipeIdentitas,
    this.npwpBadanUsaha,
    this.namaBadanUsaha,
    this.namaPerseorangan,
    this.jenisKewarganegaraan,
    this.jenisIdentitas,
    this.nomorIdentitas,
  });

  Permohonan copyWith({
    String? tipeIdentitas,
    String? npwpBadanUsaha,
    String? namaBadanUsaha,
    String? namaPerseorangan,
    String? jenisKewarganegaraan,
    String? jenisIdentitas,
    String? nomorIdentitas,
  }) =>
      Permohonan(
        tipeIdentitas: tipeIdentitas ?? this.tipeIdentitas,
        npwpBadanUsaha: npwpBadanUsaha ?? this.npwpBadanUsaha,
        namaBadanUsaha: namaBadanUsaha ?? this.namaBadanUsaha,
        namaPerseorangan: namaPerseorangan ?? this.namaPerseorangan,
        jenisKewarganegaraan: jenisKewarganegaraan ?? this.jenisKewarganegaraan,
        jenisIdentitas: jenisIdentitas ?? this.jenisIdentitas,
        nomorIdentitas: nomorIdentitas ?? this.nomorIdentitas,
      );

  factory Permohonan.fromJson(Map<String, dynamic> json) => Permohonan(
        tipeIdentitas: json["tipe_identitas"],
        npwpBadanUsaha: json["npwp_badan_usaha"],
        namaBadanUsaha: json["nama_badan_usaha"],
        namaPerseorangan: json["nama_perseorangan"],
        jenisKewarganegaraan: json["jenis_kewarganegaraan"],
        jenisIdentitas: json["jenis_identitas"],
        nomorIdentitas: json["nomor_identitas"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "tipe_identitas": tipeIdentitas,
        "npwp_badan_usaha": npwpBadanUsaha,
        "nama_badan_usaha": namaBadanUsaha,
        "nama_perseorangan": namaPerseorangan,
        "jenis_kewarganegaraan": jenisKewarganegaraan,
        "jenis_identitas": jenisIdentitas,
        "nomor_identitas": nomorIdentitas,
      };
}
