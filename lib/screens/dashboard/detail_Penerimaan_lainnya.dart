import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handycraft_app/core/models/penerimaan_model.dart';
import 'package:handycraft_app/core/providers/penerimaan_provider.dart';
import 'package:handycraft_app/screens/dashboard/edit_penerimaan_lainnya.dart';
import 'package:intl/intl.dart';
import 'package:iconsax/iconsax.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class DetailPenerimaanLainnya extends ConsumerStatefulWidget {
  final List<PenerimaanLainnya> penerimaanList;

  const DetailPenerimaanLainnya({super.key, required this.penerimaanList});

  @override
  ConsumerState<DetailPenerimaanLainnya> createState() =>
      _DetailPenerimaanLainnyaState();
}

class _DetailPenerimaanLainnyaState
    extends ConsumerState<DetailPenerimaanLainnya> {
  String _selectedFilter = 'hari';
  String _sortOrder = 'terbesar';
  DateTime? _selectedMonth;
  DateTime? _selectedYear;

  @override
  Widget build(BuildContext context) {
    final filteredPengeluaran = _applyFilters(widget.penerimaanList);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Detail Penerimaan Lainnya'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildFilterButton('hari', 'Hari Ini'),
                    _buildFilterButton('minggu', 'Minggu Ini'),
                    _buildFilterButton('bulan', 'Bulan Ini'),
                    _buildFilterButton('tahun', 'Tahun Ini'),
                  ],
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _sortOrder,
                  items: const [
                    DropdownMenuItem(
                      value: 'terbesar',
                      child: Text('Nominal Tertinggi'),
                    ),
                    DropdownMenuItem(
                      value: 'terkecil',
                      child: Text('Nominal Terendah'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _sortOrder = value!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Urutkan',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredPengeluaran.isEmpty
                ? const Center(child: Text('Tidak ada data pengeluaran'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredPengeluaran.length,
                    itemBuilder: (context, index) {
                      return _buildPengeluaranCard(filteredPengeluaran[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  List<PenerimaanLainnya> _applyFilters(
    List<PenerimaanLainnya> allPengeluaran,
  ) {
    final now = DateTime.now();
    List<PenerimaanLainnya> filtered = allPengeluaran;
    filtered = filtered.where((p) {
      final date = DateTime.parse(p.tanggal);
      switch (_selectedFilter) {
        case 'hari':
          return date.year == now.year &&
              date.month == now.month &&
              date.day == now.day;
        case 'minggu':
          final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
          final endOfWeek = startOfWeek.add(const Duration(days: 6));
          return date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
              date.isBefore(endOfWeek.add(const Duration(days: 1)));
        case 'bulan':
          if (_selectedMonth != null) {
            return date.year == _selectedMonth!.year &&
                date.month == _selectedMonth!.month;
          }
          return date.year == now.year && date.month == now.month;
        case 'tahun':
          if (_selectedYear != null) {
            return date.year == _selectedYear!.year;
          }
          return date.year == now.year;
        default:
          return true;
      }
    }).toList();

    // Sort berdasarkan nominal
    filtered.sort((a, b) {
      return _sortOrder == 'terbesar'
          ? b.nominal.compareTo(a.nominal)
          : a.nominal.compareTo(b.nominal);
    });

    return filtered;
  }

  Future<void> _selectMonth(BuildContext context) async {
    final DateTime? picked = await showMonthPicker(
      context: context,
      initialDate: _selectedMonth ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedMonth = DateTime(picked.year, picked.month);
        _selectedFilter = 'bulan';
      });
    }
  }

  Future<void> _selectYear(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      builder: (context) {
        return SizedBox(
          height: 300,
          child: YearPicker(
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            initialDate: _selectedYear ?? DateTime.now(),
            selectedDate: _selectedYear ?? DateTime.now(),
            onChanged: (DateTime dateTime) {
              setState(() {
                _selectedYear = DateTime(dateTime.year);
                _selectedFilter = 'tahun';
              });
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  Widget _buildFilterButton(String filterType, String label) {
    final isSelected = _selectedFilter == filterType;
    final isMonthYear = filterType == 'bulan' || filterType == 'tahun';
    final orangeColor = Colors.orange;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (filterType == 'bulan') {
            _selectMonth(context);
          } else if (filterType == 'tahun') {
            _selectYear(context);
          } else {
            setState(() {
              _selectedFilter = filterType;
              _selectedMonth = null;
              _selectedYear = null;
            });
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected ? orangeColor : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: orangeColor, width: 1),
          ),
          child: Column(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : orangeColor,
                ),
              ),
              if (isMonthYear && isSelected)
                Text(
                  filterType == 'bulan'
                      ? _selectedMonth != null
                            ? DateFormat('MMM yyyy').format(_selectedMonth!)
                            : DateFormat('MMM yyyy').format(DateTime.now())
                      : _selectedYear != null
                      ? _selectedYear!.year.toString()
                      : DateTime.now().year.toString(),
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
            ],
          ),
        ),
      ),
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

  Widget _buildPengeluaranCard(PenerimaanLainnya pengeluaran) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final textTheme = theme.textTheme;
    final cardColor = isDarkMode ? const Color(0xFF222831) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.grey[800];
    final secondaryTextColor = isDarkMode ? Colors.grey[400] : Colors.grey[600];
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
                        color: Colors.blueAccent.withOpacity(
                          isDarkMode ? 0.3 : 0.1,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Iconsax.dollar_circle,
                        color: Colors.blueAccent,
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
                  icon: Icon(Icons.more_vert, color: secondaryTextColor),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(Icons.book, size: 20, color: textColor),
                          const SizedBox(width: 8),
                          Text(
                            'Detail',
                            style: textTheme.bodyMedium?.copyWith(
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                      onTap: () => _showPengeluaranDetail(pengeluaran),
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
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditPenerimaanLainnya(
                              penerimaanLainnyaId: pengeluaran.id,
                            ),
                          ),
                        );
                      },
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 20, color: Colors.red[400]),
                          const SizedBox(width: 8),
                          Text(
                            'Hapus',
                            style: textTheme.bodyMedium?.copyWith(
                              color: Colors.red[400],
                            ),
                          ),
                        ],
                      ),
                      onTap: () => _showDeleteDialog(pengeluaran.id),
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
                      style: textTheme.bodyMedium?.copyWith(color: textColor),
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
  }

  void _showPengeluaranDetail(PenerimaanLainnya pengeluaran) {
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
                _buildDetailRow('Tanggal', _formatDate(pengeluaran.tanggal)),
                _buildDetailRow('Uraian', pengeluaran.uraian),
                _buildDetailRow(
                  'Nominal',
                  _formatCurrency(pengeluaran.nominal),
                ),
                _buildDetailRow(
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

  Widget _buildDetailRow(String label, String value) {
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

  void _showDeleteDialog(String id) {
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
                  .read(penerimaanLainnyaRepositoryProvider)
                  .deletePenerimaanLainnya(id);
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
