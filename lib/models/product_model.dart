class ProductModel {

  String? id;
  String? name;
  double? price;
  String? description;

  ProductModel({
    this.id,
    this.name,
    this.price,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as String,
      name: map['name'] as String,
      price: map['price'] as double,
      description: map['description'] as String,
    );
  }

}