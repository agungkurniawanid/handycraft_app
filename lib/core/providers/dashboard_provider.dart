import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/transaction_model.dart';
import '../repository/dashboard_repository.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepository();
});

final transactionsStreamProvider = StreamProvider.autoDispose<List<TransactionModel>>((ref) {
  final repository = ref.watch(dashboardRepositoryProvider);
  return repository.getTransactionsForCurrentMonth();
});

class DashboardData {
  final double income;
  final double expense;
  final double profit;
  final bool isProfit;
  final List<TransactionModel> recentTransactions;

  DashboardData({
    required this.income,
    required this.expense,
    required this.profit,
    required this.isProfit,
    required this.recentTransactions,
  });
}

final dashboardControllerProvider = Provider.autoDispose<AsyncValue<DashboardData>>((ref) {
  final asyncTransactions = ref.watch(transactionsStreamProvider);

  return asyncTransactions.when(
    data: (transactions) {
      double totalIncome = 0;
      double totalExpense = 0;

      for (var transaction in transactions) {
        if (transaction.tipe == 'penerimaan') {
          totalIncome += transaction.jumlah;
        } else if (transaction.tipe == 'pengeluaran') {
          totalExpense += transaction.jumlah;
        }
      }

      final profit = totalIncome - totalExpense;
      final isProfit = profit >= 0;

      final recent = transactions.take(4).toList();

      return AsyncValue.data(
        DashboardData(
          income: totalIncome,
          expense: totalExpense,
          profit: profit,
          isProfit: isProfit,
          recentTransactions: recent,
        ),
      );
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stackTrace) => AsyncValue.error(error, stackTrace),
  );
});