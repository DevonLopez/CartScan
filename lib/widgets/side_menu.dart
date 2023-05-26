import 'package:cart_scan/models/models.dart';
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

/*
  void openItemForm(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    String id = '';
    String listId = '';
    String name = '';
    String? description;
    double price = 0.0;
    double discount = 0.0;
    int? quality;
    bool offer = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Añadir Producto"),
          content: Container(
            width: MediaQuery.of(context).size.width *
                0.8, // Tamaño del 80% de la pantalla
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Nombre'),
                    onChanged: (value) {
                      name = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Añade un nombre de producto';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Descripción'),
                    onChanged: (value) {
                      description = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Precio'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      price = double.parse(value);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Añade un precio';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Descuento'),
                    keyboardType: TextInputType.number,
                    enabled:
                        offer, // Habilitar o deshabilitar la edición del campo según el valor de offer
                    onChanged: (value) {
                      discount = double.parse(value);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Añade un descuento';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Valoración'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      quality = int.parse(value);
                    },
                  ),
                  SwitchListTile(
                    title: Text('Oferta?'),
                    value: offer,
                    onChanged: (value) {
                      offer = value;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Guardar'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Item item = Item(
                    id: null,
                    listId: listId,
                    name: name,
                    price: price,
                    discount: discount,
                    quality: quality,
                    offer: offer,
                  );

                  print(item.toString());
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
*/
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Crear Lista'),
            onTap: () {
              openCreateListForm(context);
            },
          ),
          /*
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Añadir Item'),
            onTap: () {
              final user = Provider.of<UserProvider>(context);
              print(user.currentUser!.lists);
              openItemForm(context);
            },
          ),*/
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
