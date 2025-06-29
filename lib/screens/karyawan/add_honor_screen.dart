import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class AddHonorScreen extends StatefulWidget {
  const AddHonorScreen({super.key});

  @override
  State<AddHonorScreen> createState() => _AddHonorScreenState();
}

class _AddHonorScreenState extends State<AddHonorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _jenisController = TextEditingController();
  final _gajiController = TextEditingController();
  String? _selectedStatus = 'Tetap';
  String? _selectedSatuan = 'Hari';

  @override
  void dispose() {
    _jenisController.dispose();
    _gajiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Daftar Honor'),
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
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Status Karyawan',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Iconsax.user_tag),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Tetap',
                    child: Text('Karyawan Tetap'),
                  ),
                  DropdownMenuItem(
                    value: 'Lepas',
                    child: Text('Karyawan Lepas'),
                  ),
                ],
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
              const SizedBox(height: 16),
              TextFormField(
                controller: _jenisController,
                decoration: const InputDecoration(
                  labelText: 'Jenis Pekerjaan',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Iconsax.task),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jenis pekerjaan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _gajiController,
                decoration: const InputDecoration(
                  labelText: 'Gaji',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Iconsax.money),
                  prefixText: 'Rp ',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Gaji tidak boleh kosong';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Masukkan angka yang valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedSatuan,
                decoration: const InputDecoration(
                  labelText: 'Satuan',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Iconsax.weight),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Hari',
                    child: Text('Per Hari'),
                  ),
                  DropdownMenuItem(
                    value: 'Pcs',
                    child: Text('Per Pcs'),
                  ),
                  DropdownMenuItem(
                    value: 'Proyek',
                    child: Text('Per Proyek'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedSatuan = value;
                  });
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Daftar honor berhasil disimpan')),
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
                      Text('Simpan Data'),
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