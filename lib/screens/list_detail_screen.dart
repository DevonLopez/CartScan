import 'package:cart_scan/models/models.dart';
import 'package:cart_scan/screens/screens.dart';
import 'package:cart_scan/services/list_service.dart';
import 'package:flutter/material.dart';

class ListDetailScreen extends StatefulWidget {
  final ShoppingList shoppingList;

  const ListDetailScreen({Key? key, required this.shoppingList})
      : super(key: key);

  @override
  State<ListDetailScreen> createState() => _ListDetailScreenState();
}

class _ListDetailScreenState extends State<ListDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(248, 229, 165, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 150, 226, 88),
        title: Text(widget.shoppingList.name),
      ),
      body: ListView.builder(
        itemCount: widget.shoppingList.items!.length,
        itemBuilder: (context, index) {
          final item = widget.shoppingList.items![index];

          return Dismissible(
            key: Key(widget.shoppingList.items![index].id!),
            direction: DismissDirection.startToEnd,
            background: Container(
              color: Colors.red,
              padding: EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerLeft,
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            confirmDismiss: (direction) async {
              return await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Borrar Ítem"),
                    content: const Text("¿Estás seguro de borrar este ítem?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: const Text("No"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: const Text("Sí"),
                      ),
                    ],
                  );
                },
              );
            },
            onDismissed: (direction) {
              removeItem(widget.shoppingList.items![index].id!);
              setState(() {
                widget.shoppingList.items!.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Ítem eliminado'),
                ),
              );
            },
            child: ListTile(
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
            ),
          );
        },
      ),
    );
  }
}
