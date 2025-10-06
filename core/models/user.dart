import 'package:mojang_nontr/core/models/model.dart';

class User extends Model {
  final String? nama;
  final String? nik;
  final String? namaBadanUsaha;
  final String? jabatan;
  final String? jenisUsaha;
  final String? bidang;
  final String? subBidang;
  final String? noRegSkttk;
  final String? masaBerlaku;
  final String? status;
  final List<Profile> profiles;
  final String? foto;

  User({
    required this.nama,
    required this.nik,
    required this.namaBadanUsaha,
    required this.jabatan,
    required this.jenisUsaha,
    required this.bidang,
    required this.subBidang,
    required this.noRegSkttk,
    required this.masaBerlaku,
    required this.status,
    required this.profiles,
    this.foto,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      nama: json['nama'] ?? '',
      nik: json['nik'] ?? '',
      namaBadanUsaha: json['nama_badan_usaha'] ?? '',
      jabatan: json['jabatan'] ?? '',
      jenisUsaha: json['jenis_usaha'] ?? '',
      bidang: json['bidang'] ?? '',
      subBidang: json['sub_bidang'] ?? '',
      noRegSkttk: json['no_reg_skttk'] ?? '',
      masaBerlaku: json['masa_berlaku'] ?? '',
      status: json['status'] ?? '',
      profiles: (json['profiles'] as List<dynamic>?)?.map((e) => Profile.fromJson(e as Map<String, dynamic>)).toList() ?? [],
      foto: json['foto'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'nik': nik,
      'nama_badan_usaha': namaBadanUsaha,
      'jabatan': jabatan,
      'jenis_usaha': jenisUsaha,
      'bidang': bidang,
      'sub_bidang': subBidang,
      'no_reg_skttk': noRegSkttk,
      'masa_berlaku': masaBerlaku,
      'status': status,
      'profiles': profiles.map((e) => e.toJson()).toList(),
      'foto': foto,
    };
  }

  User copyWith({
    String? nama,
    String? nik,
    String? namaBadanUsaha,
    String? jabatan,
    String? jenisUsaha,
    String? bidang,
    String? subBidang,
    String? noRegSkttk,
    String? masaBerlaku,
    String? status,
    List<Profile>? profiles,
    String? foto,
  }) {
    return User(
      nama: nama ?? this.nama,
      nik: nik ?? this.nik,
      namaBadanUsaha: namaBadanUsaha ?? this.namaBadanUsaha,
      jabatan: jabatan ?? this.jabatan,
      jenisUsaha: jenisUsaha ?? this.jenisUsaha,
      bidang: bidang ?? this.bidang,
      subBidang: subBidang ?? this.subBidang,
      noRegSkttk: noRegSkttk ?? this.noRegSkttk,
      masaBerlaku: masaBerlaku ?? this.masaBerlaku,
      status: status ?? this.status,
      profiles: profiles ?? this.profiles,
      foto: foto ?? this.foto,
    );
  }
}

class Profile extends Model {
  final String namaBadanUsaha;
  final String jabatan;
  final String jenisUsaha;
  final String bidang;
  final String subBidang;
  final String noRegSkttk;
  final String masaBerlaku;
  final String status;

  Profile({
    required this.namaBadanUsaha,
    required this.jabatan,
    required this.jenisUsaha,
    required this.bidang,
    required this.subBidang,
    required this.noRegSkttk,
    required this.masaBerlaku,
    required this.status,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      namaBadanUsaha: json['nama_badan_usaha'] ?? '',
      jabatan: json['jabatan'] ?? '',
      jenisUsaha: json['jenis_usaha'] ?? '',
      bidang: json['bidang'] ?? '',
      subBidang: json['sub_bidang'] ?? '',
      noRegSkttk: json['no_reg_skttk'] ?? '',
      masaBerlaku: json['masa_berlaku'] ?? '',
      status: json['status'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'nama_badan_usaha': namaBadanUsaha,
      'jabatan': jabatan,
      'jenis_usaha': jenisUsaha,
      'bidang': bidang,
      'sub_bidang': subBidang,
      'no_reg_skttk': noRegSkttk,
      'masa_berlaku': masaBerlaku,
      'status': status,
    };
  }

  Profile copyWith({
    String? namaBadanUsaha,
    String? jabatan,
    String? jenisUsaha,
    String? bidang,
    String? subBidang,
    String? noRegSkttk,
    String? masaBerlaku,
    String? status,
  }) {
    return Profile(
      namaBadanUsaha: namaBadanUsaha ?? this.namaBadanUsaha,
      jabatan: jabatan ?? this.jabatan,
      jenisUsaha: jenisUsaha ?? this.jenisUsaha,
      bidang: bidang ?? this.bidang,
      subBidang: subBidang ?? this.subBidang,
      noRegSkttk: noRegSkttk ?? this.noRegSkttk,
      masaBerlaku: masaBerlaku ?? this.masaBerlaku,
      status: status ?? this.status,
    );
  }
}
