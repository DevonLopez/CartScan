import 'package:cart_scan/models/models.dart';

class ShoppingList {
  late String? id;
  final String name;
  late String userId;
  List<Item>? items;

  ShoppingList({
    this.id,
    required this.name,
    required this.userId,
    this.items,
  }) {
    id = ''; // Valor predeterminado en caso de que el valor de `id` sea nulo
  }

  factory ShoppingList.fromMap(Map<String, dynamic> json) => ShoppingList(
        id: json["id"] ?? '',
        name: json["name"],
        userId: json["userId"],
        items: List<Item>.from(json["items"].map((x) => Item.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "userId": userId,
      };

  @override
  String toString() {
    return 'ShoppingList(id: $id, name: $name, userId: $userId, items: $items)';
  }
}
