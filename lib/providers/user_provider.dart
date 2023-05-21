import 'package:cart_scan/models/models.dart';
import 'package:cart_scan/services/list_service.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  List<UserModel> users = [];

  UserProvider() {
    getUsers();
  }

  getApiUsers() async {
    users = await getUsers();
    notifyListeners();
  }
}
