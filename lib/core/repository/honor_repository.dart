import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:handycraft_app/core/models/honor_model.dart';

class HonorRepository {
  final FirebaseApp _firebaseApp = Firebase.app('MyAppInstance');
  late final DatabaseReference _dbRef;

  HonorRepository() {
    _dbRef = FirebaseDatabase.instanceFor(app: _firebaseApp).ref();
  }

  Future<void> addHonor(Honor honor) async {
    final newHonorRef = _dbRef.child('master_data/honor').push();
    await newHonorRef.set(
      honor.copyWith(id: newHonorRef.key).toJson(),
    );
  }

  Future<void> updateHonor(Honor honor) async {
    await _dbRef.child('master_data/honor').child(honor.id).update(
      honor.toJson(),
    );
  }

  Future<void> deleteHonor(String honorId) async {
    await _dbRef.child('master_data/honor').child(honorId).remove();
  }

  Stream<List<Honor>> getHonorStream() {
    final query = _dbRef.child('master_data/honor');
    return query.onValue.map((event) {
      if (event.snapshot.exists && event.snapshot.value != null) {
        return event.snapshot.children.map((snapshot) {
          return Honor.fromSnapshot(snapshot);
        }).toList();
      }
      return [];
    });
  }

  Future<Honor?> getHonorById(String id) async {
    final snapshot = await _dbRef.child('master_data/honor').child(id).get();
    if (snapshot.exists) {
      return Honor.fromSnapshot(snapshot);
    }
    return null;
  }
}