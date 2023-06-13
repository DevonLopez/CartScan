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
  late Item? copy = itemBarcode;

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
    double discount;
    int quality = 0;
    final size = MediaQuery.of(context).size;
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final itemFormProvider =
        Provider.of<ItemFormProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (widget.itemBarcode != null) {
      // Si itemBarcode está definido y no es nulo, muestra el formulario con el DropdownButton
      return Scaffold(
        backgroundColor: Color.fromRGBO(248, 229, 165, 1),
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color.fromARGB(255, 150, 226, 88),
          title: const Text('Añadir Producto'),
        ),
        body: SingleChildScrollView(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(size.width * 0.08),
            children: [
              Form(
                //key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Nombre'),
                      initialValue: itemBarcode!.name ?? '',
                      onChanged: (value) {
                        itemFormProvider.scanned.name = value;
                        itemBarcode!.name = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Añade un nombre de producto';
                        }
                        if (value.length < 4) {
                          return 'El nombre debe tener al menos 4 caracteres';
                        }
                        if (value.length > 80) {
                          return 'El nombre no puede tener más de 80 caracteres';
                        }

                        return null;
                      },
                      maxLength: 80,
                    ),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Descripción'),
                      initialValue: itemBarcode!.description ?? '',
                      onChanged: (value) {
                        itemFormProvider.scanned.description = value;
                        itemBarcode!.description = value;
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
                      maxLength: 1000,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Precio'),
                      initialValue:
                          widget.itemBarcode!.price.toString() ?? '0.00',
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      onChanged: (value) {
                        try {
                          double price = double.parse(value);
                          itemFormProvider.scanned.price = price;
                          itemBarcode!.price = price;
                        } catch (e) {
                          print('Error $e');
                        }
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Añade un precio';
                        }
                        if (value.endsWith('.')) {
                          return 'Completa el precio';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Descuento'),
                      initialValue:
                          widget.itemBarcode!.discount.toString() ?? '0',
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      enabled:
                          itemBarcode!.offer == true || itemFormProvider.offer
                              ? true
                              : false,
                      onChanged: (value) {
                        try {
                          double parsedValue = double.parse(value);
                          if (parsedValue > 100) {
                            discount = 100;
                            itemFormProvider.scanned.discount = discount;
                            itemBarcode!.discount = parsedValue;
                            setState(() {});
                          } else {
                            discount = parsedValue;
                            itemFormProvider.scanned.discount = parsedValue;
                            itemBarcode!.discount = parsedValue;
                          }
                        } catch (e) {
                          print('Error: $e');
                        }
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Añade un descuento';
                        }
                        if (value.endsWith('.')) {
                          return 'Completa el descuento';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Valoración'),
                      initialValue:
                          widget.itemBarcode!.quality.toString() ?? '0',
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) {
                        try {
                          int parsedValue = int.parse(value);
                          if (parsedValue > 10) {
                            quality = 10;
                            itemFormProvider.scanned.quality = quality;
                            itemBarcode!.quality = parsedValue;
                            setState(() {});
                          } else {
                            quality = parsedValue;
                            itemFormProvider.scanned.quality = parsedValue;
                            itemBarcode!.quality = parsedValue;
                          }
                        } catch (e) {
                          print('Error $e');
                        }
                      },
                    ),
                    SwitchListTile(
                      title: const Text('Oferta?'),
                      value: itemBarcode!.offer
                          ? itemBarcode!.offer
                          : itemFormProvider.offer,
                      onChanged: (value) {
                        itemFormProvider.offer = value;
                        itemFormProvider.scanned.offer = itemFormProvider.offer;
                        itemBarcode!.offer = value;
                        setState(() {});
                      },
                    ),
                    DropdownButton<String>(
                      value: selectedListName,
                      onChanged: (value) async {
                        selectedListName = value!;
                        setState(() {});
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
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: const Color.fromARGB(255, 150, 226, 88),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                child: const Text('Cancelar'),
                onPressed: () {
                  itemBarcode = copy;
                  Navigator.pushNamed(context, 'details');
                },
              ),
              ElevatedButton(
                child: const Text('Guardar'),
                onPressed: () {
                  // if (formKey.currentState!.validate()) {
                  if (true) {
                    if (itemBarcode!.id != null) {
                      updateItem(
                        Item(
                          id: itemBarcode!.id,
                          listId: itemFormProvider.scanned.listId ??
                              itemBarcode!.listId,
                          description: (itemBarcode!.description == '' ||
                                  itemBarcode!.description == null)
                              ? itemFormProvider.scanned.description
                              : itemBarcode!.description,
                          name: itemBarcode!.name == '' ||
                                  itemBarcode!.name == null
                              ? itemFormProvider.scanned.name
                              : itemBarcode!.name,
                          price: itemBarcode!.price == 0.0 ||
                                  itemBarcode!.price == null
                              ? itemFormProvider.scanned.price
                              : itemBarcode!.price,
                          discount: itemBarcode!.discount == 0.0 ||
                                  itemBarcode!.discount == null
                              ? itemFormProvider.scanned.discount
                              : itemBarcode!.discount,
                          quality: itemBarcode!.quality == 0 ||
                                  itemBarcode!.quality == null
                              ? itemFormProvider.scanned.quality
                              : itemBarcode!.quality,
                          offer: itemBarcode!.offer == false
                              ? itemFormProvider.scanned.offer
                              : itemBarcode!.offer,
                        ),
                      );
                      Navigator.pushNamed(context, 'details');
                    } else {
                      Item item = Item(
                        id: null,
                        listId: itemFormProvider.scanned.listId ??
                            userProvider.userLists.first.id,
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
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Campos sin completar"),
                          content: const Text("Completa los campos necesarios"),
                          actions: [
                            TextButton(
                              child: const Text("Aceptar"),
                              onPressed: () async {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      );
    } else {
      // Si itemBarcode no está definido o es nulo, muestra una alerta y navega a la pantalla de detalles

      Navigator.pushNamed(context, 'details');

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
