import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handycraft_app/core/models/honor_model.dart';
import 'package:handycraft_app/core/providers/honor_provider.dart';
import 'package:iconsax/iconsax.dart';

class AddHonorScreen extends StatefulWidget {
  final Honor? honor;
  const AddHonorScreen({super.key, this.honor});

  @override
  State<AddHonorScreen> createState() => _AddHonorScreenState();
}

class _AddHonorScreenState extends State<AddHonorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _jenisController = TextEditingController();
  final _gajiController = TextEditingController();
  
  // Define status options as constants
  static const List<String> statusOptions = [
    'Karyawan Tetap',
    'Karyawan Lepas',
  ];
  
  // Define satuan options as constants
  static const List<String> satuanOptions = [
    'Hari',
    'Pcs',
    'Proyek',
  ];
  
  String? _selectedStatus = statusOptions.first;
  String? _selectedSatuan = satuanOptions.first;

  @override
  void initState() {
    super.initState();
    if (widget.honor != null) {
      _jenisController.text = widget.honor!.jenisPekerjaan;
      _gajiController.text = widget.honor!.gaji.toString();
      _selectedStatus = widget.honor!.statusKaryawan;
      _selectedSatuan = widget.honor!.satuan;
    }
  }

  @override
  void dispose() {
    _jenisController.dispose();
    _gajiController.dispose();
    super.dispose();
  }

  Future<void> _saveHonor(WidgetRef ref) async {
    if (_formKey.currentState!.validate()) {
      final repository = ref.read(honorRepositoryProvider);
      final honor = Honor(
        id: widget.honor?.id ?? '',
        jenisPekerjaan: _jenisController.text.trim(),
        gaji: double.parse(_gajiController.text),
        satuan: _selectedSatuan!,
        statusKaryawan: _selectedStatus!,
      );

      try {
        if (widget.honor == null) {
          await repository.addHonor(honor);
        } else {
          await repository.updateHonor(honor);
        }
        if (mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal menyimpan data: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.honor == null ? 'Tambah Upah' : 'Edit Upah'),
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
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                items: statusOptions.map((status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pilih status karyawan';
                  }
                  return null;
                },
                borderRadius: BorderRadius.circular(12),
                elevation: 2,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _jenisController,
                decoration: const InputDecoration(
                  labelText: 'Jenis Pekerjaan',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Iconsax.task),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Jenis pekerjaan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _gajiController,
                decoration: const InputDecoration(
                  labelText: 'Upah',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Iconsax.money),
                  prefixText: 'Rp ',
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Upah tidak boleh kosong';
                  }
                  final parsedValue = double.tryParse(value);
                  if (parsedValue == null) {
                    return 'Masukkan angka yang valid';
                  }
                  if (parsedValue <= 0) {
                    return 'Upah harus lebih dari 0';
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
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                items: satuanOptions.map((satuan) {
                  return DropdownMenuItem<String>(
                    value: satuan,
                    child: Text('Per $satuan'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSatuan = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pilih satua upah';
                  }
                  return null;
                },
                borderRadius: BorderRadius.circular(12),
                elevation: 2,
              ),
              const SizedBox(height: 32),
              Consumer(
                builder: (context, ref, child) {
                  return SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => _saveHonor(ref),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
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