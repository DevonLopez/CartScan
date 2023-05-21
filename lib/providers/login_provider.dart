import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  bool _showpassw = true;

  bool get password {
    return _showpassw;
  }

  actualizarContra() {
    _showpassw = !_showpassw;
    notifyListeners();
  }
}
