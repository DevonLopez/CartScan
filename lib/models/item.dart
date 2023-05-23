class Item {
  final String id;
  final String listId;
  final String name;
  final String description;
  final String image;
  final double price;
  final double discount;
  final int quality;
  final bool offer;

  Item({
    required this.id,
    required this.listId,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.discount,
    required this.quality,
    required this.offer,
  });

  factory Item.fromMap(Map<String, dynamic> json) {
    final String id =
        json.keys.first; // Obtener el ID del documento autogenerado
    final String? listId = json["listId"];
    final String? name = json["name"];
    final String? description = json["description"];
    final String? image = json["image"];
    final double? price = json["price"]?.toDouble();
    final double? discount = json["discount"]?.toDouble();
    final int? quality = json["quality"];
    final bool? offer = json["offer"];

    if (listId == null ||
        name == null ||
        description == null ||
        image == null ||
        price == null ||
        discount == null ||
        quality == null ||
        offer == null) {
      throw Exception("One or more fields are missing or null");
    }

    return Item(
      id: id,
      listId: listId,
      name: name,
      description: description,
      image: image,
      price: price,
      discount: discount,
      quality: quality,
      offer: offer,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "listId": listId,
      "name": name,
      "description": description,
      "image": image,
      "price": price,
      "discount": discount,
      "quality": quality,
      "offer": offer,
    };
  }
}
