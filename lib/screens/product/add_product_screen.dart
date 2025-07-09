import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:http/http.dart' as ref; // <--- BARIS INI DIHAPUS
import 'package:iconsax/iconsax.dart';

import '../../core/models/product_model.dart';
import '../../core/providers/product_provider.dart';

class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({super.key});

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _unitController = TextEditingController(text: 'pcs');
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    final product = Product(
      id: '',
      name: _nameController.text.trim(),
      price: double.parse(_priceController.text.replaceAll('.', '')),
      unit: _unitController.text.trim(),
    );

    try {
      print('Mencoba menyimpan produk...');
      final repository = ref.read(productRepositoryProvider);
      await repository.addProduct(product);
      print('Panggilan ke repository berhasil.');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Produk berhasil disimpan!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      print('Terjadi error saat menyimpan: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan produk: $e'),
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
        title: const Text('Tambah Produk/Jasa'),
        centerTitle: true,
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
                decoration: const InputDecoration(labelText: 'Nama Produk/Jasa', border: OutlineInputBorder(), prefixIcon: Icon(Iconsax.shop)),
                validator: (v) => v == null || v.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Harga Jual', border: OutlineInputBorder(), prefixIcon: Icon(Iconsax.money), prefixText: 'Rp '),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Harga tidak boleh kosong';
                  if (double.tryParse(v.replaceAll('.', '')) == null) return 'Masukkan angka yang valid';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _unitController,
                decoration: const InputDecoration(labelText: 'Satuan (pcs, kg, etc)', border: OutlineInputBorder(), prefixIcon: Icon(Iconsax.weight)),
                validator: (v) => v == null || v.isEmpty ? 'Satuan tidak boleh kosong' : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveProduct,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: _isLoading
                    ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                    : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(Iconsax.save_2, size: 20), SizedBox(width: 8), Text('Simpan Data')],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
