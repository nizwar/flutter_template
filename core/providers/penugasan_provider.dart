import 'package:flutter/material.dart';
import 'package:mojang_nontr/core/models/penugasan.dart';
import 'package:provider/provider.dart';

import '../https/penugasan_http.dart';

///Since penugasan is big data and we don't want to fetch it multiple times, we will use provider to store the data
class PenugasanProvider extends ChangeNotifier {
  bool _loading = false;
  List<Penugasan> _penugasanBaru = [];
  List<Penugasan> _penugasanSelesai = [];

  List<Penugasan> get penugasanBaru => _penugasanBaru;
  List<Penugasan> get penugasanSelesai => _penugasanSelesai;
  bool get isLoading => _loading;

  static void refresh(BuildContext context) {
    final provider = context.read<PenugasanProvider>();
    provider._loading = true;
    provider.notifyListeners();
    PenugasanHttp(context).getHomePenugasan().then((value) {
      provider._penugasanBaru = value.$1;
      provider._penugasanSelesai = value.$2;
      provider._loading = false;
      provider.notifyListeners();
    }).catchError((error) {
      provider._loading = false;
      provider.notifyListeners();
    });
  }
}
