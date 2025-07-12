import 'package:firebase_database/firebase_database.dart';

class Karyawan {
  final String id;
  final String name;
  final String phone;
  final String address;
  final String status;

  Karyawan({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.status,
  });

  factory Karyawan.fromSnapshot(DataSnapshot snapshot) {
    final data = snapshot.value as Map<dynamic, dynamic>;
    return Karyawan(
      id: snapshot.key ?? '',
      name: data['name'] as String,
      phone: data['phone'] as String,
      address: data['address'] as String,
      status: data['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'address': address,
      'status': status,
    };
  }
}

extension KaryawanExtension on Karyawan {
  Karyawan copyWith({
    String? id,
    String? name,
    String? phone,
    String? address,
    String? status,
  }) {
    return Karyawan(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      status: status ?? this.status,
    );
  }
}