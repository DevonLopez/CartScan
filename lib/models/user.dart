import 'package:cart_scan/models/models.dart';

class UserModel {
  late String id;
  late String nombre;
  late List<ShoppingList> lists;

  UserModel({required this.id, required this.nombre, required this.lists});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nombre = json['nombre'];
    if (json['lists'] != null) {
      json['lists'].forEach((v) {
        lists.add(ShoppingList.fromJson(v));
      });
    }
  }

  UserModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    nombre = map['nombre'];
    lists = List<ShoppingList>.from(
        map['lists']?.map((x) => ShoppingList.fromMap(x)) ?? []);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['nombre'] = nombre;
    data['lists'] = lists.map((x) => x.toJson()).toList();
    return data;
  }

  @override
  String toString() {
    return 'UserModel(id: $id, nombre: $nombre, lists: $lists)';
  }
}
