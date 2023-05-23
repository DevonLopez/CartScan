import 'package:cart_scan/models/models.dart';

class UserModel {
  final String id;
  final String name;
  List<ShoppingList>? lists;

  UserModel({
    required this.id,
    required this.name,
    this.lists,
  });

  factory UserModel.fromMap(Map<String, dynamic> json) {
    final String id =
        json.keys.first; // Obtener el ID del documento como el ID del usuario
    final String? name = json["name"];

    if (name == null) {
      throw Exception("Name field is missing or null");
    }

    final List<dynamic>? listData = json["lists"];
    List<ShoppingList>? lists;

    if (listData != null) {
      lists = List<ShoppingList>.from(
        listData.map((x) => ShoppingList.fromMap(x)),
      );
    }

    return UserModel(
      id: id,
      name: name,
      lists: lists,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "lists": lists != null
          ? List<dynamic>.from(lists!.map((x) => x.toMap()))
          : null,
    };
  }
}
