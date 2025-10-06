import 'package:mojang_nontr/core/models/model.dart';

class Auth extends Model {
  final List<dynamic> faceRecog;
  final String service;
  final String token;
  final DateTime? expired;
  final String role;
  final String nama;
  final String nik;

  Auth({
    required this.faceRecog,
    required this.service,
    required this.token,
    required this.expired,
    required this.role,
    required this.nama,
    required this.nik,
  });

  factory Auth.fromJson(Map<String, dynamic> json) {
    return Auth(
      faceRecog: json['face_recog'] ?? [],
      service: json['service'] ?? '',
      token: json['token'] ?? '',
      expired: json['expired'] != null ? DateTime.parse(json['expired']) : null,
      role: json['role'] ?? '',
      nama: json['nama'] ?? '',
      nik: json['nik'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        "face_recog": faceRecog,
        "service": service,
        "token": token,
        "expired": expired?.toIso8601String(),
        "role": role,
        "nama": nama,
        "nik": nik,
      };
}
