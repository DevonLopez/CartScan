import 'package:cart_scan/models/models.dart';
import 'package:cart_scan/providers/user_provider.dart';
import 'package:cart_scan/screens/screens.dart';
import 'package:cart_scan/services/list_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

Future refresh(BuildContext context) async {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  userProvider.getCurrentUserWithLists();
}

class _ListScreenState extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Center(
      child: userProvider.currentUser != null
          ? RefreshIndicator(
              onRefresh: () => refresh(context),
              child: ListView.builder(
                itemCount: userProvider.currentUser!.lists!.length,
                itemBuilder: (context, index) {
                  ShoppingList shoppingList =
                      userProvider.currentUser!.lists![index];

                  return Dismissible(
                    key: Key(shoppingList.name),
                    direction: DismissDirection.horizontal,
                    background: Container(
                      color: Color.fromARGB(255, 248, 173, 74),
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    secondaryBackground: Container(
                      color: Color.fromARGB(255, 248, 173, 74),
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    confirmDismiss: (DismissDirection direction) async {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Borrar Lista"),
                            content: const Text(
                                "¿Estás seguro de borrar esta lista y todo su contenido?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                  setState(() {});
                                },
                                child: const Text("No"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                  setState(() {});
                                },
                                child: const Text("Sí"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    onDismissed: (DismissDirection direction) async {
                      bool shouldDelete = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Borrar Lista"),
                            content: const Text(
                                "¿Estás seguro de borrar esta lista y todo su contenido?"),
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

                      if (shouldDelete) {
                        removeListWithItems(
                            userProvider.currentUser!.lists![index].id!);
                        setState(() {
                          userProvider.currentUser!.lists!.removeAt(index);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Lista eliminada'),
                          ),
                        );
                      }
                    },
                    child: Container(
                      width: double.infinity, // Ocupa todo el ancho disponible
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(
                              shoppingList.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: AutofillHints.birthday,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.black, width: 1),
                            ),
                            minVerticalPadding: 20,
                            splashColor: Color.fromARGB(255, 125, 248, 166),
                            trailing: Icon(Icons.arrow_forward_ios),
                            tileColor: Color.fromARGB(255, 231, 252, 176),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ListDetailScreen(
                                    shoppingList: shoppingList,
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          : const CircularProgressIndicator(),
    );
  }
}
