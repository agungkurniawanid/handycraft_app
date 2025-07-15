import 'package:firebase_database/firebase_database.dart';

class PenerimaanModel {
  final String id;
  final String tanggal;
  final String transaksi;
  final String pelanggan;
  final num kuantitas;
  final String satuan;
  final num hargaSatuan;
  final num total;
  final String keterangan;

  PenerimaanModel({
    required this.id,
    required this.tanggal,
    required this.transaksi,
    required this.pelanggan,
    required this.kuantitas,
    required this.satuan,
    required this.hargaSatuan,
    required this.total,
    required this.keterangan,
  });

  factory PenerimaanModel.fromSnapshot(DataSnapshot snapshot) {
    final data = snapshot.value as Map<dynamic, dynamic>;
    return PenerimaanModel(
      id: snapshot.key ?? '',
      tanggal: data['tanggal'] as String,
      transaksi: data['transaksi'] as String,
      pelanggan: data['pelanggan'] as String,
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
      'pelanggan': pelanggan,
      'kuantitas': kuantitas,
      'satuan': satuan,
      'hargaSatuan': hargaSatuan,
      'total': total,
      'keterangan': keterangan,
    };
  }
}
