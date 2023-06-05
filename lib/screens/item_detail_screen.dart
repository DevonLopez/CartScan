import 'package:cart_scan/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ItemDetailScreen extends StatelessWidget {
  final Item item;

  const ItemDetailScreen({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Color actionColor = Color.fromARGB(255, 150, 226, 88);
    Color backColor = Color.fromARGB(255, 248, 246, 117);

    return Scaffold(
      backgroundColor: Color.fromRGBO(248, 229, 165, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 150, 226, 88),
        title: Text(
          'Producto',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        toolbarHeight: size.height * 0.1,
        elevation: size.height * 0.003,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            '${item.name}',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: size.height * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(item.price * (1 - item.discount / 100)).toStringAsFixed(2)}€',
                style: const TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 21, 138, 31),
                ),
              ),
              if (item.offer)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${item.discount.toInt()}% OFF',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                      ),
                    ),
                    Text(
                      '€${item.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        decoration: TextDecoration.lineThrough,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          SizedBox(height: size.height * 0.02),
          Text(
            'Valoración:',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          RatingBar.builder(
            ignoreGestures: true,
            initialRating: (item.quality! / 2),
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: 30,
            unratedColor: Colors.amber.withOpacity(0.3),
            itemPadding: EdgeInsets.zero,
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              // Actualizar la valoración del elemento
            },
          ),
          SizedBox(height: size.height * 0.02),
          Text('Descripción:',
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(
            '${item.description!}',
            style: const TextStyle(fontSize: 16),
          ),
          SizedBox(height: size.height * 0.03),
          ElevatedButton(
            onPressed: () {
              print(item.toString());
              Navigator.pushNamed(context, 'itemForm', arguments: item);
            },
            child: const Text('Actualizar'),
          ),
        ],
      ),
    );
  }
}
