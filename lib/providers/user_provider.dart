import 'package:cart_scan/models/models.dart';
import 'package:cart_scan/services/list_service.dart';
import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  Future<void> getCurrentUserWithLists() async {
    try {
      _currentUser = await getUserData();
      notifyListeners();
    } catch (error) {
      print('Error al obtener el usuario actual con listas: $error');
    }
  }
}
