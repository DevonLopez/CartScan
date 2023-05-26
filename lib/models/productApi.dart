class Product {
  final dynamic artist;
  final List<dynamic> attributes;
  final dynamic author;
  final Map<String, dynamic> barcodeFormats;
  final dynamic brand;
  final dynamic category;
  final dynamic description;
  final List<dynamic> features;
  final List<String> images;
  final dynamic ingredients;
  final dynamic manufacturer;
  final List<OnlineStore> onlineStores;
  final String title;

  Product({
    required this.artist,
    required this.attributes,
    required this.author,
    required this.barcodeFormats,
    required this.brand,
    required this.category,
    required this.description,
    required this.features,
    required this.images,
    required this.ingredients,
    required this.manufacturer,
    required this.onlineStores,
    required this.title,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      artist: json['artist'],
      attributes: List<dynamic>.from(json['attributes']),
      author: json['author'],
      barcodeFormats: json['barcode_formats'],
      brand: json['brand'],
      category: json['category'],
      description: json['description'],
      features: List<dynamic>.from(json['features']),
      images: List<String>.from(json['images']),
      ingredients: json['ingredients'],
      manufacturer: json['manufacturer'],
      onlineStores: List<OnlineStore>.from(
        json['online_stores'].map((x) => OnlineStore.fromJson(x)),
      ),
      title: json['title'],
    );
  }
}

class OnlineStore {
  final String name;
  final String price;
  final String url;

  OnlineStore({
    required this.name,
    required this.price,
    required this.url,
  });

  factory OnlineStore.fromJson(Map<String, dynamic> json) {
    return OnlineStore(
      name: json['name'],
      price: json['price'],
      url: json['url'],
    );
  }
}
