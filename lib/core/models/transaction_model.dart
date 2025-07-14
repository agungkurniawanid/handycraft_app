import 'package:firebase_database/firebase_database.dart';

class TransactionModel {
  final String id;
  final int timestamp;
  final String tanggal;
  final String tipe;
  final String kategori;
  final String deskripsi;
  final double jumlah;

  TransactionModel({
    required this.id,
    required this.timestamp,
    required this.tanggal,
    required this.tipe,
    required this.kategori,
    required this.deskripsi,
    required this.jumlah,
  });

  factory TransactionModel.fromSnapshot(DataSnapshot snapshot) {
    final data = snapshot.value as Map<dynamic, dynamic>;
    return TransactionModel(
      id: snapshot.key ?? '',
      timestamp: data['timestamp'] as int,
      tanggal: data['tanggal'] as String,
      tipe: data['tipe'] as String,
      kategori: data['kategori'] as String,
      deskripsi: data['deskripsi'] as String,
      jumlah: (data['jumlah'] as num).toDouble(),
    );
  }

  factory TransactionModel.fromMap(String key, Map<dynamic, dynamic> data) {
    return TransactionModel(
      id: key,
      timestamp: data['timestamp'] as int,
      tanggal: data['tanggal'] as String,
      tipe: data['tipe'] as String,
      kategori: data['kategori'] as String,
      deskripsi: data['deskripsi'] as String,
      jumlah: (data['jumlah'] as num).toDouble(),
    );
  }
}