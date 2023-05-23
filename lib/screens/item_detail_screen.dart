import 'package:cart_scan/models/models.dart';
import 'package:flutter/material.dart';

class ItemDetailScreen extends StatelessWidget {
  final Item item;

  const ItemDetailScreen({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          SizedBox(height: 16),
          Text(
            item.description,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\€${(item.price * (1 - item.discount / 100)).toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (item.offer)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${item.discount.toInt()}% OFF',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                      ),
                    ),
                    Text(
                      '\€${item.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        decoration: TextDecoration.lineThrough,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            'Valoración: ${item.quality}',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
