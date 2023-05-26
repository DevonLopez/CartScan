import 'package:cart_scan/models/models.dart';
import 'package:cart_scan/screens/screens.dart';
import 'package:flutter/material.dart';

class ListDetailScreen extends StatelessWidget {
  final ShoppingList shoppingList;

  const ListDetailScreen({required this.shoppingList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(shoppingList.name),
      ),
      body: ListView.builder(
        itemCount: shoppingList.items!.length,
        itemBuilder: (context, index) {
          final item = shoppingList.items![index];

          return ListTile(
            title: Text(item.name),
            subtitle: Text(item.description!),
            trailing: Text('\$${item.price.toStringAsFixed(2)}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ItemDetailScreen(item: item),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
