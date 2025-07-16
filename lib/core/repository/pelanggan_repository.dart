import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import '../models/pelanggan_model.dart';

class PelangganRepository {
  // Menggunakan instance Firebase yang telah kita beri nama
  final FirebaseApp _firebaseApp = Firebase.app('MyAppInstance');
  late final DatabaseReference _dbRef;

  PelangganRepository() {
    // Mengambil referensi database dari instance yang bernama
    _dbRef = FirebaseDatabase.instanceFor(app: _firebaseApp).ref();
  }

  /// Menambahkan pelanggan baru ke Firebase.
  /// ID unik akan dibuat secara otomatis oleh Firebase.
  Future<void> addPelanggan(Pelanggan pelanggan) async {
    // .push() akan membuat node baru dengan ID unik
    final newPelangganRef = _dbRef.child('master_data/pelanggan').push();
    // Simpan data pelanggan dengan ID yang baru dibuat
    await newPelangganRef.set(pelanggan.copyWith(id: newPelangganRef.key).toJson());
  }

  /// Memperbarui data pelanggan yang sudah ada di Firebase.
  Future<void> updatePelanggan(Pelanggan pelanggan) async {
    await _dbRef.child('master_data/pelanggan').child(pelanggan.id).update(pelanggan.toJson());
  }

  /// Menghapus data pelanggan dari Firebase berdasarkan ID.
  Future<void> deletePelanggan(String pelangganId) async {
    await _dbRef.child('master_data/pelanggan').child(pelangganId).remove();
  }

  /// Mendapatkan stream (aliran data) daftar pelanggan secara real-time.
  /// Setiap ada perubahan data di Firebase, stream ini akan mengirimkan daftar terbaru.
  Stream<List<Pelanggan>> getPelanggansStream() {
    final query = _dbRef.child('master_data/pelanggan');
    return query.onValue.map((event) {
      if (event.snapshot.exists && event.snapshot.value != null) {
        // Ubah data dari Firebase menjadi List<Pelanggan>
        final pelangganList = event.snapshot.children.map((snapshot) {
          return Pelanggan.fromSnapshot(snapshot);
        }).toList();
        // Urutkan berdasarkan nama
        pelangganList.sort((a, b) => a.name.compareTo(b.name));
        return pelangganList;
      }
      // Jika tidak ada data, kembalikan list kosong
      return [];
    });
  }
}

// Extension helper untuk mempermudah pembaruan ID saat menyimpan data baru.
extension on Pelanggan {
  Pelanggan copyWith({String? id}) {
    return Pelanggan(
      id: id ?? this.id,
      name: name,
      phone: phone,
      address: address,
      description: description,
    );
  }
}
