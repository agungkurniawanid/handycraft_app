import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:handycraft_app/core/models/karyawan_model.dart';

class KaryawanRepository {
  final FirebaseApp _firebaseApp = Firebase.app('MyAppInstance');
  late final DatabaseReference _dbRef;

  KaryawanRepository() {
    _dbRef = FirebaseDatabase.instanceFor(app: _firebaseApp).ref();
  }

  Future<void> addKaryawan(Karyawan karyawan) async {
    final newKaryawanRef = _dbRef.child('master_data/karyawan').push();
    await newKaryawanRef.set(
      karyawan.copyWith(id: newKaryawanRef.key).toJson(),
    );
  }

  Future<void> updateKaryawan(Karyawan karyawan) async {
    await _dbRef.child('master_data/karyawan').child(karyawan.id).update(
      karyawan.toJson(),
    );
  }

  Future<void> deleteKaryawan(String karyawanId) async {
    await _dbRef.child('master_data/karyawan').child(karyawanId).remove();
  }

  Stream<List<Karyawan>> getKaryawanStream() {
    final query = _dbRef.child('master_data/karyawan');
    return query.onValue.map((event) {
      if (event.snapshot.exists && event.snapshot.value != null) {
        return event.snapshot.children.map((snapshot) {
          return Karyawan.fromSnapshot(snapshot);
        }).toList();
      }
      return [];
    });
  }

  Future<Karyawan?> getKaryawanById(String id) async {
    final snapshot = await _dbRef.child('master_data/karyawan').child(id).get();
    if (snapshot.exists) {
      return Karyawan.fromSnapshot(snapshot);
    }
    return null;
  }
}