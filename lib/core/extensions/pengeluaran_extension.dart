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

extension PengeluaranGajiKaryawanExtension on PengeluaranGajiKaryawan {
  PengeluaranGajiKaryawan copyWith({
    String? id,
    String? karyawanId,
    String? namaKaryawan,
    String? tanggalPengeluaranGaji,
    num? jumlahGaji,
    num? total,
    String? keterangan,
    String? honorId,
    String? jenisPekerjaan,
    String? tipeSatuan,
    num? jumlahHariOrBarang,
  }) {
    return PengeluaranGajiKaryawan(
      id: id ?? this.id,
      karyawanId: karyawanId ?? this.karyawanId,
      namaKaryawan: namaKaryawan ?? this.namaKaryawan,
      tanggalPengeluaranGaji:
          tanggalPengeluaranGaji ?? this.tanggalPengeluaranGaji,
      jumlahGaji: jumlahGaji ?? this.jumlahGaji,
      total: total ?? this.total,
      keterangan: keterangan ?? this.keterangan,
      honorId: honorId ?? this.honorId,
      jenisPekerjaan: jenisPekerjaan ?? this.jenisPekerjaan,
      statusKaryawan: statusKaryawan ?? statusKaryawan,
      tipeSatuan: tipeSatuan ?? this.tipeSatuan,
      jumlahHariOrBarang: jumlahHariOrBarang ?? this.jumlahHariOrBarang,
    );
  }
}
