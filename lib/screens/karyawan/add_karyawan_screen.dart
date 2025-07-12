import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handycraft_app/core/models/karyawan_model.dart';
import 'package:handycraft_app/core/providers/karyawan_provider.dart';
import 'package:iconsax/iconsax.dart';

class AddKaryawanScreen extends StatefulWidget {
  final Karyawan? karyawan;
  const AddKaryawanScreen({super.key, this.karyawan});

  @override
  State<AddKaryawanScreen> createState() => _AddKaryawanScreenState();
}

class _AddKaryawanScreenState extends State<AddKaryawanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  String? _selectedStatus;

  // Daftar status yang tersedia
  final List<String> _statusOptions = [
    'Karyawan Tetap',
    'Karyawan Lepas',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.karyawan != null) {
      _nameController.text = widget.karyawan!.name;
      _phoneController.text = widget.karyawan!.phone;
      _addressController.text = widget.karyawan!.address;
      _selectedStatus = widget.karyawan!.status;
    } else {
      _selectedStatus = _statusOptions.first; // Set default value
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _saveKaryawan(WidgetRef ref) async {
    if (_formKey.currentState!.validate()) {
      final repository = ref.read(karyawanRepositoryProvider);
      final karyawan = Karyawan(
        id: widget.karyawan?.id ?? '',
        name: _nameController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        status: _selectedStatus ?? _statusOptions.first,
      );

      try {
        if (widget.karyawan == null) {
          await repository.addKaryawan(karyawan);
        } else {
          await repository.updateKaryawan(karyawan);
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
        title: Text(widget.karyawan == null ? 'Tambah Karyawan' : 'Edit Karyawan'),
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
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Karyawan',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Iconsax.profile_2user),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama karyawan tidak boleh kosong';
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
                  labelText: 'Alamat',
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
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Status Karyawan',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Iconsax.user_tag),
                ),
                items: _statusOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Pilih status karyawan';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              Consumer(
                builder: (context, ref, child) {
                  return SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => _saveKaryawan(ref),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Iconsax.save_2, size: 20),
                          SizedBox(width: 8),
                          Text('Simpan Data'),
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