import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handycraft_app/core/models/product_model.dart';

final productListProvider = FutureProvider<List<Product>>((ref) async {
  await Future.delayed(const Duration(seconds: 1));
  return [
    Product(
      id: '1',
      name: 'Perahu Mini Jadi',
      price: 150000,
      unit: 'pcs',
    ),
    Product(
      id: '2',
      name: 'Sumpit',
      price: 3000,
      unit: 'pcs',
    ),
  ];
});

final materialListProvider = FutureProvider<List<RawMaterialModel>>((ref) async {
  await Future.delayed(const Duration(seconds: 1));
  return [
    RawMaterialModel(
      id: '1',
      name: 'Kayu',
      price: 3000000,
      unit: 'cm3',
    ),
    RawMaterialModel(
      id: '2',
      name: 'Cat (5 liter)',
      price: 150000,
      unit: 'kaleng',
    ),
  ];
});