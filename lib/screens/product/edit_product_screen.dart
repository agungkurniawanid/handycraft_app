import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handycraft_app/core/models/product_model.dart';
import 'package:handycraft_app/core/providers/product_provider.dart';
import 'package:iconsax/iconsax.dart';

enum ItemType { product, rawMaterial }

class EditItemScreen extends ConsumerStatefulWidget {
  final dynamic item;
  final ItemType type;

  const EditItemScreen({
    super.key,
    required this.item,
    required this.type,
  });

  @override
  ConsumerState<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends ConsumerState<EditItemScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _unitController;
  bool _isLoading = false;

  late String _appBarTitle;
  late String _nameLabel;
  late String _priceLabel;
  late IconData _nameIcon;

  @override
  void initState() {
    super.initState();
    // Set UI dan isi controller berdasarkan tipe item
    if (widget.type == ItemType.product) {
      final product = widget.item as Product;
      _nameController = TextEditingController(text: product.name);
      _priceController = TextEditingController(text: product.price.toStringAsFixed(0));
      _unitController = TextEditingController(text: product.unit);
      _appBarTitle = 'Edit Produk/Jasa';
      _nameLabel = 'Nama Produk/Jasa';
      _priceLabel = 'Harga Jual';
      _nameIcon = Iconsax.shop;
    } else {
      final material = widget.item as RawMaterialModel;
      _nameController = TextEditingController(text: material.name);
      _priceController = TextEditingController(text: material.price.toStringAsFixed(0));
      _unitController = TextEditingController(text: material.unit);
      _appBarTitle = 'Edit Bahan Baku';
      _nameLabel = 'Nama Bahan Baku';
      _priceLabel = 'Harga Beli Satuan';
      _nameIcon = Iconsax.box;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  Future<void> _updateItem() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final repository = ref.read(productRepositoryProvider);
      if (widget.type == ItemType.product) {
        final updatedProduct = Product(
          id: widget.item.id,
          name: _nameController.text.trim(),
          price: double.parse(_priceController.text.replaceAll('.', '')),
          unit: _unitController.text.trim(),
        );
        await repository.updateProduct(updatedProduct);
      } else {
        final updatedMaterial = RawMaterialModel(
          id: widget.item.id,
          name: _nameController.text.trim(),
          price: double.parse(_priceController.text.replaceAll('.', '')),
          unit: _unitController.text.trim(),
        );
        await repository.updateRawMaterial(updatedMaterial);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${widget.type == ItemType.product ? "Produk" : "Bahan baku"} berhasil diperbarui!'), backgroundColor: Colors.green));
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal memperbarui: $e'), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_appBarTitle), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(controller: _nameController, decoration: InputDecoration(labelText: _nameLabel, border: const OutlineInputBorder(), prefixIcon: Icon(_nameIcon)), validator: (v) => v == null || v.isEmpty ? 'Nama tidak boleh kosong' : null),
              const SizedBox(height: 16),
              TextFormField(controller: _priceController, decoration: InputDecoration(labelText: _priceLabel, border: const OutlineInputBorder(), prefixIcon: const Icon(Iconsax.money), prefixText: 'Rp '), keyboardType: TextInputType.number, validator: (v) { if (v == null || v.isEmpty) return 'Harga tidak boleh kosong'; if (double.tryParse(v.replaceAll('.', '')) == null) return 'Masukkan angka yang valid'; return null; }),
              const SizedBox(height: 16),
              TextFormField(controller: _unitController, decoration: const InputDecoration(labelText: 'Satuan (pcs, kg, etc)', border: OutlineInputBorder(), prefixIcon: Icon(Iconsax.weight)), validator: (v) => v == null || v.isEmpty ? 'Satuan tidak boleh kosong' : null),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _updateItem,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                child: _isLoading ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3)) : const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Iconsax.save_2, size: 20), SizedBox(width: 8), Text('Simpan Perubahan')]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
