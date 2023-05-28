class Item {
  final String? id;
  late String? listId;
  final String name;
  final String? description;
  final double price;
  final double discount;
  final int? quality;
  final bool offer;

  Item({
    required this.id,
    required this.listId,
    required this.name,
    this.description,
    required this.price,
    required this.discount,
    this.quality,
    required this.offer,
  });

  factory Item.fromMap(Map<String, dynamic> json) {
    final String id =
        json.keys.first; // Obtener el ID del documento autogenerado
    final String? listId = json["listId"];
    final String? name = json["name"];
    final String? description = json["description"];
    final double? price = json["price"]?.toDouble();
    final double? discount = json["discount"]?.toDouble();
    final int? quality = json["quality"];
    final bool? offer = json["offer"];

    if (listId == null ||
        name == null ||
        price == null ||
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
}
