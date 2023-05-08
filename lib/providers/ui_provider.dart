import 'package:flutter/material.dart';

class UIProvider extends ChangeNotifier {
  int _menuOpt = 0;

  int get menuOpt {
    return this._menuOpt;
  }

  set menuOpt(int index) {
    this._menuOpt = index;
    notifyListeners();
  }
}
