import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handycraft_app/core/models/supplier_model.dart';
import 'package:handycraft_app/core/repository/supplier_repository.dart';

final supplierRepositoryProvider = Provider<SupplierRepository>((ref) {
  return SupplierRepository();
});

final suppliersStreamProvider = StreamProvider.autoDispose<List<Supplier>>((ref) {
  final repository = ref.watch(supplierRepositoryProvider);
  return repository.getSuppliersStream();
});