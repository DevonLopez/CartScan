import 'package:cart_scan/models/models.dart';
import 'package:cart_scan/providers/user_provider.dart';
import 'package:cart_scan/services/list_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                    itemFormProvider.scanned.name = value;
                    name = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Añade un nombre de producto';
                    }
                    if (value.length < 4) {
                      return 'El nombre debe tener al menos 4 caracteres';
                    }
                    if (value.length > 30) {
                      return 'El nombre no puede tener más de 30 caracteres';
                    }

                    return null;
                  },
                  maxLength: 30,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Descripción'),
                  initialValue: widget.itemBarcode!.description ?? '',
                  onChanged: (value) {
                    description = value;
                    itemFormProvider.scanned.description = description!;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Añade una descripción breve de producto';
                    }
                    if (value.length < 4) {
                      return 'La descripción requiere un mínimo de 4 caracteres';
                    }
                    if (value.length > 200) {
                      return 'La descripción no puede tener más de 200 caracteres';
                    }
                    return null;
                  },
                  maxLength: 200,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Precio'),
                  initialValue: widget.itemBarcode!.price.toString() ?? '0.00',
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    try {
                      price = double.parse(value);
                      itemFormProvider.scanned.price = price;
                    } catch (e) {
                      print('Error $e');
                    }
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
                  initialValue: widget.itemBarcode!.discount.toString() ?? '0',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  enabled: itemFormProvider.offer,
                  onChanged: (value) {
                    try {
                      double parsedValue = double.parse(value);
                      if (parsedValue > 100) {
                        setState(() {
                          discount = 100;
                          itemFormProvider.scanned.discount = discount;
                        });
                      } else {
                        discount = parsedValue;
                        itemFormProvider.scanned.discount = parsedValue;
                      }
                    } catch (e) {
                      print('Error: $e');
                    }
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
                  initialValue: widget.itemBarcode!.quality.toString() ?? '5',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) {
                    try {
                      int parsedValue = int.parse(value);
                      if (parsedValue > 10) {
                        setState(() {
                          quality = 10;
                          itemFormProvider.scanned.quality = quality;
                        });
                      } else {
                        quality = parsedValue;
                        itemFormProvider.scanned.quality = parsedValue;
                      }
                    } catch (e) {
                      print('Error $e');
                    }
                  },
                ),
                SwitchListTile(
                  title: const Text('Oferta?'),
                  value: itemFormProvider.offer,
                  onChanged: (value) {
                    setState(() {
                      itemFormProvider.offer = value;
                      itemFormProvider.scanned.offer = itemFormProvider.offer;
                    });
                  },
                ),
                DropdownButton<String>(
                  value: selectedListName,
                  onChanged: (value) async {
                    setState(() {
                      selectedListName = value!;
                    });
                    await userProvider.getListId(value!);
                    itemFormProvider.scanned.listId = userProvider.listId;
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
                      listId: itemFormProvider.scanned.listId,
                      description: itemFormProvider.scanned.description,
                      name: itemFormProvider.scanned.name,
                      price: itemFormProvider.scanned.price,
                      discount: itemFormProvider.scanned.discount,
                      quality: itemFormProvider.scanned.quality,
                      offer: itemFormProvider.scanned.offer,
                    );
                    print(item.toString());
                    addItemToSelectedList(item);
                    userProvider.getCurrentUserWithLists();
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
                    Navigator.pushNamed(context, 'details');
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
