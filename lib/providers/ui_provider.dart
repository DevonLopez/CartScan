import 'package:flutter/material.dart';

class UIProvider extends ChangeNotifier {
  int _menuOpt = 0;

  int get menuOpt {
    return _menuOpt;
  }

  set menuOpt(int index) {
    _menuOpt = index;
    notifyListeners();
  }
}
