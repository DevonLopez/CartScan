import 'package:cart_scan/models/models.dart';
import 'package:cart_scan/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/item_provider.dart';

class ItemScreenForm extends StatefulWidget {
  final Item? itemBarcode;
  const ItemScreenForm({Key? key, required this.itemBarcode}) : super(key: key);

  @override
  State<ItemScreenForm> createState() => _ItemScreenFormState();
}

class _ItemScreenFormState extends State<ItemScreenForm> {
  late Item? itemBarcode = widget.itemBarcode;
  late List<String> userLists;
  String? selectedListName;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<UserProvider>(context, listen: false);
    provider.getCurrentUserWithLists();
    userLists = provider.nameList;
    if (userLists.isNotEmpty) {
      selectedListName = userLists.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    String id = '';
    String name = '';
    String? description = '';
    double price = 0.0;
    double discount = 0.0;
    int? quality = 5;
    bool offer = false;
    final itemFormProvider =
        Provider.of<ItemFormProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (widget.itemBarcode != null) {
      // Si itemBarcode está definido y no es nulo, muestra el formulario con el DropdownButton
      return Scaffold(
        appBar: AppBar(
          title: const Text('Añadir Producto'),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  initialValue: widget.itemBarcode!.name ?? '',
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
                  decoration: const InputDecoration(labelText: 'Descripción'),
                  onChanged: (value) {
                    description = value;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Precio'),
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
                  decoration: const InputDecoration(labelText: 'Descuento'),
                  keyboardType: TextInputType.number,
                  enabled: itemFormProvider.offer,
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
                  decoration: const InputDecoration(labelText: 'Valoración'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    quality = int.parse(value);
                  },
                ),
                SwitchListTile(
                  title: const Text('Oferta?'),
                  value: itemFormProvider.offer,
                  onChanged: (value) {
                    setState(() {
                      itemFormProvider.offer = value;
                    });
                  },
                ),
                DropdownButton<String>(
                  value: selectedListName,
                  onChanged: (value) {
                    setState(() {
                      selectedListName = value!;
                    });
                  },
                  items: userLists.map((list) {
                    return DropdownMenuItem<String>(
                      value: list,
                      child: Text(list),
                    );
                  }).toList(),
                  hint: const Text('Selecciona una opción'),
                  isExpanded: true,
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                child: const Text('Guardar'),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    Item item = Item(
                      id: null,
                      listId: userProvider
                              .getListId(selectedListName!)
                              .toString() ??
                          '',
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
          ),
        ),
      );
    } else {
      // Si itemBarcode no está definido o es nulo, muestra una alerta y navega a la pantalla de detalles
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('No se encontraron listas disponibles.'),
              actions: [
                ElevatedButton(
                  child: const Text('Aceptar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      });

      return Scaffold(
        appBar: AppBar(
          title: const Text('Añadir Producto'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
