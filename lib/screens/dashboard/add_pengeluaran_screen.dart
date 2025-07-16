import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handycraft_app/core/extensions/penerimaan_extension.dart';
import 'package:handycraft_app/core/models/pengeluaran_model.dart';
import 'package:handycraft_app/core/models/product_model.dart';
import 'package:handycraft_app/core/providers/pengeluaran_provider.dart';
import 'package:handycraft_app/core/providers/product_provider.dart';
import 'package:handycraft_app/core/providers/supplier_provider.dart';
import 'package:iconsax/iconsax.dart';

class AddPengeluaranScreen extends ConsumerStatefulWidget {
  const AddPengeluaranScreen({super.key});

  @override
  ConsumerState<AddPengeluaranScreen> createState() =>
      _AddPengeluaranScreenState();
}

class _AddPengeluaranScreenState extends ConsumerState<AddPengeluaranScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _kuantitasController = TextEditingController();
  final TextEditingController _hargaSatuanController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();
  final TextEditingController _keteranganController = TextEditingController();
  final TextEditingController _satuanController = TextEditingController();

  String? _selectedNameSupplier;
  String? _selectedNamaTransaksiBahanBaku;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _kuantitasController.addListener(_updateTotal);
    _hargaSatuanController.addListener(_updateTotal);
  }

  void _updateTotal() {
    final kuantitas = num.tryParse(_kuantitasController.text.trim()) ?? 0;
    final hargaSatuan = num.tryParse(_hargaSatuanController.text.trim()) ?? 0;
    final total = kuantitas * hargaSatuan;
    _totalController.text = total.toStringAsFixed(0);
  }

  void _handleMaterialChange(RawMaterialModel? selectedMaterial) {
    if (selectedMaterial != null) {
      setState(() {
        _selectedNamaTransaksiBahanBaku = selectedMaterial.name;
        _hargaSatuanController.text = selectedMaterial.price.toInt().toString();
        _satuanController.text = selectedMaterial.unit;
      });
      _updateTotal();
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

  Future<void> _savePengeluaran() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);
    try {
      final repository = ref.read(pengeluaranRepositoryProvider);
      final newPengeluaran = Pengeluaran(
        id: '',
        tanggal: _tanggalController.text.trim(),
        transaksi: _selectedNamaTransaksiBahanBaku ?? '',
        supplierName: _selectedNameSupplier ?? '',
        kuantitas: num.tryParse(_kuantitasController.text.trim()) ?? 0,
        satuan: _satuanController.text.trim(),
        hargaSatuan: num.tryParse(_hargaSatuanController.text.trim()) ?? 0,
        total: num.tryParse(_totalController.text.trim()) ?? 0,
        keterangan: _keteranganController.text.trim(),
      );
      await repository.addPengeluaran(newPengeluaran);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pengeluaran berhasil disimpan'),
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

  @override
  Widget build(BuildContext context) {
    // call providers
    final supplierProviderAsync = ref.watch(suppliersStreamProvider);
    final rawMaterialsAsync = ref.watch(rawMaterialsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Pengeluaran'),
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
              // input tanggal
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

              // input nama transaksi bahan baku
              const SizedBox(height: 16),
              rawMaterialsAsync.when(
                loading: () => const CircularProgressIndicator(),
                error: (err, _) => Text('Error: $err'),
                data: (materials) {
                  return DropdownButtonFormField<RawMaterialModel>(
                    value: materials.firstWhereOrNull(
                      (m) => m.name == _selectedNamaTransaksiBahanBaku,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Transaksi/Bahan Baku',
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
                    onChanged: _handleMaterialChange,
                    validator: (value) {
                      if (value == null) {
                        return 'Nama Transaksi Bahan Baku harus di isi!';
                      }
                      return null;
                    },
                  );
                },
              ),

              // supplier list dropdown
              const SizedBox(height: 16),
              supplierProviderAsync.when(
                loading: () => const CircularProgressIndicator(),
                error: (err, _) => Text('Error: $err'),
                data: (suppliers) {
                  return DropdownButtonFormField<String>(
                    value: _selectedNameSupplier,
                    decoration: InputDecoration(
                      labelText: 'Nama Supplier',
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
                        _selectedNameSupplier = value;
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

              // input kuantitas dan satuan
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

              // input harga satuan
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

              // input total
              const SizedBox(height: 16),
              TextFormField(
                controller: _totalController,
                keyboardType: TextInputType.number,
                readOnly: true,
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

              // input keterangan
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

              // button save
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _savePengeluaran,
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
                            Text('Simpan Pengeluaran'),
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
