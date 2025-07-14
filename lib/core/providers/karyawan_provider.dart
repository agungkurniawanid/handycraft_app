import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handycraft_app/core/models/karyawan_model.dart';
import 'package:handycraft_app/core/repository/karyawan_repository.dart';

final karyawanRepositoryProvider = Provider<KaryawanRepository>((ref) {
  return KaryawanRepository();
});

final karyawanStreamProvider = StreamProvider.autoDispose<List<Karyawan>>((ref) {
  final repository = ref.watch(karyawanRepositoryProvider);
  return repository.getKaryawanStream();
});