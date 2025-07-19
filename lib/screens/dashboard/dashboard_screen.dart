import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handycraft_app/core/models/penerimaan_model.dart';
import 'package:handycraft_app/core/models/pengeluaran_model.dart';
import 'package:handycraft_app/core/providers/penerimaan_provider.dart';
import 'package:handycraft_app/core/providers/pengeluaran_provider.dart';
import 'package:handycraft_app/core/providers/pin_provider.dart';
import 'package:handycraft_app/core/providers/summary_total_provider.dart';
import 'package:handycraft_app/core/providers/theme_provider.dart';
import 'package:handycraft_app/screens/dashboard/add_pengeluaran_gaji_screen.dart';
import 'package:handycraft_app/screens/dashboard/add_pengeluaran_lainnya.dart';
import 'package:handycraft_app/screens/dashboard/add_pengeluaran_screen.dart';
import 'package:handycraft_app/screens/dashboard/detail_penerimaan.dart';
import 'package:handycraft_app/screens/dashboard/detail_pengeluaran.dart';
import 'package:handycraft_app/screens/dashboard/detail_pengeluaran_gaji.dart';
import 'package:handycraft_app/screens/dashboard/detail_pengeluaran_lainnya.dart';
import 'package:handycraft_app/screens/dashboard/edit_penerimaan_screen.dart';
import 'package:handycraft_app/screens/dashboard/edit_pengeluaran_gaji.dart';
import 'package:handycraft_app/screens/dashboard/edit_pengeluaran_lainnya.dart';
import 'package:handycraft_app/screens/dashboard/edit_pengeluaran_screen.dart';
import 'package:iconsax/iconsax.dart';
import 'package:handycraft_app/screens/dashboard/add_penerimaan_screen.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import '../../core/providers/dashboard_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  void _showDeleteConfirmationDialog(
    BuildContext context,
    String id,
    int isPenerimaan,
    WidgetRef ref,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text(
          'Apakah Anda yakin ingin menghapus data ${_getTypeDescription(isPenerimaan)} ini?',
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => _confirmDelete(context, id, isPenerimaan, ref),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  Future<void> _selectYear(BuildContext context, WidgetRef ref) async {
    final initialDate = ref.read(selectedDateProvider);
    final DateTime? picked = await showDialog<DateTime>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pilih Tahun'),
          content: SizedBox(
            width: 300,
            height: 300,
            child: YearPicker(
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              initialDate: initialDate,
              selectedDate: initialDate,
              onChanged: (DateTime dateTime) {
                Navigator.pop(context, dateTime);
              },
            ),
          ),
        );
      },
    );

    if (picked != null) {
      ref.read(selectedDateProvider.notifier).state = picked;
    }
  }

  String _getTypeDescription(int isPenerimaan) {
    switch (isPenerimaan) {
      case 1:
        return 'penerimaan';
      case 2:
        return 'pengeluaran';
      case 3:
        return 'pengeluaran gaji karyawan';
      case 4:
        return 'pengeluaran lainnya';
      default:
        return '';
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    String id,
    int isPenerimaan,
    WidgetRef ref,
  ) async {
    Navigator.pop(context);

    try {
      switch (isPenerimaan) {
        case 1:
          await ref.read(penerimaanRepositoryProvider).deletePenerimaan(id);
          break;
        case 2:
          await ref.read(pengeluaranRepositoryProvider).deletePengeluaran(id);
          break;
        case 3:
          await ref
              .read(pengeluaranGajiKaryawanRepositoryProvider)
              .deletePengeluaranGajiKaryawan(id);
          break;
        case 4:
          await ref
              .read(pengeluaranLainnyaRepositoryProvider)
              .deletePengeluaranLainnya(id);
          break;
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Data ${_getTypeDescription(isPenerimaan)} berhasil dihapus',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menghapus: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  String _getMonthYearText(DateTime date) {
    final monthNames = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return '${monthNames[date.month - 1]} ${date.year}';
  }

  Future<void> _selectMonth(BuildContext context, WidgetRef ref) async {
    final selected = ref.read(selectedDateProvider);
    final DateTime? picked = await showMonthPicker(
      context: context,
      initialDate: selected,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      ref.read(selectedDateProvider.notifier).state = picked;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final dashboardDataAsync = ref.watch(dashboardControllerProvider);
    final penerimaanAsync = ref.watch(penerimaanStreamProvider);
    final pengeluaranAsync = ref.watch(pengeluaranStreamProvider);
    final pengeluaranGajiAsync = ref.watch(
      pengeluaranGajiKaryawanStreamProvider,
    );
    final pengeluaranLainnyaAsync = ref.watch(pengeluaranLainnyaStreamProvider);
    final totalPenerimaan = ref.watch(totalPenerimaanProvider);
    final totalPengeluaran = ref.watch(totalPengeluaranProvider);
    final income = ref.watch(totalPenerimaanProvider);

    void _showSettingsMenu() {
      final pinState = ref.read(pinProvider);

      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Iconsax.lock),
                  title: const Text('Ubah PIN'),
                  onTap: () {
                    Navigator.pop(context);
                    _showChangePinDialog(context, ref);
                  },
                ),
                ListTile(
                  leading: Icon(
                    pinState.isPinEnabled
                        ? Iconsax.toggle_on
                        : Iconsax.toggle_off,
                    color: pinState.isPinEnabled ? Colors.green : Colors.red,
                  ),
                  title: Text(
                    pinState.isPinEnabled
                        ? 'Nonaktifkan PIN (Aktif)'
                        : 'Aktifkan PIN (Nonaktif)',
                  ),
                  subtitle: Text(
                    pinState.isPinEnabled
                        ? 'PIN sedang aktif'
                        : 'PIN sedang nonaktif',
                    style: TextStyle(
                      color: pinState.isPinEnabled ? Colors.green : Colors.red,
                    ),
                  ),
                  onTap: () {
                    final newState = !pinState.isPinEnabled;
                    ref
                        .read(pinProvider.notifier)
                        .togglePinEnabled(newState, context);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Iconsax.refresh),
                  title: const Text('Atur Ulang PIN'),
                  onTap: () {
                    Navigator.pop(context);
                    _showResetPinConfirmation(context, ref);
                  },
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Tutup'),
                ),
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Rahmat HandyCraft',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Iconsax.setting),
            onPressed: _showSettingsMenu,
            color: Colors.orange,
          ),
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
                  ref,
                  income: totalPenerimaan,
                  expense: totalPengeluaran,
                ),
                const SizedBox(height: 16),
                _buildActionButtons(context),
                const SizedBox(height: 20),
                _buildProfitCard(context, ref, income: income),
                const SizedBox(height: 20),
                _buildPenerimaanList(penerimaanAsync, ref, context),
                const SizedBox(height: 20),
                _buildPengeluaranList(pengeluaranAsync, ref, context),
                const SizedBox(height: 20),
                _buildPengeluaranGajiList(pengeluaranGajiAsync, ref, context),
                const SizedBox(height: 20),
                _buildPengeluaranLainnyaList(
                  pengeluaranLainnyaAsync,
                  ref,
                  context,
                ),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: Colors.orange),
        ),
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
    BuildContext context,
    WidgetRef ref, {
    required double income,
    required double expense,
  }) {
    final theme = Theme.of(context);
    final selectedDate = ref.watch(selectedDateProvider);
    final hasPenerimaanData = ref.watch(filteredPenerimaanProvider).isNotEmpty;
    final hasPengeluaranData =
        ref.watch(filteredPengeluaranProvider).isNotEmpty ||
        ref.watch(filteredPengeluaranGajiProvider).isNotEmpty ||
        ref.watch(filteredPengeluaranLainnyaProvider).isNotEmpty;

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
                  'Ringkasan ${_getMonthYearText(selectedDate)}',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Iconsax.calendar, color: Colors.orange, size: 30),
                  onPressed: () => _selectMonth(context, ref),
                  tooltip: 'Pilih Bulan dan Tahun',
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (!hasPenerimaanData && !hasPengeluaranData)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'Tidak ada transaksi pada periode ini',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              )
            else
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
                      isEmpty: !hasPenerimaanData,
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
                      isEmpty: !hasPengeluaranData,
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
    BuildContext context,
    WidgetRef ref, {
    required double income,
  }) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final filterType = ref.watch(selectedFilterTypeProvider);
    final profit = ref.watch(totalProfitProvider);
    final isProfit = profit >= 0;

    final hasData =
        ref.watch(filteredPenerimaanProvider).isNotEmpty ||
        ref.watch(filteredPengeluaranProvider).isNotEmpty ||
        ref.watch(filteredPengeluaranGajiProvider).isNotEmpty ||
        ref.watch(filteredPengeluaranLainnyaProvider).isNotEmpty;

    final cardColor = isProfit
        ? Colors.green.withOpacity(isDarkMode ? 0.2 : 0.1)
        : Colors.red.withOpacity(isDarkMode ? 0.2 : 0.1);
    final textColor = isProfit
        ? (isDarkMode ? Colors.green.shade300 : Colors.green.shade700)
        : (isDarkMode ? Colors.red.shade300 : Colors.red.shade700);
    final icon = isProfit ? Iconsax.chart_success : Iconsax.chart_fail;
    final formattedProfit = hasData ? _formatCurrency(profit.abs()) : 'Rp 0';

    final percentage = hasData && income > 0
        ? (profit.abs() / income * 100)
        : 0.0;

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
                  ChoiceChip(
                    label: Text(
                      'Bulan',
                      style: TextStyle(
                        color: filterType == 'month' ? Colors.white : null,
                      ),
                    ),
                    selected: filterType == 'month',
                    onSelected: (_) =>
                        ref.read(selectedFilterTypeProvider.notifier).state =
                            'month',
                    selectedColor: Colors.orange,
                    checkmarkColor: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: Text(
                      'Tahun',
                      style: TextStyle(
                        color: filterType == 'year' ? Colors.white : null,
                      ),
                    ),
                    selected: filterType == 'year',
                    onSelected: (_) =>
                        ref.read(selectedFilterTypeProvider.notifier).state =
                            'year',
                    selectedColor: Colors.orange,
                    checkmarkColor: Colors.white,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      Iconsax.calendar,
                      color: Colors.orange,
                      size: 30,
                    ),
                    onPressed: () => filterType == 'month'
                        ? _selectMonth(context, ref)
                        : _selectYear(context, ref),
                    tooltip:
                        'Pilih ${filterType == 'month' ? 'Bulan' : 'Tahun'}',
                  ),
                ],
              ),
              const SizedBox(height: 16),
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
                    child: Icon(
                      icon,
                      color: hasData ? textColor : textColor.withOpacity(0.5),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Laba/Rugi ${filterType == 'year' ? 'Tahun' : 'Bulan'} Ini',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                formattedProfit,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: hasData ? textColor : textColor.withOpacity(0.5),
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 8),
              if (!hasData)
                Text(
                  'Tidak ada transaksi pada periode ini',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                )
              else if (income > 0)
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
                        isProfit ? Iconsax.arrow_up_2 : Iconsax.arrow_down_1,
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
                )
              else
                Text(
                  '0%',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: textColor.withOpacity(0.5),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPenerimaanList(
    AsyncValue<List<PenerimaanModel>> asyncPenerimaan,
    WidgetRef ref,
    BuildContext context,
  ) {
    return asyncPenerimaan.when(
      loading: () =>
          const Center(child: CircularProgressIndicator(color: Colors.orange)),
      error: (err, _) => Center(child: Text('Error: $err')),
      data: (penerimaanList) {
        if (penerimaanList.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text('Belum ada data penerimaan.'),
            ),
          );
        }
        return _buildPenerimaanTransactions(penerimaanList, ref, context);
      },
    );
  }

  Widget _buildPenerimaanTransactions(
    List<PenerimaanModel> pengeluaranList,
    WidgetRef ref,
    BuildContext context,
  ) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final textTheme = theme.textTheme;
    final cardColor = isDarkMode ? Color(0xFF222831) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.grey[800];
    final secondaryTextColor = isDarkMode ? Colors.grey[400] : Colors.grey[600];

    (DateTime, String) parseTransactionDate(PenerimaanModel transaction) {
      try {
        final dateTime = DateTime.parse(transaction.tanggal);
        final formattedDate = DateFormat(
          'dd MMM yyyy',
          'id_ID',
        ).format(dateTime);
        return (dateTime, formattedDate);
      } catch (e) {
        try {
          final dateTime = DateFormat('d/M/yyyy').parse(transaction.tanggal);
          final formattedDate = DateFormat(
            'dd MMM yyyy',
            'id_ID',
          ).format(dateTime);
          return (dateTime, formattedDate);
        } catch (e) {
          final now = DateTime.now();
          final formattedDate = DateFormat('dd MMM yyyy', 'id_ID').format(now);
          return (now, formattedDate);
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                'Penerimaan Dari Pelanggan',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: textColor,
                ),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                GestureDetector(
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DetailPenerimaan(),
                      ),
                    ),
                  },
                  child: Text(
                    'Lihat Semua',
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.orange,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                const Icon(
                  Iconsax.arrow_right_25,
                  size: 20,
                  color: Colors.orange,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...pengeluaranList.take(7).map((transaction) {
          final formattedAmount = _formatCurrency(transaction.total);
          final (_, formattedDate) = parseTransactionDate(transaction);

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: isDarkMode
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(
                                isDarkMode ? 0.3 : 0.1,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Iconsax.arrow_down_1,
                              color: Colors.green,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                capitalizeEachWord(transaction.transaksi),
                                style: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                formattedDate,
                                style: textTheme.bodySmall?.copyWith(
                                  color: secondaryTextColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      PopupMenuButton(
                        icon: Icon(Icons.more_vert, color: secondaryTextColor),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: Row(
                              children: [
                                Icon(Icons.book, size: 20, color: textColor),
                                const SizedBox(width: 8),
                                Text(
                                  'Details',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () =>
                                _showPenerimaanDetail(context, transaction),
                          ),
                          PopupMenuItem(
                            child: Row(
                              children: [
                                Icon(Icons.edit, size: 20, color: textColor),
                                const SizedBox(width: 8),
                                Text(
                                  'Edit',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditPenerimaanScreen(
                                    penerimaanId: transaction.id,
                                  ),
                                ),
                              ),
                            },
                          ),
                          PopupMenuItem(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.delete,
                                  size: 20,
                                  color: Colors.red[400],
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Delete',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: Colors.red[400],
                                  ),
                                ),
                              ],
                            ),
                            onTap: () => _showDeleteConfirmationDialog(
                              context,
                              transaction.id,
                              1,
                              ref,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pelanggan',
                            style: textTheme.bodySmall?.copyWith(
                              color: secondaryTextColor,
                            ),
                          ),
                          Text(
                            capitalizeEachWord(transaction.pelanggan),
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Total',
                            style: textTheme.bodySmall?.copyWith(
                              color: secondaryTextColor,
                            ),
                          ),
                          Text(
                            '+$formattedAmount',
                            style: textTheme.bodyLarge?.copyWith(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildPengeluaranList(
    AsyncValue<List<Pengeluaran>> asyncPengeluaran,
    WidgetRef ref,
    BuildContext context,
  ) {
    return asyncPengeluaran.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
      data: (pengeluaranList) {
        if (pengeluaranList.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text('Belum ada data pengeluaran.'),
            ),
          );
        }
        return _buildPengeluaranTransactions(pengeluaranList, ref, context);
      },
    );
  }

  Widget _buildPengeluaranTransactions(
    List<Pengeluaran> pengeluaranList,
    WidgetRef ref,
    BuildContext context,
  ) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final textTheme = theme.textTheme;
    final cardColor = isDarkMode ? Color(0xFF222831) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.grey[800];
    final secondaryTextColor = isDarkMode ? Colors.grey[400] : Colors.grey[600];

    (DateTime, String) parseTransactionDate(Pengeluaran transaction) {
      try {
        final dateTime = DateTime.parse(transaction.tanggal);
        final formattedDate = DateFormat(
          'dd MMM yyyy',
          'id_ID',
        ).format(dateTime);
        return (dateTime, formattedDate);
      } catch (e) {
        try {
          final dateTime = DateFormat('d/M/yyyy').parse(transaction.tanggal);
          final formattedDate = DateFormat(
            'dd MMM yyyy',
            'id_ID',
          ).format(dateTime);
          return (dateTime, formattedDate);
        } catch (e) {
          final now = DateTime.now();
          final formattedDate = DateFormat('dd MMM yyyy', 'id_ID').format(now);
          return (now, formattedDate);
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                'Pembelian Bahan Baku',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: textColor,
                ),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                GestureDetector(
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DetailPengeluaran(),
                      ),
                    ),
                  },
                  child: Text(
                    'Lihat Semua',
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.orange,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                const Icon(
                  Iconsax.arrow_right_25,
                  size: 20,
                  color: Colors.orange,
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 12),
        ...pengeluaranList.take(7).map((transaction) {
          final formattedAmount = _formatCurrency(transaction.total);
          final (_, formattedDate) = parseTransactionDate(transaction);

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: isDarkMode
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(
                                isDarkMode ? 0.3 : 0.1,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Iconsax.arrow_up_2,
                              color: Colors.red,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                capitalizeEachWord(transaction.transaksi),
                                style: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                formattedDate,
                                style: textTheme.bodySmall?.copyWith(
                                  color: secondaryTextColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      PopupMenuButton(
                        icon: Icon(Icons.more_vert, color: secondaryTextColor),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: Row(
                              children: [
                                Icon(Icons.book, size: 20, color: textColor),
                                const SizedBox(width: 8),
                                Text(
                                  'Details',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () =>
                                _showPengeluaranDetail(context, transaction),
                          ),
                          PopupMenuItem(
                            child: Row(
                              children: [
                                Icon(Icons.edit, size: 20, color: textColor),
                                const SizedBox(width: 8),
                                Text(
                                  'Edit',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditPengeluaranScreen(
                                    pengeluaranId: transaction.id,
                                  ),
                                ),
                              ),
                            },
                          ),
                          PopupMenuItem(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.delete,
                                  size: 20,
                                  color: Colors.red[400],
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Delete',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: Colors.red[400],
                                  ),
                                ),
                              ],
                            ),
                            onTap: () => _showDeleteConfirmationDialog(
                              context,
                              transaction.id,
                              2,
                              ref,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Supplier',
                            style: textTheme.bodySmall?.copyWith(
                              color: secondaryTextColor,
                            ),
                          ),
                          Text(
                            capitalizeEachWord(transaction.supplierName),
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Total',
                            style: textTheme.bodySmall?.copyWith(
                              color: secondaryTextColor,
                            ),
                          ),
                          Text(
                            '-$formattedAmount',
                            style: textTheme.bodyLarge?.copyWith(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  void _showPenerimaanDetail(
    BuildContext context,
    PenerimaanModel transaction,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  'Detail Penerimaan',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildDetailRow('Tanggal', transaction.tanggal),
                _buildDetailRow('Transaksi', transaction.transaksi),
                _buildDetailRow('Pelanggan', transaction.pelanggan),
                _buildDetailRow(
                  'Kuantitas',
                  '${transaction.kuantitas} ${transaction.satuan}',
                ),
                _buildDetailRow(
                  'Harga Satuan',
                  _formatCurrency(transaction.hargaSatuan),
                ),
                _buildDetailRow('Total', _formatCurrency(transaction.total)),
                _buildDetailRow('Keterangan', transaction.keterangan),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Iconsax.close_circle, color: Colors.white),
                    label: const Text(
                      'Tutup',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showPengeluaranDetail(BuildContext context, Pengeluaran transaction) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  'Detail Pengeluaran',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildDetailRow('Tanggal', transaction.tanggal),
                _buildDetailRow('Transaksi', transaction.transaksi),
                _buildDetailRow('Supplier', transaction.supplierName),
                _buildDetailRow(
                  'Kuantitas',
                  '${transaction.kuantitas} ${transaction.satuan}',
                ),
                _buildDetailRow(
                  'Harga Satuan',
                  _formatCurrency(transaction.hargaSatuan),
                ),
                _buildDetailRow('Total', _formatCurrency(transaction.total)),
                _buildDetailRow('Keterangan', transaction.keterangan),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Iconsax.close_circle, color: Colors.white),
                    label: const Text(
                      'Tutup',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
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
            onPressed: () => _navigateToPenerimaan(context),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildSimpleActionButton(
            context,
            icon: Iconsax.add,
            label: 'Tambah Pengeluaran',
            color: Colors.red,
            onPressed: () => _showExpenseTypeDialog(context),
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
    required VoidCallback onPressed,
  }) {
    final theme = Theme.of(context);
    return ElevatedButton(
      onPressed: onPressed,
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

  void _navigateToPenerimaan(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddPenerimaanScreen()),
    );
  }

  void _showExpenseTypeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Pilih Jenis Pengeluaran',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildExpenseOptionCard(
                  context,
                  icon: Icons.shopping_basket,
                  title: 'Pengeluaran Pembelian Bahan Baku',
                  subtitle:
                      'Catat pengeluaran untuk pembelian bahan baku toko.',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddPengeluaranScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _buildExpenseOptionCard(
                  context,
                  icon: Icons.people,
                  title: 'Pengeluaran Gaji Karyawan',
                  subtitle: 'Catat pengeluaran untuk gaji karyawan',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddPengeluaranGajiScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _buildExpenseOptionCard(
                  context,
                  icon: Icons.receipt_long,
                  title: 'Pengeluaran Lainnya',
                  subtitle:
                      'Catat pengeluaran lainnya yang tidak termasuk kategori di atas',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddPengeluaranLainnyaScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildExpenseOptionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).dividerColor, width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialItem(
    BuildContext context, {
    required String title,
    required double amount,
    required IconData icon,
    required Color color,
    bool isEmpty = false,
  }) {
    final theme = Theme.of(context);
    final formattedAmount = isEmpty ? 'Rp 0' : _formatCurrency(amount);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color.withOpacity(isEmpty ? 0.5 : 1.0), size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: isEmpty
                    ? theme.colorScheme.onSurface.withOpacity(0.5)
                    : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          formattedAmount,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: isEmpty
                ? theme.colorScheme.onSurface.withOpacity(0.5)
                : null,
          ),
        ),
      ],
    );
  }

  void _showPengeluaranGajiDetail(
    BuildContext context,
    PengeluaranGajiKaryawan transaction,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  'Detail Pengeluaran Gaji',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildDetailRow('Tanggal', transaction.tanggalPengeluaranGaji),
                _buildDetailRow('Nama Karyawan', transaction.namaKaryawan),
                _buildDetailRow('Jenis Honor', transaction.jenisPekerjaan!),
                _buildDetailRow(
                  'Jumlah Hari / Barang (pcs)',
                  transaction.jumlahHariOrBarang.toString(),
                ),
                _buildDetailRow(
                  'Jumlah Gaji',
                  _formatCurrency(transaction.jumlahGaji),
                ),
                _buildDetailRow('Total', _formatCurrency(transaction.total)),
                if (transaction.tipeSatuan != null)
                  _buildDetailRow('Tipe Satuan', transaction.tipeSatuan!),
                _buildDetailRow('Keterangan', transaction.keterangan),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Iconsax.close_circle, color: Colors.white),
                    label: const Text(
                      'Tutup',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPengeluaranGajiList(
    AsyncValue<List<PengeluaranGajiKaryawan>> asyncPengeluaranGaji,
    WidgetRef ref,
    BuildContext context,
  ) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final textTheme = theme.textTheme;
    final cardColor = isDarkMode ? Color(0xFF222831) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.grey[800];
    final secondaryTextColor = isDarkMode ? Colors.grey[400] : Colors.grey[600];

    (DateTime, String) parseTransactionDate(
      PengeluaranGajiKaryawan transaction,
    ) {
      try {
        final dateTime = DateTime.parse(transaction.tanggalPengeluaranGaji);
        final formattedDate = DateFormat(
          'dd MMM yyyy',
          'id_ID',
        ).format(dateTime);
        return (dateTime, formattedDate);
      } catch (e) {
        try {
          final dateTime = DateFormat(
            'd/M/yyyy',
          ).parse(transaction.tanggalPengeluaranGaji);
          final formattedDate = DateFormat(
            'dd MMM yyyy',
            'id_ID',
          ).format(dateTime);
          return (dateTime, formattedDate);
        } catch (e) {
          final now = DateTime.now();
          final formattedDate = DateFormat('dd MMM yyyy', 'id_ID').format(now);
          return (now, formattedDate);
        }
      }
    }

    return asyncPengeluaranGaji.when(
      loading: () =>
          const Center(child: CircularProgressIndicator(color: Colors.orange)),
      error: (err, _) => Center(child: Text('Error: $err')),
      data: (pengeluaranGajiList) {
        if (pengeluaranGajiList.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text('Belum ada data pengeluaran gaji.'),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    'Pengeluaran Upah',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: textColor,
                    ),
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DetailPengeluaranGaji(),
                          ),
                        ),
                      },
                      child: Text(
                        'Lihat Semua',
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    const Icon(
                      Iconsax.arrow_right_25,
                      size: 20,
                      color: Colors.orange,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...pengeluaranGajiList.take(7).map((transaction) {
              final formattedAmount = _formatCurrency(transaction.total);
              final (_, formattedDate) = parseTransactionDate(transaction);

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: isDarkMode
                      ? null
                      : [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(
                                    isDarkMode ? 0.3 : 0.1,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Iconsax.profile_2user,
                                  color: Colors.orange,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    capitalizeEachWord(
                                      transaction.namaKaryawan,
                                    ),
                                    style: textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: textColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    formattedDate,
                                    style: textTheme.bodySmall?.copyWith(
                                      color: secondaryTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          PopupMenuButton(
                            icon: Icon(
                              Icons.more_vert,
                              color: secondaryTextColor,
                            ),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.book,
                                      size: 20,
                                      color: textColor,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Details',
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: textColor,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () => _showPengeluaranGajiDetail(
                                  context,
                                  transaction,
                                ),
                              ),
                              PopupMenuItem(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.edit,
                                      size: 20,
                                      color: textColor,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Edit',
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: textColor,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditPengeluaranGaji(
                                        pengeluaranGajiId: transaction.id,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              PopupMenuItem(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete,
                                      size: 20,
                                      color: Colors.red[400],
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Delete',
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: Colors.red[400],
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () => _showDeleteConfirmationDialog(
                                  context,
                                  transaction.id,
                                  3,
                                  ref,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Jenis Honor',
                                style: textTheme.bodySmall?.copyWith(
                                  color: secondaryTextColor,
                                ),
                              ),
                              Text(
                                capitalizeEachWord(transaction.jenisPekerjaan!),
                                style: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Total Gaji',
                                style: textTheme.bodySmall?.copyWith(
                                  color: secondaryTextColor,
                                ),
                              ),
                              Text(
                                '-$formattedAmount',
                                style: textTheme.bodyLarge?.copyWith(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (transaction.keterangan.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Keterangan',
                              style: textTheme.bodySmall?.copyWith(
                                color: secondaryTextColor,
                              ),
                            ),
                            Text(
                              capitalizeEachWord(transaction.keterangan),
                              style: textTheme.bodyMedium?.copyWith(
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        );
      },
    );
  }

  String _formatCurrency(num amount) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(amount);
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd MMM yyyy', 'id_ID').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  Widget _buildPengeluaranLainnyaList(
    AsyncValue<List<PengeluaranLainnya>> asyncPengeluaranLainnya,
    WidgetRef ref,
    BuildContext context,
  ) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final textTheme = theme.textTheme;
    final cardColor = isDarkMode ? Color(0xFF222831) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.grey[800];
    final secondaryTextColor = isDarkMode ? Colors.grey[400] : Colors.grey[600];

    return asyncPengeluaranLainnya.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
      data: (pengeluaranList) {
        if (pengeluaranList.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text('Belum ada data pengeluaran lainnya.'),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    'Pengeluaran Lainnya',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: textColor,
                    ),
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailPengeluaranLainnya(
                              pengeluaranList: pengeluaranList,
                            ),
                          ),
                        ),
                      },
                      child: Text(
                        'Lihat Semua',
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(
                      Iconsax.arrow_right_25,
                      size: 20,
                      color: Colors.orange,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...pengeluaranList.take(7).map((pengeluaran) {
              final formattedAmount = _formatCurrency(pengeluaran.nominal);
              final formattedDate = _formatDate(pengeluaran.tanggal);

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: isDarkMode
                      ? null
                      : [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.purple.withOpacity(
                                    isDarkMode ? 0.3 : 0.1,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Iconsax.receipt,
                                  color: Colors.purple,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    pengeluaran.uraian,
                                    style: textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: textColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    formattedDate,
                                    style: textTheme.bodySmall?.copyWith(
                                      color: secondaryTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          PopupMenuButton(
                            icon: Icon(
                              Icons.more_vert,
                              color: secondaryTextColor,
                            ),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.book,
                                      size: 20,
                                      color: textColor,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Detail',
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: textColor,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () => _showPengeluaranLainnyaDetail(
                                  context,
                                  pengeluaran,
                                ),
                              ),
                              PopupMenuItem(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.edit,
                                      size: 20,
                                      color: textColor,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Edit',
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: textColor,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditPengeluaranLainnya(
                                            pengeluaranLainnyaId:
                                                pengeluaran.id,
                                          ),
                                    ),
                                  );
                                },
                              ),
                              PopupMenuItem(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete,
                                      size: 20,
                                      color: Colors.red[400],
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Hapus',
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: Colors.red[400],
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () => _showDeleteDialog(
                                  context,
                                  ref,
                                  pengeluaran.id,
                                ),
                              ),
                            ],
                            color: Theme.of(context).cardColor,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Keterangan',
                                style: textTheme.bodySmall?.copyWith(
                                  color: secondaryTextColor,
                                ),
                              ),
                              Text(
                                pengeluaran.keterangan.isNotEmpty
                                    ? pengeluaran.keterangan
                                    : '-',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Total',
                                style: textTheme.bodySmall?.copyWith(
                                  color: secondaryTextColor,
                                ),
                              ),
                              Text(
                                '-$formattedAmount',
                                style: textTheme.bodyLarge?.copyWith(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        );
      },
    );
  }

  void _showPengeluaranLainnyaDetail(
    BuildContext context,
    PengeluaranLainnya pengeluaran,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Theme.of(context).cardColor,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  'Detail Pengeluaran Lainnya',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildDetailLainnyaRow(
                  context, // Tambahkan context di sini
                  'Tanggal',
                  _formatDate(pengeluaran.tanggal),
                ),
                _buildDetailLainnyaRow(
                  context, // Tambahkan context di sini
                  'Uraian',
                  pengeluaran.uraian,
                ),
                _buildDetailLainnyaRow(
                  context, // Tambahkan context di sini
                  'Nominal',
                  _formatCurrency(pengeluaran.nominal),
                ),
                _buildDetailLainnyaRow(
                  context, // Tambahkan context di sini
                  'Keterangan',
                  pengeluaran.keterangan.isNotEmpty
                      ? pengeluaran.keterangan
                      : '-',
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Iconsax.close_circle, color: Colors.white),
                    label: const Text(
                      'Tutup',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailLainnyaRow(
    BuildContext context,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: Text(
          'Hapus Pengeluaran',
          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus data ini?',
          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(pengeluaranLainnyaRepositoryProvider)
                  .deletePengeluaranLainnya(id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data pengeluaran berhasil dihapus'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

String capitalizeEachWord(String text) {
  return text
      .split(' ')
      .map((word) {
        if (word.isEmpty) return word;
        return word[0].toUpperCase() + word.substring(1);
      })
      .join(' ');
}

void _showChangePinDialog(BuildContext context, WidgetRef ref) {
  String currentPin = '';
  String newPin = '';
  String confirmPin = '';

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Ubah PIN'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              obscureText: true,
              decoration: const InputDecoration(labelText: 'PIN Saat Ini'),
              onChanged: (value) => currentPin = value,
            ),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'PIN Baru (6 digit)',
              ),
              onChanged: (value) => newPin = value,
            ),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Konfirmasi PIN Baru',
              ),
              onChanged: (value) => confirmPin = value,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              if (currentPin != ref.read(pinProvider).pin) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('PIN saat ini salah')),
                );
                return;
              }

              if (newPin.length != 6) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('PIN harus 6 digit')),
                );
                return;
              }

              if (newPin != confirmPin) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Konfirmasi PIN tidak cocok')),
                );
                return;
              }

              ref.read(pinProvider.notifier).updatePin(newPin);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('PIN berhasil diubah')),
              );
            },
            child: const Text('Simpan'),
          ),
        ],
      );
    },
  );
}

void _showResetPinConfirmation(BuildContext context, WidgetRef ref) {
  final currentPinState = ref.read(pinProvider);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Atur Ulang PIN'),
        content: const Text(
          'Apakah Anda yakin ingin mengatur ulang PIN ke default (123456)?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(pinProvider.notifier)
                  .resetPin(keepEnabledStatus: currentPinState.isPinEnabled);

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('PIN telah direset ke default'),
                  action: SnackBarAction(label: 'OK', onPressed: () {}),
                ),
              );
            },
            child: const Text('Reset'),
          ),
        ],
      );
    },
  );
}
