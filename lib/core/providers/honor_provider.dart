import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handycraft_app/core/models/honor_model.dart';
import 'package:handycraft_app/core/repository/honor_repository.dart';

final honorRepositoryProvider = Provider<HonorRepository>((ref) {
  return HonorRepository();
});

final honorStreamProvider = StreamProvider.autoDispose<List<Honor>>((ref) {
  final repository = ref.watch(honorRepositoryProvider);
  return repository.getHonorStream();
});