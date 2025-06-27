import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handycraft_app/core/models/pelanggan_model.dart';

final pelangganListProvider = FutureProvider<List<Pelanggan>>((ref) async {
  return [
    Pelanggan(
      id: '1',
      name: 'Dadang Sempurno',
      phone: '08123456789',
      address: 'Jl. Pemuda No. 33, Malang',
      description: 'Pesan sumpit dari kayu jati',
    ),
    Pelanggan(
      id: '2',
      name: 'Siti Rahayu',
      phone: '08567890123',
      address: 'Jl. Merdeka No. 12, Surabaya',
      description: 'Buat meja makan dari kayu trembesi',
    ),
    Pelanggan(
      id: '3',
      name: 'Budi Prasetyo',
      phone: '08765432109',
      address: 'Jl. Sudirman No. 45, Bandung',
      description: 'Kursi goyang kayu jati berkualitas',
    ),
    Pelanggan(
      id: '4',
      name: 'Anita Putri',
      phone: '08111223344',
      address: 'Jl. Raya Kopo No. 70, Bekasi',
      description: 'Patung hewan kayu untuk dekorasi rumah',
    ),
    Pelanggan(
      id: '5',
      name: 'Heri Susanto',
      phone: '08987654321',
      address: 'Jl. Cendana No. 5, Semarang',
      description: 'Lemari pajangan custom dari kayu mahoni',
    ),
  ];
});