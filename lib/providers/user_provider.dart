import 'dart:js_interop';

import 'package:cart_scan/models/models.dart';
import 'package:cart_scan/services/list_service.dart';
import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  UserModel? _currentUser;
  List<ShoppingList> _userLists = [];
  List<String> _nameList = [];
  List<Item> _itemList = [];

  UserModel? get currentUser => _currentUser;
  List<ShoppingList> get userLists => _userLists;
  List<String> get nameList => _nameList;
  List<Item> get itemList => _itemList;

  Future<void> getCurrentUserWithLists() async {
    try {
      _currentUser = await getUserData();
      fetchUserLists(_currentUser!.id);
      notifyListeners();
    } catch (error) {
      print('Error al obtener el usuario actual con listas: $error');
    }
  }

  Future<void> getItems() async {
    _itemList = [];
    _currentUser!.lists!.forEach((element) {
      element.items!.forEach((item) {
        if (item.isDefinedAndNotNull) {
          _itemList.add(item);
        }
      });
    });
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

      _userLists.forEach((element) {
        if (!_nameList.contains(element.name)) {
          _nameList.add(element.name);
        }
      });
      notifyListeners();
    } catch (error) {
      print('Error al obtener las listas del usuario: $error');
    }
  }

  Future<String?> getListId(String name) async {
    String? idLista = null;
    try {
      _userLists.forEach((element) {
        if (element.name == name) {
          idLista = element.id!;
        }
      });
      notifyListeners();
      return idLista;
    } catch (error) {
      print('No encontrada la lista: $error');
    }
    notifyListeners();
    return null;
  }
}
