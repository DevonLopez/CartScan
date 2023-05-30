import 'package:cart_scan/providers/item_provider.dart';
import 'package:cart_scan/providers/providers.dart';
import 'package:cart_scan/screens/screens.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);

  void openCreateListForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const CreateListForm();
      },
    );
  }

  void openItemForm(BuildContext context) {
    final provider = Provider.of<ItemFormProvider>(context, listen: false);
    Navigator.pushNamed(context, 'itemForm', arguments: provider.scanned);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(
            height: 20,
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Crear Lista'),
            onTap: () {
              openCreateListForm(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('Añadir Item'),
            onTap: () {
              final user = Provider.of<UserProvider>(context, listen: false);
              user.fetchUserLists(user.currentUser!.id);
              openItemForm(
                context,
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar Sesión'),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Cerrar Sesión"),
                    content: const Text(
                        "¿Estás seguro de que quieres cerrar sesión?"),
                    actions: [
                      TextButton(
                        child: const Text("Cancelar"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text("Aceptar"),
                        onPressed: () async {
                          await GoogleSignIn().signOut();
                          FirebaseAuth.instance.signOut();
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
