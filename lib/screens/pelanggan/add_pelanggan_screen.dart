import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class AddPelangganScreen extends StatefulWidget {
  const AddPelangganScreen({super.key});

  @override
  State<AddPelangganScreen> createState() => _AddPelangganScreenState();
}

class _AddPelangganScreenState extends State<AddPelangganScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Pelanggan',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2),
          onPressed: () => Navigator.pop(context),
          splashRadius: 20,
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Nama Pelanggan Field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Pelanggan',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Iconsax.profile_2user),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama pelanggan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Nomor Telepon Field
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Nomor Telepon',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Iconsax.call),
                  hintText: '08123456789',
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor telepon tidak boleh kosong';
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'Masukkan nomor yang valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Alamat Field
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Alamat Lengkap',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Iconsax.location),
                  hintText: 'Jl. Contoh No. 123, Kota',
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

              // Deskripsi/Keterangan Field
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Keterangan (Pesanan/Kebutuhan)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Iconsax.note_text),
                  hintText: 'Contoh: Pesan meja makan dari kayu jati',
                ),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Keterangan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Data pelanggan berhasil disimpan'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
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
                      Text('Simpan Pelanggan'),
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