class Item {
  late String id;
  late String description;
  late double discount;
  late String image;
  late String name;
  late bool offer;
  late double price;
  late int quality;

  Item({
    required this.id,
    required this.description,
    required this.discount,
    required this.image,
    required this.name,
    required this.offer,
    required this.price,
    required this.quality,
  });

  Item.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    offer = json['offer'];
    price = json['price'];
  }

  Item.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    description = map['description'];
    discount = map['discount'];
    image = map['image'];
    name = map['name'];
    offer = map['offer'];
    price = map['price'];
    quality = map['quality'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['discount'] = this.discount;
    data['image'] = this.image;
    data['name'] = this.name;
    data['offer'] = this.offer;
    data['price'] = this.price;
    data['quality'] = this.quality;
    return data;
  }
}
