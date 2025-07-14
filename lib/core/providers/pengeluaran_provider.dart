import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handycraft_app/core/models/pengeluaran_model.dart';
import 'package:handycraft_app/core/repository/pengeluaran_repository.dart';

final pengeluaranRepositoryProvider = Provider<PengeluaranRepository>((ref) {
  return PengeluaranRepository();
});

final pengeluaranStreamProvider = StreamProvider.autoDispose<List<Pengeluaran>>(
  (ref) {
    final repository = ref.watch(pengeluaranRepositoryProvider);
    return repository.getPengeluaranStream();
  },
);
