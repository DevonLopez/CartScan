import 'dart:convert';
import 'package:flutter/material.dart';

class MyImageWidget extends StatelessWidget {
  final String imageData;

  const MyImageWidget({required this.imageData});

  @override
  Widget build(BuildContext context) {
    print(imageData);
    if (imageData.isEmpty) {
      return Container(); // Opcional: Puedes mostrar un widget de carga o un marcador de posición en caso de que no haya imagen.
    }

    final decodedBytes = base64Decode(imageData);
    final image = Image.memory(decodedBytes);

    return image;
  }
}
