import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:handycraft_app/core/models/supplier_model.dart';

class SupplierRepository {
  final FirebaseApp _firebaseApp = Firebase.app('MyAppInstance');
  late final DatabaseReference _dbRef;

  SupplierRepository() {
    _dbRef = FirebaseDatabase.instanceFor(app: _firebaseApp).ref();
  }

  Future<void> addSupplier(Supplier supplier) async {
    final newSupplierRef = _dbRef.child('master_data/supplier').push();
    await newSupplierRef.set(
      supplier.copyWith(id: newSupplierRef.key).toJson(),
    );
  }

  Future<void> updateSupplier(Supplier supplier) async {
    await _dbRef.child('master_data/supplier').child(supplier.id).update(
      supplier.toJson(),
    );
  }

  Future<void> deleteSupplier(String supplierId) async {
    await _dbRef.child('master_data/supplier').child(supplierId).remove();
  }

  Stream<List<Supplier>> getSuppliersStream() {
    final query = _dbRef.child('master_data/supplier');
    return query.onValue.map((event) {
      if (event.snapshot.exists && event.snapshot.value != null) {
        return event.snapshot.children.map((snapshot) {
          return Supplier.fromSnapshot(snapshot);
        }).toList();
      }
      return [];
    });
  }

  Future<Supplier?> getSupplierById(String id) async {
    final snapshot = await _dbRef.child('master_data/supplier').child(id).get();
    if (snapshot.exists) {
      return Supplier.fromSnapshot(snapshot);
    }
    return null;
  }
}