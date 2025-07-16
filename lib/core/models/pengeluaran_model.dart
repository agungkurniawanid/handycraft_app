import 'package:firebase_database/firebase_database.dart';

class Pengeluaran {
  final String id;
  final String tanggal;
  final String transaksi;
  final String supplierName;
  final num kuantitas;
  final String satuan;
  final num hargaSatuan;
  final num total;
  final String keterangan;

  Pengeluaran({
    required this.id,
    required this.tanggal,
    required this.transaksi,
    required this.supplierName,
    required this.kuantitas,
    required this.satuan,
    required this.hargaSatuan,
    required this.total,
    required this.keterangan,
  });

  factory Pengeluaran.fromSnapshot(DataSnapshot snapshot) {
    final data = snapshot.value as Map<dynamic, dynamic>;
    return Pengeluaran(
      id: snapshot.key ?? '',
      tanggal: data['tanggal'] as String,
      transaksi: data['transaksi'] as String,
      supplierName: data['supplierName'] as String,
      kuantitas: data['kuantitas'] as num,
      satuan: data['satuan'] as String,
      hargaSatuan: data['hargaSatuan'] as num,
      total: data['total'] as num,
      keterangan: data['keterangan'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tanggal': tanggal,
      'transaksi': transaksi,
      'supplierName': supplierName,
      'kuantitas': kuantitas,
      'satuan': satuan,
      'hargaSatuan': hargaSatuan,
      'total': total,
      'keterangan': keterangan,
    };
  }
}

class PengeluaranGajiKaryawan {
  final String id;
  final String karyawanId;
  final String namaKaryawan;
  final String tanggalPengeluaranGaji;
  final num jumlahGaji;
  final num total;
  final String keterangan;
  final String? honorId;
  final String? jenisPekerjaan;
  final String? statusKaryawan;
  final String? tipeSatuan;

  PengeluaranGajiKaryawan({
    required this.id,
    required this.karyawanId,
    required this.namaKaryawan,
    required this.tanggalPengeluaranGaji,
    required this.jumlahGaji,
    required this.total,
    required this.keterangan,
    this.honorId,
    this.jenisPekerjaan,
    this.statusKaryawan,
    this.tipeSatuan,
  });

  factory PengeluaranGajiKaryawan.fromSnapshot(DataSnapshot snapshot) {
    final data = snapshot.value as Map<dynamic, dynamic>;
    return PengeluaranGajiKaryawan(
      id: snapshot.key ?? '',
      karyawanId: data['karyawanId'] as String,
      namaKaryawan: data['namaKaryawan'] as String,
      tanggalPengeluaranGaji: data['tanggalPengeluaranGaji'] as String,
      jumlahGaji: data['jumlahGaji'] as num,
      total: data['total'] as num,
      keterangan: data['keterangan'] as String,
      honorId: data['honorId'] as String?,
      jenisPekerjaan: data['jenisPekerjaan'] as String?,
      statusKaryawan: data['statusKaryawan'] as String?,
      tipeSatuan: data['tipeSatuan'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'karyawanId': karyawanId,
      'namaKaryawan': namaKaryawan,
      'tanggalPengeluaranGaji': tanggalPengeluaranGaji,
      'jumlahGaji': jumlahGaji,
      'total': total,
      'keterangan': keterangan,
      'honorId': honorId,
      'jenisPekerjaan': jenisPekerjaan,
      'statusKaryawan': statusKaryawan,
      'tipeSatuan': tipeSatuan,
    };
  }
}
