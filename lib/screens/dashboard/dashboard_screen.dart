import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handycraft_app/core/providers/theme_provider.dart';
import 'package:iconsax/iconsax.dart';
import 'package:handycraft_app/screens/dashboard/add_penerimaan_screen.dart';
import 'package:handycraft_app/screens/dashboard/add_pengeluaran_screen.dart';
import 'package:intl/intl.dart';
import '../../core/models/transaction_model.dart';
import '../../core/providers/dashboard_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final dashboardDataAsync = ref.watch(dashboardControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard HandyCraft'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Iconsax.sun_1 : Iconsax.moon,
              color: isDarkMode ? Colors.amber : Colors.blueGrey,
            ),
            onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
          ),
        ],
      ),
      body: dashboardDataAsync.when(
        data: (data) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildSummaryCard(
                  context,
                  income: data.income,
                  expense: data.expense,
                ),
                const SizedBox(height: 16),
                _buildActionButtons(context),
                const SizedBox(height: 20),
                _buildProfitCard(
                  context,
                  profit: data.profit,
                  isProfit: data.isProfit,
                  income: data.income,
                ),
                const SizedBox(height: 20),
                _buildRecentTransactions(
                  context,
                  transactions: data.recentTransactions,
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Gagal memuat data.\nPastikan Anda memiliki koneksi internet dan data transaksi di Firebase.\nError: $error',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context, {
    required double income,
    required double expense,
  }) {
    final theme = Theme.of(context);
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ringkasan Bulan Ini',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(Iconsax.calendar, color: theme.colorScheme.primary),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: _buildFinancialItem(
                    context,
                    title: 'Penerimaan',
                    amount: income,
                    icon: Iconsax.arrow_down5,
                    color: Colors.green,
                  ),
                ),
                Container(
                  height: 60,
                  width: 1.2,
                  color: theme.dividerColor,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                ),
                Expanded(
                  child: _buildFinancialItem(
                    context,
                    title: 'Pengeluaran',
                    amount: expense,
                    icon: Iconsax.arrow_up_15,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfitCard(
    BuildContext context, {
    required double profit,
    required bool isProfit,
    required double income,
  }) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final cardColor = isProfit
        ? Colors.green.withOpacity(isDarkMode ? 0.2 : 0.1)
        : Colors.red.withOpacity(isDarkMode ? 0.2 : 0.1);
    final textColor = isProfit
        ? (isDarkMode ? Colors.green.shade300 : Colors.green.shade700)
        : (isDarkMode ? Colors.red.shade300 : Colors.red.shade700);
    final icon = isProfit ? Iconsax.chart_success : Iconsax.chart_fail;
    final formattedProfit = _formatCurrency(profit.abs());

    final percentage = income > 0 ? (profit.abs() / income * 100) : 0.0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(
            color: isProfit ? Colors.green.shade100 : Colors.red.shade100,
            width: 1.5,
          ),
        ),
        color: cardColor,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isProfit
                          ? Colors.green.withOpacity(0.2)
                          : Colors.red.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: textColor, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Laba/Rugi Bulan Ini',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formattedProfit,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      fontSize: 28,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (income > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: textColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isProfit
                                ? Iconsax.arrow_up_2
                                : Iconsax.arrow_down_1,
                            size: 16,
                            color: textColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${percentage.toStringAsFixed(1)}%',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentTransactions(
    BuildContext context, {
    required List<TransactionModel> transactions,
  }) {
    final theme = Theme.of(context);

    if (transactions.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text('Belum ada transaksi bulan ini.'),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Transaksi Terakhir',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(onPressed: () {}, child: const Text('Lihat Semua')),
          ],
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: transactions.map((transaction) {
                final isIncome = transaction.tipe == 'penerimaan';
                final formattedAmount = _formatCurrency(transaction.jumlah);
                return ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isIncome
                          ? Colors.green.withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      isIncome ? Iconsax.arrow_down : Iconsax.arrow_up,
                      color: isIncome ? Colors.green : Colors.red,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    transaction.deskripsi,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    DateFormat('d MMM yyyy').format(
                      DateTime.fromMillisecondsSinceEpoch(
                        transaction.timestamp,
                      ),
                    ),
                  ),
                  trailing: Text(
                    '${isIncome ? '+' : '-'}$formattedAmount',
                    style: TextStyle(
                      color: isIncome ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {},
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: _buildSimpleActionButton(
            context,
            icon: Iconsax.add,
            label: 'Tambah Penerimaan',
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildSimpleActionButton(
            context,
            icon: Iconsax.add,
            label: 'Tambah Pengeluaran',
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildSimpleActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
  }) {
    final theme = Theme.of(context);
    return ElevatedButton(
      onPressed: () {
        if (label == 'Tambah Penerimaan') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddPenerimaanScreen(),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddPengeluaranScreen(),
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: color.withOpacity(0.3)),
        ),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialItem(
    BuildContext context, {
    required String title,
    required double amount,
    required IconData icon,
    required Color color,
  }) {
    final theme = Theme.of(context);
    final formattedAmount = _formatCurrency(amount);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          formattedAmount,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  String _formatCurrency(double amount) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatCurrency.format(amount);
  }
}
