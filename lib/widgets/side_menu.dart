import 'package:cart_scan/models/models.dart';
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
        return CreateListForm(); // Aquí debes crear y retornar tu formulario de creación de lista
      },
    );
  }

  void openItemForm(BuildContext context) {
    Navigator.pushNamed(context, 'itemForm');
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 20,
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Crear Lista'),
            onTap: () {
              openCreateListForm(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Añadir Item'),
            onTap: () {
              final user = Provider.of<UserProvider>(context, listen: false);
              user.fetchUserLists(user.currentUser!.id);
              openItemForm(
                context,
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Cerrar Sesión'),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Cerrar Sesión"),
                    content:
                        Text("¿Estás seguro de que quieres cerrar sesión?"),
                    actions: [
                      TextButton(
                        child: Text("Cancelar"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text("Aceptar"),
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
