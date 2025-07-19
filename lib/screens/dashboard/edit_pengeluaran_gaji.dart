import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handycraft_app/core/models/karyawan_model.dart';
import 'package:handycraft_app/core/models/pengeluaran_model.dart';
import 'package:handycraft_app/core/providers/honor_provider.dart';
import 'package:handycraft_app/core/providers/karyawan_provider.dart';
import 'package:handycraft_app/core/providers/pengeluaran_provider.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class EditPengeluaranGaji extends ConsumerStatefulWidget {
  final String pengeluaranGajiId;
  const EditPengeluaranGaji({super.key, required this.pengeluaranGajiId});

  @override
  ConsumerState<EditPengeluaranGaji> createState() =>
      _EditPengeluaranGajiState();
}

class _EditPengeluaranGajiState extends ConsumerState<EditPengeluaranGaji> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _jumlahGajiController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();
  final TextEditingController _keteranganController = TextEditingController();
  final TextEditingController _statusKaryawanController =
      TextEditingController();
  final TextEditingController _tipeSatuanController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _jumlahHariOrBarangController =
      TextEditingController();

  String? _selectedKaryawanId;
  String? _selectedKaryawanName;
  String? _selectedHonorId;
  String? _selectedJenisPekerjaan;
  bool _isLoading = false;
  bool _isInitialDataLoaded = false;
  PengeluaranGajiKaryawan? _existingData;

  @override
  void initState() {
    super.initState();
    _jumlahGajiController.addListener(_updateTotal);
    _jumlahHariOrBarangController.addListener(_updateTotal);
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);
    try {
      final repository = ref.read(pengeluaranGajiKaryawanRepositoryProvider);
      _existingData = await repository.getPengeluaranGajiKaryawanById(
        widget.pengeluaranGajiId,
      );

      if (_existingData != null && mounted) {
        _selectedKaryawanId = _existingData!.karyawanId;
        _selectedKaryawanName = _existingData!.namaKaryawan;
        _selectedHonorId = _existingData!.honorId;
        _selectedJenisPekerjaan = _existingData!.jenisPekerjaan;

        final parsedDate = DateTime.parse(
          _existingData!.tanggalPengeluaranGaji,
        );
        _tanggalController.text = DateFormat('dd/MM/yyyy').format(parsedDate);

        _jumlahGajiController.text = NumberFormat(
          '#,###',
        ).format(_existingData!.jumlahGaji);
        _totalController.text = NumberFormat(
          '#,###',
        ).format(_existingData!.total);
        _keteranganController.text = _existingData!.keterangan;
        _statusKaryawanController.text = _existingData!.statusKaryawan ?? '';
        _tipeSatuanController.text = _existingData!.tipeSatuan ?? '';
        _searchController.text = _existingData!.namaKaryawan;
        _jumlahHariOrBarangController.text = _existingData!.jumlahHariOrBarang
            .toString();
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

  void _updateTotal() {
    final jumlahGaji =
        num.tryParse(_jumlahGajiController.text.replaceAll(',', '')) ?? 0;
    final jumlahHariOrBarang =
        num.tryParse(_jumlahHariOrBarangController.text) ?? 0;

    final total = jumlahGaji * jumlahHariOrBarang;
    _totalController.text = NumberFormat('#,###').format(total);
  }

  String _getQuantityLabel() {
    final status = _statusKaryawanController.text;
    return status == 'Karyawan Tetap' ? 'Jumlah Hari' : 'Jumlah Barang (pcs)';
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final parsedDate = DateFormat(
        'dd/MM/yyyy',
      ).parse(_tanggalController.text);
      final isoDate = DateFormat('yyyy-MM-dd').format(parsedDate);

      final updatedPengeluaran = PengeluaranGajiKaryawan(
        id: widget.pengeluaranGajiId,
        karyawanId: _selectedKaryawanId ?? '',
        namaKaryawan: _selectedKaryawanName ?? '',
        tanggalPengeluaranGaji: isoDate,
        jumlahGaji: num.parse(_jumlahGajiController.text.replaceAll(',', '')),
        total: num.parse(_totalController.text.replaceAll(',', '')),
        keterangan: _keteranganController.text,
        honorId: _selectedHonorId,
        jenisPekerjaan: _selectedJenisPekerjaan ?? '',
        statusKaryawan: _statusKaryawanController.text,
        tipeSatuan: _tipeSatuanController.text.isNotEmpty
            ? _tipeSatuanController.text
            : null,
      );

      final repository = ref.read(pengeluaranGajiKaryawanRepositoryProvider);
      await repository.updatePengeluaranGajiKaryawan(updatedPengeluaran);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data pengeluaran gaji berhasil diperbarui'),
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
    _tanggalController.dispose();
    _jumlahGajiController.dispose();
    _totalController.dispose();
    _keteranganController.dispose();
    _statusKaryawanController.dispose();
    _tipeSatuanController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final karyawanListAsync = ref.watch(karyawanStreamProvider);
    final honorListAsync = ref.watch(honorStreamProvider);

    if (!_isInitialDataLoaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_existingData == null && _isInitialDataLoaded) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Pengeluaran Gaji'),
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
        title: const Text('Edit Pengeluaran Gaji'),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Input Tanggal
              TextFormField(
                controller: _tanggalController,
                decoration: InputDecoration(
                  labelText: 'Tanggal Pengeluaran',
                  suffixIcon: IconButton(
                    icon: const Icon(Iconsax.calendar),
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (date != null && mounted) {
                        setState(() {
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  karyawanListAsync.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, stack) => Text('Error: $error'),
                    data: (karyawanList) {
                      return RawAutocomplete<String>(
                        focusNode: FocusNode(),
                        textEditingController: _searchController,
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text.isEmpty) {
                            return karyawanList.map((k) => k.id);
                          }
                          return karyawanList
                              .where(
                                (karyawan) =>
                                    karyawan.name.toLowerCase().contains(
                                      textEditingValue.text.toLowerCase(),
                                    ),
                              )
                              .map((karyawan) => karyawan.id);
                        },
                        optionsViewBuilder:
                            (
                              BuildContext context,
                              AutocompleteOnSelected<String> onSelected,
                              Iterable<String> options,
                            ) {
                              return Align(
                                alignment: Alignment.topLeft,
                                child: Material(
                                  elevation: 4.0,
                                  child: SizedBox(
                                    height: 200,
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemCount: options.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                            final option = options.elementAt(
                                              index,
                                            );
                                            final karyawan = karyawanList
                                                .firstWhere(
                                                  (k) => k.id == option,
                                                  orElse: () => Karyawan(
                                                    id: '',
                                                    name: 'Not Found',
                                                    status: '',
                                                    phone: '',
                                                    address: '',
                                                  ),
                                                );
                                            return ListTile(
                                              title: Text(karyawan.name),
                                              subtitle: Text(karyawan.status),
                                              onTap: () {
                                                onSelected(option);
                                                _searchController.text =
                                                    karyawan.name;
                                                setState(() {
                                                  _selectedKaryawanId =
                                                      karyawan.id;
                                                  _selectedKaryawanName =
                                                      karyawan.name;
                                                  _statusKaryawanController
                                                          .text =
                                                      karyawan.status;
                                                });
                                              },
                                            );
                                          },
                                    ),
                                  ),
                                ),
                              );
                            },
                        fieldViewBuilder:
                            (
                              BuildContext context,
                              TextEditingController textEditingController,
                              FocusNode focusNode,
                              VoidCallback onFieldSubmitted,
                            ) {
                              return TextFormField(
                                controller: textEditingController,
                                focusNode: focusNode,
                                decoration: InputDecoration(
                                  labelText: 'Cari/Pilih Karyawan',
                                  prefixIcon: const Icon(Iconsax.search_normal),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  suffixIcon: _searchController.text.isNotEmpty
                                      ? IconButton(
                                          icon: const Icon(Icons.close),
                                          onPressed: () {
                                            _searchController.clear();
                                            setState(() {
                                              _selectedKaryawanId = null;
                                              _selectedKaryawanName = null;
                                              _statusKaryawanController.clear();
                                            });
                                          },
                                        )
                                      : null,
                                ),
                                validator: (value) {
                                  if (_selectedKaryawanId == null) {
                                    return 'Pilih karyawan';
                                  }
                                  return null;
                                },
                              );
                            },
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _statusKaryawanController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Status Karyawan',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              honorListAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Text('Error: $error'),
                data: (honorList) => DropdownButtonFormField<String>(
                  value: _selectedHonorId,
                  decoration: InputDecoration(
                    labelText: 'Jenis Honor Pekerjaan',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: honorList
                      .map(
                        (honor) => DropdownMenuItem(
                          value: honor.id,
                          child: Text(honor.jenisPekerjaan),
                        ),
                      )
                      .toList(),
                  onChanged: (value) async {
                    if (value == null) return;
                    final repository = ref.read(honorRepositoryProvider);
                    final selectedHonor = await repository.getHonorById(value);
                    if (selectedHonor != null && mounted) {
                      setState(() {
                        _selectedHonorId = value;
                        _selectedJenisPekerjaan = selectedHonor.jenisPekerjaan;
                        _jumlahGajiController.text = NumberFormat(
                          '#,###',
                        ).format(selectedHonor.gaji.toInt());
                        _tipeSatuanController.text = selectedHonor.satuan;
                        _updateTotal();
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Pilih jenis honor';
                    }
                    return null;
                  },
                  isExpanded: true,
                ),
              ),

              const SizedBox(height: 16),
              TextFormField(
                controller: _jumlahHariOrBarangController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: _getQuantityLabel(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '${_getQuantityLabel()} harus diisi';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),
              TextFormField(
                controller: _jumlahGajiController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Jumlah Gaji',
                  prefixText: 'Rp ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) {
                  // Format input saat user mengetik
                  if (value.isNotEmpty) {
                    final numValue =
                        num.tryParse(value.replaceAll(',', '')) ?? 0;
                    _jumlahGajiController.text = NumberFormat(
                      '#,###',
                    ).format(numValue);
                    _jumlahGajiController
                        .selection = TextSelection.fromPosition(
                      TextPosition(offset: _jumlahGajiController.text.length),
                    );
                    _updateTotal();
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jumlah gaji harus diisi';
                  }
                  if (num.tryParse(value.replaceAll(',', '')) == null) {
                    return 'Masukkan angka yang valid';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _totalController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Total',
                  prefixText: 'Rp ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _tipeSatuanController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Tipe Satuan',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Keterangan harus diisi';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
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
