import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handycraft_app/core/models/pelanggan_model.dart';
import '../repository/pelanggan_repository.dart';

// 1. Provider untuk instance PelangganRepository
//    Provider ini hanya membuat dan menyediakan satu objek repository.
final pelangganRepositoryProvider = Provider<PelangganRepository>((ref) {
  return PelangganRepository();
});

// 2. StreamProvider yang menyediakan daftar pelanggan secara real-time
//    Ini menggantikan 'pelangganListProvider' Anda yang lama.
//    Widget akan "menonton" provider ini untuk mendapatkan data terbaru.
final pelanggansStreamProvider = StreamProvider.autoDispose<List<Pelanggan>>((ref) {
  // Ambil instance repository dari provider di atas
  final repository = ref.watch(pelangganRepositoryProvider);
  // Kembalikan stream dari repository
  return repository.getPelanggansStream();
});
