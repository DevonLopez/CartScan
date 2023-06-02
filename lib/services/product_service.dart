import 'dart:convert';
import 'package:cart_scan/models/models.dart';
import 'package:http/http.dart' as http;

Future<Product?> fetchProductData(String barcode) async {
  final url = Uri.https('barcodes1.p.rapidapi.com', '/', {'query': barcode});
  final headers = {
    'X-RapidAPI-Key': '978a944bcamshc680d132a313acdp110671jsncf86bd205e9e',
    'X-RapidAPI-Host': 'barcodes1.p.rapidapi.com',
  };

  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    print(response.body);

    if (jsonResponse != null) {
      final productData = jsonResponse['product'];

      if (productData is List) {
        // Manejar el caso de una lista de productos
        if (productData.isNotEmpty) {
          final jsonMap = productData.first;
          print(Product.fromJson(jsonMap).toString());
          return Product.fromJson(jsonMap);
        } else {
          throw Exception('Empty product list');
        }
      } else if (productData is Map<String, dynamic>) {
        // Manejar el caso de un solo producto
        final attributes = productData['attributes'] ?? [];
        final category = productData['category'] ?? [];
        final description = productData['description'] ?? '';
        final features = productData['features'] ?? [];
        final images = productData['images'] ?? [];
        final manufacturer = productData['manufacturer'] ?? '';
        final onlineStores = productData['online_stores'] ?? [];
        final title = productData['title'] ?? '';

        final correctedProductData = {
          'attributes': attributes,
          'category': category,
          'description': description,
          'features': features,
          'images': images,
          'manufacturer': manufacturer,
          'online_stores': onlineStores,
          'title': title,
        };

        return Product.fromJson(correctedProductData);
      } else {
        return Product(
            artist: null,
            attributes: null,
            author: null,
            barcodeFormats: null,
            brand: null,
            category: null,
            description: '',
            features: null,
            images: null,
            ingredients: null,
            manufacturer: null,
            onlineStores: null,
            title: '');
      }
    } else {
      throw Exception('Invalid response');
    }
  }
}
