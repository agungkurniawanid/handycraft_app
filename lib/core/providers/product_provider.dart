import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handycraft_app/core/models/product_model.dart';

final productListProvider = FutureProvider<List<Product>>((ref) async {
  await Future.delayed(const Duration(seconds: 1));
  return [
    Product(id: '1', name: 'Handmade Bag', price: 99.99),
    Product(id: '2', name: 'Wooden Chair', price: 149.99),
  ];
});
