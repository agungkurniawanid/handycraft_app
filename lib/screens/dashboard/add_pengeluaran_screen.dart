import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class AddPengeluaranScreen extends StatefulWidget {
  const AddPengeluaranScreen({super.key});

  @override
  State<AddPengeluaranScreen> createState() => _AddPengeluaranScreenState();
}

class _AddPengeluaranScreenState extends State<AddPengeluaranScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _namaTransaksiController = TextEditingController();
  final TextEditingController _kuantitasController = TextEditingController();
  final TextEditingController _hargaSatuanController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();
  final TextEditingController _keteranganController = TextEditingController();
  
  String? _selectedKaryawanSupplier;
  String? _selectedSatuan;
  
  final List<String> _karyawanSupplierList = ['Karyawan A', 'Karyawan B', 'Supplier X', 'Supplier Y'];
  final List<String> _satuanList = ['Pcs', 'Lusin', 'Kg', 'Meter'];

  @override
  void dispose() {
    _tanggalController.dispose();
    _namaTransaksiController.dispose();
    _kuantitasController.dispose();
    _hargaSatuanController.dispose();
    _totalController.dispose();
    _keteranganController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                        _tanggalController.text = '${date.day}/${date.month}/${date.year}';
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
              const SizedBox(height: 16),
              TextFormField(
                controller: _namaTransaksiController,
                decoration: InputDecoration(
                  labelText: 'Nama Transaksi',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama transaksi harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedKaryawanSupplier,
                decoration: InputDecoration(
                  labelText: 'Karyawan/Supplier',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: _karyawanSupplierList.map((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedKaryawanSupplier = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harus dipilih';
                  }
                  return null;
                },
              ),
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
                    child: DropdownButtonFormField<String>(
                      value: _selectedSatuan,
                      decoration: InputDecoration(
                        labelText: 'Satuan',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: _satuanList.map((satuan) {
                        return DropdownMenuItem(
                          value: satuan,
                          child: Text(satuan),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedSatuan = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Satuan harus dipilih';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _hargaSatuanController,
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
              const SizedBox(height: 16),
              TextFormField(
                controller: _totalController,
                keyboardType: TextInputType.number,
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
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Simpan data
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pengeluaran berhasil disimpan')),
                      );
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Simpan Pengeluaran'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}