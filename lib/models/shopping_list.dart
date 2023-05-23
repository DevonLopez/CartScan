import 'package:cart_scan/models/models.dart';

class ShoppingList {
  final String id;
  final String name;
  final String userId;
  List<Item>? items;

  ShoppingList({
    required this.id,
    required this.name,
    required this.userId,
    this.items,
  });

  factory ShoppingList.fromMap(Map<String, dynamic> json) => ShoppingList(
        id: json["id"],
        name: json["name"],
        userId: json["userId"],
        items: List<Item>.from(json["items"].map((x) => Item.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "userId": userId,
        "items": List<dynamic>.from(items!.map((x) => x.toMap())),
      };
}
