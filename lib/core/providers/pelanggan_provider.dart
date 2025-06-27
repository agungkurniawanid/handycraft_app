import 'package:flutter_riverpod/flutter_riverpod.dart';

class Pelanggan {
  final String id;
  final String name;
  final String phone;
  final String address;

  Pelanggan({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
  });
}

final PelangganListProvider = FutureProvider<List<Pelanggan>>((ref) async {
  return [
    Pelanggan(
      id: '1',
      name: 'Dadang Sempurno',
      phone: '08123456789',
      address: 'Jl. Pemuda No. 33, Malang',
    ),
  ];
});