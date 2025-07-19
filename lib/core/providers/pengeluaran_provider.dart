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

final pengeluaranGajiKaryawanRepositoryProvider =
    Provider<PengeluaranGajiKaryawanRepository>((ref) {
      return PengeluaranGajiKaryawanRepository();
    });

final pengeluaranGajiKaryawanStreamProvider =
    StreamProvider.autoDispose<List<PengeluaranGajiKaryawan>>((ref) {
      final repository = ref.watch(pengeluaranGajiKaryawanRepositoryProvider);
      return repository.getPengeluaranGajiKaryawanStream();
    });

final pengeluaranLainnyaRepositoryProvider =
    Provider<PengeluaranLainnyaRepository>((ref) {
      return PengeluaranLainnyaRepository();
    });

final pengeluaranLainnyaStreamProvider =
    StreamProvider.autoDispose<List<PengeluaranLainnya>>((ref) {
      final repository = ref.watch(pengeluaranLainnyaRepositoryProvider);
      return repository.getPengeluaranLainnyaStream();
    });
