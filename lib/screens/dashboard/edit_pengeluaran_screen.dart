import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handycraft_app/core/models/pengeluaran_model.dart';
import 'package:handycraft_app/core/models/product_model.dart';
import 'package:handycraft_app/core/providers/pengeluaran_provider.dart';
import 'package:handycraft_app/core/providers/product_provider.dart';
import 'package:handycraft_app/core/providers/supplier_provider.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class EditPengeluaranScreen extends ConsumerStatefulWidget {
  final String pengeluaranId;
  const EditPengeluaranScreen({super.key, required this.pengeluaranId});

  @override
  ConsumerState<EditPengeluaranScreen> createState() =>
      _EditPengeluaranScreenState();
}

class _EditPengeluaranScreenState extends ConsumerState<EditPengeluaranScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tanggalController;
  late TextEditingController _kuantitasController;
  late TextEditingController _hargaSatuanController;
  late TextEditingController _totalController;
  late TextEditingController _keteranganController;

  String? _selectedSupplier;
  RawMaterialModel? _selectedRawMaterial;
  bool _isLoading = true;
  bool _isSaving = false;
  String? _selectedUnit;
  Pengeluaran? _pengeluaranData;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadPengeluaranData();
  }

  void _initializeControllers() {
    _tanggalController = TextEditingController();
    _kuantitasController = TextEditingController();
    _hargaSatuanController = TextEditingController();
    _totalController = TextEditingController();
    _keteranganController = TextEditingController();

    _kuantitasController.addListener(_calculateTotal);
    _hargaSatuanController.addListener(_calculateTotal);
  }

  void _calculateTotal() {
    final kuantitas = num.tryParse(_kuantitasController.text) ?? 0;
    final hargaSatuan = num.tryParse(_hargaSatuanController.text) ?? 0;
    final total = kuantitas * hargaSatuan;
    _totalController.text = total.toStringAsFixed(0);
  }

  Future<void> _loadPengeluaranData() async {
    try {
      final repository = ref.read(pengeluaranRepositoryProvider);
      final data = await repository.getPengeluaranById(widget.pengeluaranId);

      if (mounted) {
        setState(() {
          _pengeluaranData = data;
          if (data != null) {
            final date = DateFormat('yyyy-MM-dd').parse(data.tanggal);
            _tanggalController.text = DateFormat('dd/MM/yyyy').format(date);
            _kuantitasController.text = data.kuantitas.toString();
            _hargaSatuanController.text = data.hargaSatuan.toInt().toString();
            _totalController.text = data.total.toString();
            _keteranganController.text = data.keterangan;
            _selectedSupplier = data.supplierName;
            _selectedUnit = data.satuan;
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

  Future<void> _updatePengeluaran() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final parsedDate = DateFormat(
        'dd/MM/yyyy',
      ).parse(_tanggalController.text);
      final firebaseDate = DateFormat('yyyy-MM-dd').format(parsedDate);

      final updatedData = Pengeluaran(
        id: widget.pengeluaranId,
        tanggal: firebaseDate,
        transaksi:
            _selectedRawMaterial?.name ?? _pengeluaranData?.transaksi ?? '',
        supplierName: _selectedSupplier ?? '',
        kuantitas: num.parse(_kuantitasController.text),
        satuan: _selectedUnit ?? _selectedRawMaterial?.unit ?? '',
        hargaSatuan: num.parse(_hargaSatuanController.text),
        total: num.parse(_totalController.text),
        keterangan: _keteranganController.text,
      );

      await ref
          .read(pengeluaranRepositoryProvider)
          .updatePengeluaran(updatedData);

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

  void _handleRawMaterialChange(RawMaterialModel? selectedMaterial) {
    if (selectedMaterial != null) {
      setState(() {
        _selectedRawMaterial = selectedMaterial;
        _selectedUnit = selectedMaterial.unit;
        _hargaSatuanController.text = selectedMaterial.price.toStringAsFixed(0);
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rawMaterialsAsync = ref.watch(rawMaterialsStreamProvider);
    final supplierAsync = ref.watch(suppliersStreamProvider);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Pengeluaran'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Iconsax.arrow_left_2),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_pengeluaranData == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Pengeluaran'),
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
        title: const Text('Edit Pengeluaran'),
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
              TextFormField(
                controller: _tanggalController,
                decoration: InputDecoration(
                  labelText: 'Tanggal',
                  suffixIcon: IconButton(
                    icon: const Icon(Iconsax.calendar),
                    onPressed: () async {
                      final initialDate = _tanggalController.text.isNotEmpty
                          ? DateFormat(
                              'dd/MM/yyyy',
                            ).parse(_tanggalController.text)
                          : DateTime.now();

                      final date = await showDatePicker(
                        context: context,
                        initialDate: initialDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) {
                        _tanggalController.text = DateFormat(
                          'dd/MM/yyyy',
                        ).format(date);
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

              // Dropdown bahan baku
              const SizedBox(height: 16),
              rawMaterialsAsync.when(
                loading: () => const CircularProgressIndicator(),
                error: (err, _) => Text('Error: $err'),
                data: (materials) {
                  final currentMaterial = _pengeluaranData?.transaksi != null
                      ? materials.firstWhere(
                          (m) => m.name == _pengeluaranData?.transaksi,
                          orElse: () => RawMaterialModel(
                            id: '',
                            name: '',
                            price: 0,
                            unit: '',
                          ),
                        )
                      : null;
                  return DropdownButtonFormField<RawMaterialModel>(
                    value: currentMaterial?.name.isNotEmpty == true
                        ? currentMaterial
                        : null,
                    decoration: InputDecoration(
                      labelText: 'Bahan Baku',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: materials.map((material) {
                      return DropdownMenuItem<RawMaterialModel>(
                        value: material,
                        child: Text(material.name),
                      );
                    }).toList(),
                    onChanged: _handleRawMaterialChange,
                    validator: (value) {
                      if (value == null) {
                        return 'Bahan baku harus dipilih';
                      }
                      return null;
                    },
                  );
                },
              ),

              // Dropdown supplier
              const SizedBox(height: 16),
              supplierAsync.when(
                loading: () => const CircularProgressIndicator(),
                error: (err, _) => Text('Error: $err'),
                data: (suppliers) {
                  if (_selectedSupplier != null &&
                      !suppliers.any((s) => s.name == _selectedSupplier)) {
                    _selectedSupplier = null;
                  }
                  return DropdownButtonFormField<String>(
                    value: _selectedSupplier,
                    decoration: InputDecoration(
                      labelText: 'Supplier',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: suppliers.map((supplier) {
                      return DropdownMenuItem<String>(
                        value: supplier.name,
                        child: Text(supplier.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSupplier = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Supplier harus dipilih';
                      }
                      return null;
                    },
                  );
                },
              ),

              // Kuantitas dan Satuan
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
                        if (num.tryParse(value) == null) {
                          return 'Harus berupa angka';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: TextEditingController(
                        text: _selectedUnit ?? '',
                      ),
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Satuan',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Satuan harus ada';
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
                keyboardType: TextInputType.number,
                readOnly: true,
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
                  if (num.tryParse(value) == null) {
                    return 'Harus berupa angka';
                  }
                  return null;
                },
              ),

              // Total
              const SizedBox(height: 16),
              TextFormField(
                controller: _totalController,
                readOnly: true,
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
                  onPressed: _isSaving ? null : _updatePengeluaran,
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
