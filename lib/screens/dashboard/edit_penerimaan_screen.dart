import 'package:flutter/material.dart';
import 'package:handycraft_app/core/models/penerimaan_model.dart';
import 'package:handycraft_app/core/models/product_model.dart';
import 'package:handycraft_app/core/providers/pelanggan_provider.dart';
import 'package:handycraft_app/core/providers/penerimaan_provider.dart';
import 'package:handycraft_app/core/providers/product_provider.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditPenerimaanScreen extends ConsumerStatefulWidget {
  final String penerimaanId;

  const EditPenerimaanScreen({super.key, required this.penerimaanId});

  @override
  ConsumerState<EditPenerimaanScreen> createState() =>
      _EditPenerimaanScreenState();
}

class _EditPenerimaanScreenState extends ConsumerState<EditPenerimaanScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tanggalController;
  late TextEditingController _kuantitasController;
  late TextEditingController _hargaSatuanController;
  late TextEditingController _totalController;
  late TextEditingController _keteranganController;
  late TextEditingController _satuanController;

  String? _selectedPelanggan;
  String? _selectedNamaTransaksiBahanBaku;
  bool _isLoading = true;
  bool _isSaving = false;
  PenerimaanModel? _penerimaanData;
  Product? _selectedProduct;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadPenerimaanData();
  }

  void _initializeControllers() {
    _tanggalController = TextEditingController();
    _kuantitasController = TextEditingController();
    _hargaSatuanController = TextEditingController();
    _totalController = TextEditingController();
    _keteranganController = TextEditingController();
    _satuanController = TextEditingController();

    _kuantitasController.addListener(_calculateTotal);
    _hargaSatuanController.addListener(_calculateTotal);
  }

  void _calculateTotal() {
    final kuantitas = num.tryParse(_kuantitasController.text) ?? 0;
    final hargaSatuan = num.tryParse(_hargaSatuanController.text) ?? 0;
    final total = kuantitas * hargaSatuan;
    _totalController.text = total.toStringAsFixed(0);
  }

  Future<void> _loadPenerimaanData() async {
    try {
      final repository = ref.read(penerimaanRepositoryProvider);
      final data = await repository.getPenerimaanById(widget.penerimaanId);

      if (mounted) {
        setState(() {
          _penerimaanData = data;
          if (data != null) {
            _tanggalController.text = data.tanggal;
            _kuantitasController.text = data.kuantitas.toString();
            _hargaSatuanController.text = data.hargaSatuan.toInt().toString();
            _totalController.text = data.total.toString();
            _keteranganController.text = data.keterangan;
            _selectedPelanggan = data.pelanggan;
            _satuanController.text = data.satuan;
            _selectedNamaTransaksiBahanBaku = data.transaksi;
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat data: ${e.toString()}')),
        );
        Navigator.pop(context);
      }
    }
  }

  Future<void> _updatePenerimaan() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final updatedData = PenerimaanModel(
        id: widget.penerimaanId,
        tanggal: _tanggalController.text,
        transaksi: _selectedNamaTransaksiBahanBaku ?? '',
        pelanggan: _selectedPelanggan ?? '',
        kuantitas: num.parse(_kuantitasController.text),
        satuan: _satuanController.text,
        hargaSatuan: num.parse(_hargaSatuanController.text),
        total: num.parse(_totalController.text),
        keterangan: _keteranganController.text,
      );

      await ref
          .read(penerimaanRepositoryProvider)
          .updatePenerimaan(updatedData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data berhasil diperbarui'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memperbarui: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _handleProductChange(Product? selectedProduct) {
    if (selectedProduct != null) {
      setState(() {
        _selectedProduct = selectedProduct;
        _selectedNamaTransaksiBahanBaku = selectedProduct.name;
        _hargaSatuanController.text = selectedProduct.price.toInt().toString();
        _satuanController.text = selectedProduct.unit;
      });
      _calculateTotal();
    }
  }

  @override
  void dispose() {
    _tanggalController.dispose();
    _kuantitasController.dispose();
    _hargaSatuanController.dispose();
    _totalController.dispose();
    _keteranganController.dispose();
    _satuanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rawMaterialsAsync = ref.watch(productsStreamProvider);
    final pelangganAsync = ref.watch(pelanggansStreamProvider);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Penerimaan'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Iconsax.arrow_left_2),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_penerimaanData == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Penerimaan'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Iconsax.arrow_left_2),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(child: Text('Data tidak ditemukan')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Penerimaan'),
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
              // Input tanggal
              TextFormField(
                controller: _tanggalController,
                decoration: InputDecoration(
                  labelText: 'Tanggal',
                  suffixIcon: IconButton(
                    icon: const Icon(Iconsax.calendar),
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) {
                        _tanggalController.text =
                            '${date.day}/${date.month}/${date.year}';
                      }
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tanggal harus diisi';
                  }
                  return null;
                },
              ),

              // Dropdown product
              const SizedBox(height: 16),
              rawMaterialsAsync.when(
                loading: () => const CircularProgressIndicator(),
                error: (err, _) => Text('Error: $err'),
                data: (products) {
                  // Find the current product if it exists
                  final currentProduct = products.firstWhere(
                    (p) => p.name == _selectedNamaTransaksiBahanBaku,
                    orElse: () =>
                        Product(id: '', name: '', price: 0, unit: 'pcs'),
                  );

                  return DropdownButtonFormField<Product>(
                    value: currentProduct.name.isNotEmpty
                        ? currentProduct
                        : null,
                    decoration: InputDecoration(
                      labelText: 'Transaksi/Product',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: products.map((product) {
                      return DropdownMenuItem<Product>(
                        value: product,
                        child: Text(product.name),
                      );
                    }).toList(),
                    onChanged: _handleProductChange,
                    validator: (value) {
                      if (value == null) {
                        return 'Nama Transaksi harus diisi';
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
                  if (_selectedPelanggan != null &&
                      !pelanggans.any((p) => p.name == _selectedPelanggan)) {
                    _selectedPelanggan = null;
                  }
                  return DropdownButtonFormField<String>(
                    value: _selectedPelanggan,
                    decoration: InputDecoration(
                      labelText: 'Pelanggan',
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
                        return 'Nama Pelanggan harus diisi';
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

              // Harga Satuan
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

              // Total
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
              ),

              // Keterangan
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

              // Tombol Simpan
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _updatePenerimaan,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSaving
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
                            Text('Simpan Perubahan'),
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
