import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handycraft_app/core/providers/penerimaan_provider.dart';
import 'package:handycraft_app/screens/dashboard/edit_penerimaan_screen.dart';
import 'package:intl/intl.dart';
import 'package:iconsax/iconsax.dart';
import 'package:handycraft_app/core/models/penerimaan_model.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class DetailPenerimaan extends ConsumerStatefulWidget {
  const DetailPenerimaan({super.key});

  @override
  ConsumerState<DetailPenerimaan> createState() => _DetailPenerimaanState();
}

class _DetailPenerimaanState extends ConsumerState<DetailPenerimaan> {
  String _selectedFilter = 'hari';
  String _sortOrder = 'terbesar';
  DateTime? _selectedMonth;
  DateTime? _selectedYear;

  @override
  Widget build(BuildContext context) {
    final penerimaanAsync = ref.watch(penerimaanStreamProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Detail Penerimaan'),
        centerTitle: true,
      ),
      body: penerimaanAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (allPenerimaan) {
          final filteredPenerimaan = _applyFilters(allPenerimaan);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _buildFilterButton('hari', 'Hari Ini', allPenerimaan),
                        _buildFilterButton(
                          'minggu',
                          'Minggu Ini',
                          allPenerimaan,
                        ),
                        _buildFilterButton('bulan', 'Bulan', allPenerimaan),
                        _buildFilterButton('tahun', 'Tahun', allPenerimaan),
                      ],
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _sortOrder,
                      items: const [
                        DropdownMenuItem(
                          value: 'terbesar',
                          child: Text('Total Tertinggi'),
                        ),
                        DropdownMenuItem(
                          value: 'terkecil',
                          child: Text('Total Terendah'),
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
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: filteredPenerimaan.isEmpty
                    ? const Center(child: Text('Tidak ada data penerimaan'))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredPenerimaan.length,
                        itemBuilder: (context, index) {
                          return _buildPenerimaanCard(
                            filteredPenerimaan[index],
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<PenerimaanModel> _applyFilters(List<PenerimaanModel> allPenerimaan) {
    final now = DateTime.now();
    List<PenerimaanModel> filtered = allPenerimaan;

    // Filter berdasarkan periode
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

    // Sort berdasarkan total
    filtered.sort((a, b) {
      return _sortOrder == 'terbesar'
          ? b.total.compareTo(a.total)
          : a.total.compareTo(b.total);
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

  Widget _buildFilterButton(
    String filterType,
    String label,
    List<PenerimaanModel> allPenerimaan,
  ) {
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
                  style: TextStyle(fontSize: 12, color: Colors.white),
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

  Widget _buildPenerimaanCard(PenerimaanModel penerimaan) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final cardColor = isDarkMode ? const Color(0xFF222831) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.grey[800];
    final secondaryTextColor = isDarkMode ? Colors.grey[400] : Colors.grey[600];

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
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showDetail(penerimaan),
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
                          Iconsax.arrow_down,
                          color: Colors.green,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            penerimaan.transaksi,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatDate(penerimaan.tanggal),
                            style: theme.textTheme.bodySmall?.copyWith(
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
                        child: const Text('Detail'),
                        onTap: () => _showDetail(penerimaan),
                      ),
                      PopupMenuItem(
                        child: const Text('Edit'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditPenerimaanScreen(
                                penerimaanId: penerimaan.id,
                              ),
                            ),
                          );
                        },
                      ),
                      PopupMenuItem(
                        child: const Text(
                          'Hapus',
                          style: TextStyle(color: Colors.red),
                        ),
                        onTap: () => _showDeleteDialog(penerimaan.id),
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
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: secondaryTextColor,
                        ),
                      ),
                      Text(
                        penerimaan.pelanggan,
                        style: theme.textTheme.bodyMedium?.copyWith(
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
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: secondaryTextColor,
                        ),
                      ),
                      Text(
                        _formatCurrency(penerimaan.total),
                        style: theme.textTheme.bodyLarge?.copyWith(
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
      ),
    );
  }

  void _showDetail(PenerimaanModel penerimaan) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                'Detail Penerimaan',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildDetailRow('Tanggal', _formatDate(penerimaan.tanggal)),
              _buildDetailRow('Transaksi', penerimaan.transaksi),
              _buildDetailRow('Pelanggan', penerimaan.pelanggan),
              _buildDetailRow(
                'Kuantitas',
                '${penerimaan.kuantitas} ${penerimaan.satuan}',
              ),
              _buildDetailRow(
                'Harga Satuan',
                _formatCurrency(penerimaan.hargaSatuan),
              ),
              _buildDetailRow('Total', _formatCurrency(penerimaan.total)),
              _buildDetailRow('Keterangan', penerimaan.keterangan),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Tutup'),
              ),
            ],
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
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _showDeleteDialog(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Penerimaan'),
        content: const Text('Apakah Anda yakin ingin menghapus data ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              ref.read(penerimaanRepositoryProvider).deletePenerimaan(id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data penerimaan berhasil dihapus'),
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
