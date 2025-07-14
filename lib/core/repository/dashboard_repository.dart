import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import '../models/transaction_model.dart';
import 'package:firebase_database/firebase_database.dart';

class DashboardRepository {
  final FirebaseApp _firebaseApp = Firebase.app('MyAppInstance');
  late final DatabaseReference _dbRef;

  DashboardRepository() {
    _dbRef = FirebaseDatabase.instanceFor(app: _firebaseApp).ref();
  }

  Stream<List<TransactionModel>> getTransactionsForCurrentMonth() {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    final query = _dbRef
        .child('transaksi')
        .orderByChild('timestamp')
        .startAt(firstDayOfMonth.millisecondsSinceEpoch)
        .endAt(lastDayOfMonth.millisecondsSinceEpoch);

    return query.onValue.map((event) {
      if (event.snapshot.exists && event.snapshot.value != null) {
        final transactionList = event.snapshot.children.map((snapshot) {
          return TransactionModel.fromSnapshot(snapshot);
        }).toList();

        transactionList.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        return transactionList;
      } else {
        return [];
      }
    });
  }
}