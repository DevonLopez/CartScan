import 'package:cart_scan/models/models.dart';
import 'package:cart_scan/screens/screens.dart';
import 'package:flutter/material.dart';

class ListDetailScreen extends StatefulWidget {
  final ShoppingList shoppingList;

  const ListDetailScreen({super.key, required this.shoppingList});

  @override
  State<ListDetailScreen> createState() => _ListDetailScreenState();
}

class _ListDetailScreenState extends State<ListDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.shoppingList.name),
      ),
      body: ListView.builder(
        itemCount: widget.shoppingList.items!.length,
        itemBuilder: (context, index) {
          final item = widget.shoppingList.items![index];

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
