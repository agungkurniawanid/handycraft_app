import 'package:handycraft_app/core/models/penerimaan_model.dart';

extension PenerimaanExtension on PenerimaanModel {
  PenerimaanModel copyWith({
    String? id,
    String? tanggal,
    String? transaksi,
    String? pelanggan,
    num? kuantitas,
    String? satuan,
    num? hargaSatuan,
    num? total,
    String? keterangan,
  }) {
    return PenerimaanModel(
      id: id ?? this.id,
      tanggal: tanggal ?? this.tanggal,
      transaksi: transaksi ?? this.transaksi,
      pelanggan: pelanggan ?? this.pelanggan,
      kuantitas: kuantitas ?? this.kuantitas,
      satuan: satuan ?? this.satuan,
      hargaSatuan: hargaSatuan ?? this.hargaSatuan,
      total: total ?? this.total,
      keterangan: keterangan ?? this.keterangan,
    );
  }
}

extension IterableExtension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

extension PenerimaanLainnyaExtension on PenerimaanLainnya {
  PenerimaanLainnya copyWith({
    String? id,
    String? tanggal,
    String? uraian,
    num? nominal,
    String? keterangan,
  }) {
    return PenerimaanLainnya(
      id: id ?? this.id,
      tanggal: tanggal ?? this.tanggal,
      uraian: uraian ?? this.uraian,
      nominal: nominal ?? this.nominal,
      keterangan: keterangan ?? this.keterangan,
    );
  }
}
