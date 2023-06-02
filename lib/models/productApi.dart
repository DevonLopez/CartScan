class Product {
  final dynamic artist;
  final dynamic attributes;
  final dynamic author;
  final dynamic barcodeFormats;
  final dynamic brand;
  final dynamic category;
  final String description;
  final dynamic features;
  final dynamic images;
  final dynamic ingredients;
  final dynamic manufacturer;
  final dynamic onlineStores;
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
      attributes: json['attributes'],
      author: json['author'],
      barcodeFormats: json['barcodeFormats'],
      brand: json['brand'],
      category: json['category'],
      description: json['description'],
      features: json['features'],
      images: json['images'],
      ingredients: json['ingredients'],
      manufacturer: json['manufacturer'],
      onlineStores: json['onlineStores'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'artist': artist,
      'attributes': attributes,
      'author': author,
      'barcodeFormats': barcodeFormats,
      'brand': brand,
      'category': category,
      'description': description,
      'features': features,
      'images': images,
      'ingredients': ingredients,
      'manufacturer': manufacturer,
      'onlineStores': onlineStores,
      'title': title,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      artist: map['artist'],
      attributes: map['attributes'],
      author: map['author'],
      barcodeFormats: map['barcodeFormats'],
      brand: map['brand'],
      category: map['category'],
      description: map['description'],
      features: map['features'],
      images: map['images'],
      ingredients: map['ingredients'],
      manufacturer: map['manufacturer'],
      onlineStores: map['onlineStores'],
      title: map['title'],
    );
  }

  @override
  String toString() {
    return 'Product(artist: $artist, attributes: $attributes, author: $author, barcodeFormats: $barcodeFormats, brand: $brand, category: $category, description: $description, features: $features, images: $images, ingredients: $ingredients, manufacturer: $manufacturer, onlineStores: $onlineStores, title: $title)';
  }
}
