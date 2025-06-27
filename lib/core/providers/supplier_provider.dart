import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handycraft_app/core/models/supplier_model.dart';

final supplierListProvider = FutureProvider<List<Supplier>>((ref) async {
  return [
    Supplier(
      id: '1',
      name: 'Hendra Wijaya',
      phone: '08123456789',
      address: 'Jl. Ahmad Yani No. 25, Semarang',
      description: 'Supplier Kayu',
    ),
    Supplier(
      id: '2',
      name: 'Siti Nurhaliza',
      phone: '08567890123',
      address: 'Jl. Diponegoro No. 45, Bandung',
      description: 'Supplier Cat dan Pelapis',
    ),
    Supplier(
      id: '3',
      name: 'Budi Santoso',
      phone: '087812345678',
      address: 'Jl. Sudirman No. 10, Jakarta',
      description: 'Supplier Besi dan Baja',
    ),
    Supplier(
      id: '4',
      name: 'Agus Setiawan',
      phone: '081345678901',
      address: 'Jl. Gajah Mada No. 89, Surabaya',
      description: 'Supplier Semen dan Material Bangunan',
    ),
    Supplier(
      id: '5',
      name: 'Rina Kartika',
      phone: '085789012345',
      address: 'Jl. Pahlawan No. 12, Medan',
      description: 'Supplier Listrik dan Elektronik',
    ),
    Supplier(
      id: '6',
      name: 'Dedi Prasetyo',
      phone: '089678901234',
      address: 'Jl. Merdeka No. 5, Makassar',
      description: 'Supplier Pipa dan Sanitasi',
    ),
    Supplier(
      id: '7',
      name: 'Linda Putri',
      phone: '081234509876',
      address: 'Jl. K.H. Hasyim Ashari No. 34, Tangerang',
      description: 'Supplier Plafon dan Partisi',
    ),
  ];
});