import 'package:firebase_database/firebase_database.dart';

class Pelanggan {
  final String id;
  final String name;
  final String phone;
  final String address;
  final String description;

  const Pelanggan({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.description,
  });

  // Factory constructor dari JSON (misalnya dari API)
  factory Pelanggan.fromJson(Map<String, dynamic> json) {
    return Pelanggan(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      description: json['description'] as String,
    );
  }

  // Method untuk mengubah objek menjadi Map JSON untuk disimpan ke Firebase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'address': address,
      'description': description,
    };
  }

  // --- PERBAIKAN DI SINI ---
  // Factory constructor dari DataSnapshot Firebase
  factory Pelanggan.fromSnapshot(DataSnapshot snapshot) {
    // 1. Casting snapshot.value menjadi Map yang aman
    final data = snapshot.value as Map<dynamic, dynamic>;

    // 2. Buat objek Pelanggan dari map tersebut
    return Pelanggan(
      id: snapshot.key ?? '', // ID diambil dari key snapshot
      name: data['name'] as String,
      phone: data['phone'] as String,
      address: data['address'] as String,
      description: data['description'] as String,
    );
  }
}
