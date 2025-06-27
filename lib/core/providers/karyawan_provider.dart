import 'package:flutter_riverpod/flutter_riverpod.dart';

class Karyawan {
  final String id;
  final String name;
  final String position;
  final String phone;

  Karyawan({
    required this.id,
    required this.name,
    required this.position,
    required this.phone,
  });
}

final KaryawanListProvider = FutureProvider<List<Karyawan>>((ref) async {
  return [
    Karyawan(
      id: '1',
      name: 'Andi Saputra',
      position: 'Pengrajin Kayu',
      phone: '08123456789',
    ),
  ];
});