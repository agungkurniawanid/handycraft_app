class Product {
  final String id;
  final String name;
  final double price;
  final String unit;

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.unit = 'pcs',
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      unit: json['unit'] ?? 'pcs',
    );
  }
}

class RawMaterialModel {
  final String id;
  final String name;
  final double price;
  final String unit;

  RawMaterialModel({
    required this.id,
    required this.name,
    required this.price,
    required this.unit,
  });

  factory RawMaterialModel.fromJson(Map<String, dynamic> json) {
    return RawMaterialModel(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      unit: json['unit'],
    );
  }
}
