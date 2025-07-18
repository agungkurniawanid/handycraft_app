import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handycraft_app/core/models/penerimaan_model.dart';
import 'package:handycraft_app/core/models/pengeluaran_model.dart';
import 'package:handycraft_app/core/providers/penerimaan_provider.dart';
import 'package:handycraft_app/core/providers/pengeluaran_provider.dart';

final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

final filteredPenerimaanProvider = Provider.autoDispose<List<PenerimaanModel>>((
  ref,
) {
  final penerimaanList = ref.watch(penerimaanStreamProvider).value ?? [];
  final selectedDate = ref.watch(selectedDateProvider);

  return penerimaanList.where((item) {
    final itemDate = DateTime.parse(item.tanggal);
    return itemDate.month == selectedDate.month &&
        itemDate.year == selectedDate.year;
  }).toList();
});

final filteredPengeluaranProvider = Provider.autoDispose<List<Pengeluaran>>((
  ref,
) {
  final pengeluaranList = ref.watch(pengeluaranStreamProvider).value ?? [];
  final selectedDate = ref.watch(selectedDateProvider);

  return pengeluaranList.where((item) {
    final itemDate = DateTime.parse(item.tanggal);
    return itemDate.month == selectedDate.month &&
        itemDate.year == selectedDate.year;
  }).toList();
});

final filteredPengeluaranGajiProvider =
    Provider.autoDispose<List<PengeluaranGajiKaryawan>>((ref) {
      final gajiList =
          ref.watch(pengeluaranGajiKaryawanStreamProvider).value ?? [];
      final selectedDate = ref.watch(selectedDateProvider);

      return gajiList.where((item) {
        final itemDate = DateTime.parse(item.tanggalPengeluaranGaji);
        return itemDate.month == selectedDate.month &&
            itemDate.year == selectedDate.year;
      }).toList();
    });

final totalPenerimaanProvider = Provider.autoDispose<double>((ref) {
  final filteredList = ref.watch(filteredPenerimaanProvider);
  return filteredList.fold(0.0, (sum, item) => sum + item.total.toDouble());
});

final totalPengeluaranProvider = Provider.autoDispose<double>((ref) {
  final pengeluaranList = ref.watch(filteredPengeluaranProvider);
  final gajiList = ref.watch(filteredPengeluaranGajiProvider);

  final totalPengeluaran = pengeluaranList.fold(
    0.0,
    (sum, item) => sum + item.total.toDouble(),
  );
  final totalGaji = gajiList.fold(
    0.0,
    (sum, item) => sum + item.total.toDouble(),
  );

  return totalPengeluaran + totalGaji;
});

final totalProfitProvider = Provider.autoDispose<double>((ref) {
  final income = ref.watch(totalPenerimaanProvider);
  final expense = ref.watch(totalPengeluaranProvider);
  return income - expense;
});

final selectedFilterTypeProvider = StateProvider<String>((ref) => 'month');
