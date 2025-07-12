import 'package:firebase_database/firebase_database.dart';

class Supplier {
  final String id;
  final String name;
  final String phone;
  final String address;
  final String description;

  Supplier({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.description,
  });

  factory Supplier.fromSnapshot(DataSnapshot snapshot) {
    final data = snapshot.value as Map<dynamic, dynamic>;
    return Supplier(
      id: snapshot.key ?? '',
      name: data['name'] as String,
      phone: data['phone'] as String,
      address: data['address'] as String,
      description: data['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'address': address,
      'description': description,
    };
  }
}

extension SupplierExtension on Supplier {
  Supplier copyWith({
    String? id,
    String? name,
    String? phone,
    String? address,
    String? description,
  }) {
    return Supplier(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      description: description ?? this.description,
    );
  }
}