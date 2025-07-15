import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:handycraft_app/core/extensions/pengeluaran_extension.dart';
import 'package:handycraft_app/core/models/pengeluaran_model.dart';

class PengeluaranRepository {
  final FirebaseApp _firebaseApp = Firebase.app('MyAppInstance');
  late final DatabaseReference _dbRef;

  PengeluaranRepository() {
    _dbRef = FirebaseDatabase.instanceFor(app: _firebaseApp).ref();
  }

  Future<void> addPengeluaran(Pengeluaran pengeluaran) async {
    final newRef = _dbRef.child('master_data/pengeluaran').push();
    await newRef.set(pengeluaran.copyWith(id: newRef.key).toJson());
  }

  Future<void> updatePengeluaran(Pengeluaran pengeluaran) async {
    await _dbRef
        .child('master_data/pengeluaran')
        .child(pengeluaran.id)
        .update(pengeluaran.toJson());
  }

  Future<void> deletePengeluaran(String id) async {
    await _dbRef.child('master_data/pengeluaran').child(id).remove();
  }

  Stream<List<Pengeluaran>> getPengeluaranStream() {
    final query = _dbRef.child('master_data/pengeluaran');
    return query.onValue.map((event) {
      if (event.snapshot.exists && event.snapshot.value != null) {
        return event.snapshot.children.map((snapshot) {
          return Pengeluaran.fromSnapshot(snapshot);
        }).toList();
      }
      return [];
    });
  }

  Future<Pengeluaran?> getPengeluaranById(String id) async {
    final snapshot = await _dbRef
        .child('master_data/pengeluaran')
        .child(id)
        .get();
    if (snapshot.exists) {
      return Pengeluaran.fromSnapshot(snapshot);
    }
    return null;
  }
}
