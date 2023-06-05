import 'package:cart_scan/models/models.dart';
import 'package:cart_scan/services/list_service.dart';
import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  UserModel? _currentUser;
  String? _listId = '';
  List<ShoppingList> _userLists = [];
  List<String> _nameList = [];
  List<Item> _itemList = [];
  ShoppingList? _currentList;
  bool _isDataFetch = false;

  UserModel? get currentUser => _currentUser;
  List<ShoppingList> get userLists => _userLists;
  List<String> get nameList => _nameList;
  List<Item> get itemList => _itemList;
  String? get listId => _listId;
  ShoppingList? get currentList => _currentList;
  bool get isDataFetch => _isDataFetch;

  set isDataFetch(bool valor) {
    _isDataFetch = valor;
  }

  set itemList(List<Item> items) {
    _itemList = items;
  }

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
    _userLists.forEach((element) {
      element.items!.forEach((item) {
        if (!_itemList.contains(item)) {
          _itemList.add(item);
        }
      });
    });
    notifyListeners();
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

  Future<void> getListId(String name) async {
    try {
      _userLists!.forEach((element) {
        if (element.name == name) {
          _listId = element.id;
        }
      });
      notifyListeners();
    } catch (error) {
      print('No encontrada la lista: $error');
    }
  }
}
