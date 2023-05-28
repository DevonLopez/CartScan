import 'package:flutter/material.dart';

class ItemFormProvider extends ChangeNotifier {
  bool _offer = false;

  bool get offer => _offer;

  set offer(bool value) {
    _offer = value;
    notifyListeners();
  }
}
