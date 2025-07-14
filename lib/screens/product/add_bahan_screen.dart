import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handycraft_app/core/models/product_model.dart';
import 'package:handycraft_app/core/providers/product_provider.dart';
import 'package:iconsax/iconsax.dart';

// 1. Ubah menjadi ConsumerStatefulWidget
class AddBahanScreen extends ConsumerStatefulWidget {
  const AddBahanScreen({super.key});

  @override
  ConsumerState<AddBahanScreen> createState() => _AddBahanScreenState();
}

class _AddBahanScreenState extends ConsumerState<AddBahanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _unitController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  Future<void> _saveMaterial() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    final material = RawMaterialModel(
      id: '',
      name: _nameController.text.trim(),
      price: double.parse(_priceController.text.replaceAll('.', '')),
      unit: _unitController.text.trim(),
    );

    try {
      final repository = ref.read(productRepositoryProvider);
      await repository.addRawMaterial(material);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bahan baku berhasil disimpan!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan bahan baku: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Bahan Baku'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Bahan Baku',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Iconsax.box),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama bahan baku tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Harga Beli Satuan',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Iconsax.money),
                  prefixText: 'Rp ',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga tidak boleh kosong';
                  }
                  if (double.tryParse(value.replaceAll('.', '')) == null) {
                    return 'Masukkan angka yang valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _unitController,
                decoration: const InputDecoration(
                  labelText: 'Satuan (kg, pcs, liter, etc)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Iconsax.weight),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Satuan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveMaterial,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isLoading
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
                    Text('Simpan Data'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
