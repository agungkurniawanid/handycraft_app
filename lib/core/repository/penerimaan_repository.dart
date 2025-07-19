import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:handycraft_app/core/extensions/penerimaan_extension.dart';
import 'package:handycraft_app/core/models/penerimaan_model.dart';

class PenerimaanRepository {
  final FirebaseApp _firebaseApp = Firebase.app('MyAppInstance');
  late final DatabaseReference _dbRef;

  PenerimaanRepository() {
    _dbRef = FirebaseDatabase.instanceFor(app: _firebaseApp).ref();
  }

  Future<void> addPenerimaan(PenerimaanModel penerimaan) async {
    final newRef = _dbRef.child('master_data/penerimaan').push();
    await newRef.set(penerimaan.copyWith(id: newRef.key).toJson());
  }

  Future<void> updatePenerimaan(PenerimaanModel penerimaan) async {
    await _dbRef
        .child('master_data/penerimaan')
        .child(penerimaan.id)
        .update(penerimaan.toJson());
  }

  Future<void> deletePenerimaan(String id) async {
    await _dbRef.child('master_data/penerimaan').child(id).remove();
  }

  Stream<List<PenerimaanModel>> getPenerimaanStream() {
    final query = _dbRef.child('master_data/penerimaan');
    return query.onValue.map((event) {
      if (event.snapshot.exists && event.snapshot.value != null) {
        return event.snapshot.children.map((snapshot) {
          return PenerimaanModel.fromSnapshot(snapshot);
        }).toList();
      }
      return [];
    });
  }

  Future<PenerimaanModel?> getPenerimaanById(String id) async {
    final snapshot = await _dbRef
        .child('master_data/penerimaan')
        .child(id)
        .get();
    if (snapshot.exists) {
      return PenerimaanModel.fromSnapshot(snapshot);
    }
    return null;
  }
}

class PenerimaanLainnyaRepository {
  final FirebaseApp _firebaseApp = Firebase.app('MyAppInstance');
  late final DatabaseReference _dbRef;

  PenerimaanLainnyaRepository() {
    _dbRef = FirebaseDatabase.instanceFor(app: _firebaseApp).ref();
  }

  Future<void> addPenerimaanLainnya(PenerimaanLainnya penerimaan) async {
    final newRef = _dbRef.child('master_data/penerimaan_lainnya').push();
    await newRef.set(penerimaan.copyWith(id: newRef.key).toJson());
  }

  Future<void> updatePenerimaanLainnya(PenerimaanLainnya penerimaan) async {
    await _dbRef
        .child('master_data/penerimaan_lainnya')
        .child(penerimaan.id)
        .update(penerimaan.toJson());
  }

  Future<void> deletePenerimaanLainnya(String id) async {
    await _dbRef.child('master_data/penerimaan_lainnya').child(id).remove();
  }

  Stream<List<PenerimaanLainnya>> getPenerimaanLainnyaStream() {
    final query = _dbRef.child('master_data/penerimaan_lainnya');
    return query.onValue.map((event) {
      if (event.snapshot.exists && event.snapshot.value != null) {
        return event.snapshot.children.map((snapshot) {
          return PenerimaanLainnya.fromSnapshot(snapshot);
        }).toList();
      }
      return [];
    });
  }

  Future<PenerimaanLainnya?> getPenterimaanLainnyaById(String id) async {
    final snapshot = await _dbRef
        .child('master_data/penerimaan_lainnya')
        .child(id)
        .get();
    if (snapshot.exists) {
      return PenerimaanLainnya.fromSnapshot(snapshot);
    }
    return null;
  }
}
