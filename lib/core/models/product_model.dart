import 'package:firebase_database/firebase_database.dart';

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

  factory Product.fromSnapshot(DataSnapshot snapshot) {
    final data = snapshot.value as Map<dynamic, dynamic>;
    return Product(
      id: snapshot.key ?? '',
      name: data['name'] as String,
      price: (data['price'] as num).toDouble(),
      unit: data['unit'] as String? ?? 'pcs',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'unit': unit,
    };
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

  // Factory untuk membuat objek dari DataSnapshot Firebase
  factory RawMaterialModel.fromSnapshot(DataSnapshot snapshot) {
    final data = snapshot.value as Map<dynamic, dynamic>;
    return RawMaterialModel(
      id: snapshot.key ?? '',
      name: data['name'] as String,
      price: (data['price'] as num).toDouble(),
      unit: data['unit'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'unit': unit,
    };
  }
}
