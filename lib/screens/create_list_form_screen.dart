import 'package:flutter/material.dart';
import 'package:cart_scan/models/models.dart';
import 'package:provider/provider.dart';
import 'package:cart_scan/providers/user_provider.dart';
import 'package:cart_scan/services/list_service.dart';

class CreateListForm extends StatefulWidget {
  const CreateListForm({Key? key}) : super(key: key);

  @override
  _CreateListFormState createState() => _CreateListFormState();
}

class _CreateListFormState extends State<CreateListForm> {
  final _formKey = GlobalKey<FormState>();
  late String listName;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userId = userProvider.currentUser?.id ?? '';

    return AlertDialog(
      title: const Text('Crear lista'),
      content: SizedBox(
        width: 200,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nombre de la lista'),
                maxLength: 30,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, introduce un nombre';
                  }
                  return null;
                },
                onSaved: (value) {
                  listName = value!;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Guardar'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              final newList = ShoppingList(
                id: '', // El ID será autogenerado por Firebase
                name: listName,
                userId: userId,
              );
              ListService.createList(
                  newList); // Guardar la nueva lista en Firebase
              print('peticion de guardado de lista y busqueda');
              userProvider.getCurrentUserWithLists();

              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
