import 'package:handycraft_app/core/models/pengeluaran_model.dart';

extension PengeluaranExtension on Pengeluaran {
  Pengeluaran copyWith({
    String? id,
    String? tanggal,
    String? transaksi,
    String? supplierName,
    num? kuantitas,
    String? satuan,
    num? hargaSatuan,
    num? total,
    String? keterangan,
  }) {
    return Pengeluaran(
      id: id ?? this.id,
      tanggal: tanggal ?? this.tanggal,
      transaksi: transaksi ?? this.transaksi,
      supplierName: supplierName ?? this.supplierName,
      kuantitas: kuantitas ?? this.kuantitas,
      satuan: satuan ?? this.satuan,
      hargaSatuan: hargaSatuan ?? this.hargaSatuan,
      total: total ?? this.total,
      keterangan: keterangan ?? this.keterangan,
    );
  }
}
