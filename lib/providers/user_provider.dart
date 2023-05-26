import 'package:cart_scan/models/models.dart';
import 'package:cart_scan/services/list_service.dart';
import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  UserModel? _currentUser;
  List<ShoppingList> _userLists = [];

  UserModel? get currentUser => _currentUser;
  List<ShoppingList> get userLists => _userLists;

  Future<void> getCurrentUserWithLists() async {
    try {
      _currentUser = await getUserData();
      notifyListeners();
    } catch (error) {
      print('Error al obtener el usuario actual con listas: $error');
    }
  }

  Future<void> fetchUserLists(String userId) async {
    try {
      if (_currentUser != null) {
        // Si el usuario actual ya se ha obtenido previamente, simplemente asigna las listas almacenadas en _currentUser
        _userLists = _currentUser!.lists!;
        notifyListeners();
      } else {
        // Si el usuario actual no se ha obtenido previamente, realiza la llamada a getUserData para obtenerlo y asignar las listas
        _currentUser = await getUserData();
        _userLists = _currentUser!.lists!;
        notifyListeners();
      }
    } catch (error) {
      print('Error al obtener las listas del usuario: $error');
    }
  }
}
