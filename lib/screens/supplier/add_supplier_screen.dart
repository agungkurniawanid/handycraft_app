import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handycraft_app/core/models/supplier_model.dart';
import 'package:handycraft_app/core/providers/supplier_provider.dart' show supplierRepositoryProvider;
import 'package:iconsax/iconsax.dart';

class AddSupplierScreen extends StatefulWidget {
  final Supplier? supplier;
  const AddSupplierScreen({super.key, this.supplier});

  @override
  State<AddSupplierScreen> createState() => _AddSupplierScreenState();
}

class _AddSupplierScreenState extends State<AddSupplierScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.supplier != null) {
      _nameController.text = widget.supplier!.name;
      _phoneController.text = widget.supplier!.phone;
      _addressController.text = widget.supplier!.address;
      _descriptionController.text = widget.supplier!.description;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveSupplier(WidgetRef ref) async {
    if (_formKey.currentState!.validate()) {
      final repository = ref.read(supplierRepositoryProvider);
      final supplier = Supplier(
        id: widget.supplier?.id ?? '',
        name: _nameController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        description: _descriptionController.text,
      );

      try {
        if (widget.supplier == null) {
          await repository.addSupplier(supplier);
        } else {
          await repository.updateSupplier(supplier);
        }
        if (mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.supplier == null ? 'Tambah Supplier' : 'Edit Supplier'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Supplier',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Iconsax.shop),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama supplier tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Nomor Telepon',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Iconsax.call),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor telepon tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Alamat Supplier',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Iconsax.location),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alamat tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Keterangan (Jenis Supplier)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Iconsax.note),
                  hintText: 'Contoh: Supplier Kayu, Supplier Cat, dll',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Keterangan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              Consumer(
                builder: (context, ref, child) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _saveSupplier(ref),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Iconsax.save_2, size: 20),
                          SizedBox(width: 8),
                          Text('Simpan Supplier'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}