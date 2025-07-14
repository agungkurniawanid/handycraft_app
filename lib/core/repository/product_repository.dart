import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:handycraft_app/core/models/product_model.dart';

class ProductRepository {
  final FirebaseApp _firebaseApp = Firebase.app('MyAppInstance');
  late final DatabaseReference _dbRef;

  ProductRepository() {
    _dbRef = FirebaseDatabase.instanceFor(app: _firebaseApp).ref();
  }

  Future<void> addProduct(Product product) async {
    final newProductRef = _dbRef.child('master_data/produk').push();
    await newProductRef.set(product.copyWith(id: newProductRef.key).toJson());
  }

  Future<void> addRawMaterial(RawMaterialModel material) async {
    final newMaterialRef = _dbRef.child('master_data/bahan_baku').push();
    await newMaterialRef.set(material.copyWith(id: newMaterialRef.key).toJson());
  }

  Future<void> deleteProduct(String productId) async {
    await _dbRef.child('master_data/produk').child(productId).remove();
  }

  Future<void> deleteRawMaterial(String materialId) async {
    await _dbRef.child('master_data/bahan_baku').child(materialId).remove();
  }

  Future<void> updateProduct(Product product) async {
    await _dbRef.child('master_data/produk').child(product.id).update(product.toJson());
  }

  Future<void> updateRawMaterial(RawMaterialModel material) async {
    await _dbRef.child('master_data/bahan_baku').child(material.id).update(material.toJson());
  }

  Stream<List<Product>> getProductsStream() {
    final query = _dbRef.child('master_data/produk');
    return query.onValue.map((event) {
      if (event.snapshot.exists && event.snapshot.value != null) {
        return event.snapshot.children.map((snapshot) {
          return Product.fromSnapshot(snapshot);
        }).toList();
      }
      return [];
    });
  }

  Stream<List<RawMaterialModel>> getRawMaterialsStream() {
    final query = _dbRef.child('master_data/bahan_baku');
    return query.onValue.map((event) {
      if (event.snapshot.exists && event.snapshot.value != null) {
        return event.snapshot.children.map((snapshot) {
          return RawMaterialModel.fromSnapshot(snapshot);
        }).toList();
      }
      return [];
    });
  }
}

extension on Product {
  Product copyWith({String? id}) => Product(
    id: id ?? this.id,
    name: name,
    price: price,
    unit: unit,
  );
}

extension on RawMaterialModel {
  RawMaterialModel copyWith({String? id}) => RawMaterialModel(
    id: id ?? this.id,
    name: name,
    price: price,
    unit: unit,
  );
}
