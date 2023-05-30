class Item {
  late String? id;
  late String? listId;
  late String name;
  late String description;
  late double price;
  late double discount;
  late int? quality;
  late bool offer;

  Item({
    required this.id,
    required this.listId,
    required this.name,
    required this.description,
    required this.price,
    required this.discount,
    this.quality,
    required this.offer,
  });

  factory Item.fromMap(Map<String, dynamic> json) {
    String id = json.keys.first; // Obtener el ID del documento autogenerado
    String? listId = json["listId"];
    String? name = json["name"];
    String description = json["description"];
    double? price = json["price"]?.toDouble();
    double? discount = json["discount"]?.toDouble();
    int? quality = json["quality"];
    bool? offer = json["offer"];

    if (listId == null ||
        name == null ||
        price == null ||
        description == null ||
        discount == null ||
        offer == null) {
      throw Exception("One or more required fields are missing or null");
    }

    return Item(
      id: id,
      listId: listId,
      name: name,
      description: description,
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
      "price": price,
      "discount": discount,
      "quality": quality,
      "offer": offer,
    };
  }

  @override
  String toString() {
    return 'Item(id: $id, listId: $listId, name: $name, description: $description, price: $price, discount: $discount, quality: $quality, offer: $offer)';
  }
}
