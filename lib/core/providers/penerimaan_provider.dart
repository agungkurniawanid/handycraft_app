import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handycraft_app/core/models/penerimaan_model.dart';
import 'package:handycraft_app/core/repository/penerimaan_repository.dart';

final penerimaanRepositoryProvider = Provider<PenerimaanRepository>((ref) {
  return PenerimaanRepository();
});

final penerimaanStreamProvider =
    StreamProvider.autoDispose<List<PenerimaanModel>>((ref) {
      final repository = ref.watch(penerimaanRepositoryProvider);
      return repository.getPenerimaanStream();
    });

final penerimaanLainnyaRepositoryProvider =
    Provider<PenerimaanLainnyaRepository>((ref) {
      return PenerimaanLainnyaRepository();
    });

final penerimaanLainnyaStreamProvider =
    StreamProvider.autoDispose<List<PenerimaanLainnya>>((ref) {
      final repository = ref.watch(penerimaanLainnyaRepositoryProvider);
      return repository.getPenerimaanLainnyaStream();
    });
