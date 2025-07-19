import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handycraft_app/core/models/penerimaan_model.dart';
import 'package:handycraft_app/core/providers/penerimaan_provider.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class EditPenerimaanLainnya extends ConsumerStatefulWidget {
  final String penerimaanLainnyaId;

  const EditPenerimaanLainnya({super.key, required this.penerimaanLainnyaId});

  @override
  ConsumerState<EditPenerimaanLainnya> createState() =>
      _EditPenerimaanLainnyaState();
}

class _EditPenerimaanLainnyaState extends ConsumerState<EditPenerimaanLainnya> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nominalController = TextEditingController();
  final TextEditingController _keteranganController = TextEditingController();
  final TextEditingController _uraianController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();

  DateTime? _selectedDate;
  bool _isLoading = false;
  bool _isInitialDataLoaded = false;
  PenerimaanLainnya? _existingData;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);
    try {
      final repository = ref.read(penerimaanLainnyaRepositoryProvider);
      _existingData = await repository.getPenterimaanLainnyaById(
        widget.penerimaanLainnyaId,
      );

      if (_existingData != null && mounted) {
        _selectedDate = DateTime.parse(_existingData!.tanggal);
        _tanggalController.text = DateFormat(
          'dd/MM/yyyy',
        ).format(_selectedDate!);
        _uraianController.text = _existingData!.uraian;
        _nominalController.text = _existingData!.nominal.toString();
        _keteranganController.text = _existingData!.keterangan;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat data: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isInitialDataLoaded = true;
        });
      }
    }
  }

  Future<void> _updatePenerimaanLainnya() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final updatedPenerimaan = PenerimaanLainnya(
        id: widget.penerimaanLainnyaId,
        tanggal: DateFormat('yyyy-MM-dd').format(_selectedDate!),
        uraian: _uraianController.text.trim(),
        nominal: num.tryParse(_nominalController.text.trim()) ?? 0,
        keterangan: _keteranganController.text.trim(),
      );

      final repository = ref.read(penerimaanLainnyaRepositoryProvider);
      await repository.updatePenerimaanLainnya(updatedPenerimaan);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Penerimaan berhasil diperbarui'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memperbarui: ${e.toString()}'),
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
  void dispose() {
    _nominalController.dispose();
    _keteranganController.dispose();
    _uraianController.dispose();
    _tanggalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialDataLoaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_existingData == null && _isInitialDataLoaded) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Penerimaan Lainnya'),
          leading: IconButton(
            icon: const Icon(Iconsax.arrow_left_2),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(child: Text('Data tidak ditemukan')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Penerimaan Lainnya'),
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
                        initialDate: _selectedDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (date != null && mounted) {
                        setState(() {
                          _selectedDate = date;
                          _tanggalController.text = DateFormat(
                            'dd/MM/yyyy',
                          ).format(date);
                        });
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
                controller: _uraianController,
                decoration: InputDecoration(
                  labelText: 'Uraian Penerimaan',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Uraian Penerimaan harus diisi';
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
                  onPressed: _isLoading ? null : _updatePenerimaanLainnya,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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
                            Text('Simpan Perubahan'),
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
