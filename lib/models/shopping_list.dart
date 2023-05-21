import 'package:cart_scan/models/models.dart';

class ShoppingList {
  late String id;
  late String name;
  late List<Item> items;

  ShoppingList({required this.id, required this.name, required this.items});

  ShoppingList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['items'] != null) {
      json['items'].forEach((v) {
        items.add(Item.fromJson(v));
      });
    }
  }

  ShoppingList.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    items = List<Item>.from(map['items']?.map((x) => Item.fromMap(x)) ?? []);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['items'] = this.items.map((v) => v.toJson()).toList();
    return data;
  }
}
