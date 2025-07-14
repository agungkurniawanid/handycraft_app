import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handycraft_app/core/models/product_model.dart';

import '../repository/product_repository.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository();
});

final productsStreamProvider = StreamProvider.autoDispose<List<Product>>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getProductsStream();
});


final rawMaterialsStreamProvider = StreamProvider.autoDispose<List<RawMaterialModel>>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getRawMaterialsStream();
});
