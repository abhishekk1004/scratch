class ProductModel {
  String? id;
  String? name;
  double? price;
  String? categoryId;
  String? description;
  String? category;

  ProductModel({
    this.id,
    this.name,
    this.price,
    this.description,
    this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'category': category,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as String?,
      name: map['name'] as String?,
      price: (map['price'] as num?)?.toDouble(),
      description: map['description'] as String?,
      category: map['category'] as String?,
    );
  }
}
