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

  /// Buat objek dari snapshot Firebase
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

  /// Ubah objek menjadi JSON (Map) untuk dikirim ke Firebase
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
