import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handycraft_app/core/models/pengeluaran_model.dart';
import 'package:handycraft_app/core/providers/pengeluaran_provider.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class AddPengeluaranLainnyaScreen extends ConsumerStatefulWidget {
  const AddPengeluaranLainnyaScreen({super.key});

  @override
  ConsumerState<AddPengeluaranLainnyaScreen> createState() =>
      _AddPengeluaranLainnyaScreenState();
}

class _AddPengeluaranLainnyaScreenState
    extends ConsumerState<AddPengeluaranLainnyaScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nominalController = TextEditingController();
  final TextEditingController _keteranganController = TextEditingController();
  final TextEditingController _uraianController = TextEditingController();

  DateTime? _selectedDate;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  @override
  void dispose() {
    _nominalController.dispose();
    _keteranganController.dispose();
    _uraianController.dispose();
    super.dispose();
  }

  Future<void> _savePengeluaranLainnya() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);
    try {
      final repository = ref.read(pengeluaranLainnyaRepositoryProvider);
      final newPengeluaran = PengeluaranLainnya(
        id: '',
        tanggal: DateFormat('yyyy-MM-dd').format(_selectedDate!),
        uraian: _uraianController.text.trim(),
        nominal: num.tryParse(_nominalController.text.trim()) ?? 0,
        keterangan: _keteranganController.text.trim(),
      );
      await repository.addPengeluaranLainnya(newPengeluaran);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pengeluaran lainnya berhasil disimpan'),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Pengeluaran Lainnya'),
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
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    setState(() => _selectedDate = date);
                  }
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Tanggal',
                    suffixIcon: const Icon(Iconsax.calendar),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _selectedDate != null
                        ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                        : 'Pilih Tanggal',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _uraianController,
                decoration: InputDecoration(
                  labelText: 'Uraian Pengeluaran',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Uraian pengeluaran harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nominalController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Nominal',
                  prefixText: 'Rp ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nominal harus diisi';
                  }
                  if (num.tryParse(value) == null) {
                    return 'Nominal harus berupa angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _keteranganController,
                decoration: InputDecoration(
                  labelText: 'Keterangan (Opsional)',
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
                  onPressed: isLoading ? null : _savePengeluaranLainnya,
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