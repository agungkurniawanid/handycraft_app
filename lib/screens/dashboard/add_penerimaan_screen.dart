import 'package:flutter/material.dart';
import 'package:handycraft_app/core/extensions/penerimaan_extension.dart';
import 'package:handycraft_app/core/models/penerimaan_model.dart';
import 'package:handycraft_app/core/models/product_model.dart';
import 'package:handycraft_app/core/providers/pelanggan_provider.dart';
import 'package:handycraft_app/core/providers/penerimaan_provider.dart';
import 'package:handycraft_app/core/providers/product_provider.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AddPenerimaanScreen extends ConsumerStatefulWidget {
  const AddPenerimaanScreen({super.key});

  @override
  ConsumerState<AddPenerimaanScreen> createState() =>
      _AddPenerimaanScreenState();
}

class _AddPenerimaanScreenState extends ConsumerState<AddPenerimaanScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _kuantitasController = TextEditingController();
  final TextEditingController _hargaSatuanController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();
  final TextEditingController _keteranganController = TextEditingController();
  final TextEditingController _satuanController = TextEditingController();

  String? _selectedPelanggan;
  String? _selectedNamaTransaksiBahanBaku;
  DateTime? _selectedDate;

  void initState() {
    super.initState();
    _kuantitasController.addListener(_updateTotal);
    _hargaSatuanController.addListener(_updateTotal);
    _selectedDate = DateTime.now();
  }

  void _updateTotal() {
    final kuantitas = num.tryParse(_kuantitasController.text.trim()) ?? 0;
    final hargaSatuan = num.tryParse(_hargaSatuanController.text.trim()) ?? 0;
    final total = kuantitas * hargaSatuan;
    _totalController.text = total.toStringAsFixed(0);
  }

  @override
  void dispose() {
    _kuantitasController.dispose();
    _hargaSatuanController.dispose();
    _totalController.dispose();
    _keteranganController.dispose();
    _satuanController.dispose();
    super.dispose();
  }

  bool isLoading = false;

  Future<void> _savePenerimaan() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);
    try {
      final repository = ref.read(penerimaanRepositoryProvider);
      final newPengeluaran = PenerimaanModel(
        id: '',
        tanggal: DateFormat('yyyy-MM-dd').format(_selectedDate!),
        transaksi: _selectedNamaTransaksiBahanBaku ?? '',
        pelanggan: _selectedPelanggan ?? '',
        kuantitas: num.tryParse(_kuantitasController.text.trim()) ?? 0,
        satuan: _satuanController.text.trim(),
        hargaSatuan: num.tryParse(_hargaSatuanController.text.trim()) ?? 0,
        total: num.tryParse(_totalController.text.trim()) ?? 0,
        keterangan: _keteranganController.text.trim(),
      );
      await repository.addPenerimaan(newPengeluaran);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Penerimaan berhasil disimpan'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _handleProductChange(Product? selectedProduct) {
    if (selectedProduct != null) {
      setState(() {
        _selectedNamaTransaksiBahanBaku = selectedProduct.name;
        _hargaSatuanController.text = selectedProduct.price.toInt().toString();
        _satuanController.text = selectedProduct.unit;
      });
      _updateTotal();
    }
  }

  @override
  Widget build(BuildContext context) {
    final rawMaterialsAsync = ref.watch(productsStreamProvider);
    final pelangganAsync = ref.watch(pelanggansStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Penerimaan'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    setState(() => _selectedDate = date);
                  }
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Tanggal',
                    suffixIcon: const Icon(Iconsax.calendar),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _selectedDate != null
                        ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                        : 'Pilih Tanggal',
                  ),
                ),
              ),

              // list product dropdown
              const SizedBox(height: 16),
              rawMaterialsAsync.when(
                loading: () => const CircularProgressIndicator(),
                error: (err, _) => Text('Error: $err'),
                data: (materials) {
                  return DropdownButtonFormField<Product>(
                    value: materials.firstWhereOrNull(
                      (m) => m.name == _selectedNamaTransaksiBahanBaku,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Transaksi/Product',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: materials.map((material) {
                      return DropdownMenuItem<Product>(
                        value: material,
                        child: Text(material.name),
                      );
                    }).toList(),
                    onChanged: _handleProductChange,
                    validator: (value) {
                      if (value == null) {
                        return 'Nama Transaksi Product harus di isi!';
                      }
                      return null;
                    },
                  );
                },
              ),

              const SizedBox(height: 16),
              pelangganAsync.when(
                loading: () => const CircularProgressIndicator(),
                error: (err, _) => Text('Error: $err'),
                data: (pelanggans) {
                  return DropdownButtonFormField<String>(
                    value: _selectedPelanggan,
                    decoration: InputDecoration(
                      labelText: 'Nama Pelanggan',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: pelanggans.map((pelanggan) {
                      return DropdownMenuItem<String>(
                        value: pelanggan.name,
                        child: Text(pelanggan.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedPelanggan = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama Supplier harus di isi!';
                      }
                      return null;
                    },
                  );
                },
              ),

              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _kuantitasController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Kuantitas',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Kuantitas harus diisi';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _satuanController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Satuan',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Satuan harus diisi';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _hargaSatuanController,
                readOnly: true,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Harga Satuan',
                  prefixText: 'Rp ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga satuan harus diisi';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),
              TextFormField(
                controller: _totalController,
                readOnly: true,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Total',
                  prefixText: 'Rp ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Total harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _keteranganController,
                decoration: InputDecoration(
                  labelText: 'Keterangan',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _savePenerimaan,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Iconsax.save_2, size: 20),
                            SizedBox(width: 8),
                            Text('Simpan Penerimaan'),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
