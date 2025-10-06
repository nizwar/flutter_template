import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class MainScreenProvider extends ChangeNotifier {
  int _index = 0;
  int get index => _index;

  void setIndex(int newIndex) {
    _index = newIndex;
    notifyListeners();
  }

  static MainScreenProvider read(BuildContext context) => context.read();
  static MainScreenProvider watch(BuildContext context) => context.watch();
}
