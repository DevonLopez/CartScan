import 'package:cart_scan/models/models.dart';
import 'package:flutter/material.dart';

class ItemFormProvider extends ChangeNotifier {
  bool _offer = false;
  String _barcode = '';
  Item _scanned = Item(
      id: null,
      listId: null,
      name: '',
      price: 0.00,
      discount: 0,
      offer: false,
      description: '',
      quality: 5);

  bool get offer => _offer;
  String get barcode => _barcode;
  Item get scanned => _scanned;

  set offer(bool value) {
    _offer = value;
    notifyListeners();
  }

  set barcode(String value) {
    _barcode = value;
    notifyListeners();
  }

  set scanned(Item value) {
    _scanned = value;
    notifyListeners();
  }
}
