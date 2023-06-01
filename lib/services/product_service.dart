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
    final dynamic jsonResponse = json.decode(response.body);

    if (jsonResponse != null) {
      final dynamic productData = jsonResponse['product'];

      if (productData is List) {
        // Manejar el caso de una lista de productos
        if (productData.isNotEmpty) {
          final jsonMap = productData.first;
          return Product.fromJson(jsonMap);
        } else {
          throw Exception('Empty product list');
        }
      } else if (productData is Map<String, dynamic>) {
        // Manejar el caso de un solo producto
        return Product.fromJson(productData);
      } else {
        throw Exception('Invalid product data');
      }
    } else {
      throw Exception('Invalid response');
    }
  } else {
    throw Exception('Failed to fetch product data');
  }
}
