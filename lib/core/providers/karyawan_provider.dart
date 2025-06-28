import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handycraft_app/core/models/karyawan_model.dart';

final karyawanListProvider = FutureProvider<List<Karyawan>>((ref) async {
  return [
    Karyawan(
      id: '1',
      name: 'Andi Saputra',
      phone: '08123456789',
      address: 'Jl. Kayu Jati No. 12, Semarang',
      status: 'Tetap',
      position: 'Pengrajin Kayu',
    ),
    Karyawan(
      id: '2',
      name: 'Budi Santoso',
      phone: '08234567890',
      address: 'Jl. Mahoni No. 34, Bandung',
      status: 'Lepas',
      position: 'Pembuat Sumpit',
    ),
    Karyawan(
      id: '3',
      name: 'Citra Dewi',
      phone: '08345678901',
      address: 'Jl. Trembesi No. 56, Jakarta',
      status: 'Tetap',
      position: 'Finishing Produk',
    ),
  ];
});

final honorListProvider = FutureProvider<List<Honor>>((ref) async {
  return [
    Honor(
      id: '1',
      karyawanId: '1',
      jenisPekerjaan: 'Honor Harian',
      gaji: 150000,
      satuan: 'per hari',
      statusKaryawan: 'Tetap',
    ),
    Honor(
      id: '2',
      karyawanId: '2',
      jenisPekerjaan: 'Borongan Sumpit',
      gaji: 500,
      satuan: 'per pcs',
      statusKaryawan: 'Lepas',
    ),
    Honor(
      id: '3',
      karyawanId: '3',
      jenisPekerjaan: 'Honor Harian',
      gaji: 120000,
      satuan: 'per hari',
      statusKaryawan: 'Tetap',
    ),
  ];
});