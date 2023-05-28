import 'package:cart_scan/models/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/item_provider.dart';

class ItemScreenForm extends StatefulWidget {
  final Item? itemBarcode;
  const ItemScreenForm({super.key, required this.itemBarcode});

  @override
  State<ItemScreenForm> createState() => _ItemScreenFormState();
}

class _ItemScreenFormState extends State<ItemScreenForm> {
  late final Item? itemBarcode;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    String id = '';
    String listId = '';
    String name = '';
    String? description;
    double price = 0.0;
    double discount = 0.0;
    int? quality;
    bool offer = false;
    final itemFormProvider =
        Provider.of<ItemFormProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Añadir Producto'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre'),
                initialValue: widget.itemBarcode?.name ?? '',
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
                enabled: offer,
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
                value: itemFormProvider.offer,
                onChanged: (value) {
                  setState(() {
                    itemFormProvider.offer = value;
                  });
                },
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
        ),
      ),
    );
  }
}
