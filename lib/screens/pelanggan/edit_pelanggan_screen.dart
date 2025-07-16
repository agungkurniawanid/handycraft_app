import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handycraft_app/core/models/pelanggan_model.dart';
import 'package:handycraft_app/core/providers/pelanggan_provider.dart';
import 'package:iconsax/iconsax.dart';

class EditPelangganScreen extends ConsumerStatefulWidget {
  final Pelanggan pelanggan;
  const EditPelangganScreen({super.key, required this.pelanggan});

  @override
  ConsumerState<EditPelangganScreen> createState() => _EditPelangganScreenState();
}

class _EditPelangganScreenState extends ConsumerState<EditPelangganScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _descriptionController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Isi controller dengan data pelanggan yang ada
    _nameController = TextEditingController(text: widget.pelanggan.name);
    _phoneController = TextEditingController(text: widget.pelanggan.phone);
    _addressController = TextEditingController(text: widget.pelanggan.address);
    _descriptionController = TextEditingController(text: widget.pelanggan.description);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _updatePelanggan() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final updatedPelanggan = Pelanggan(
      id: widget.pelanggan.id, // Gunakan ID yang sudah ada
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      description: _descriptionController.text.trim(),
    );

    try {
      await ref.read(pelangganRepositoryProvider).updatePelanggan(updatedPelanggan);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pelanggan berhasil diperbarui!'), backgroundColor: Colors.green));
        Navigator.of(context).pop(); // Kembali ke halaman detail
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
      appBar: AppBar(title: const Text('Edit Pelanggan'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: 'Nama Pelanggan', border: OutlineInputBorder(), prefixIcon: Icon(Iconsax.profile_2user)), validator: (v) => v == null || v.isEmpty ? 'Nama tidak boleh kosong' : null),
              const SizedBox(height: 16),
              TextFormField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Nomor Telepon', border: OutlineInputBorder(), prefixIcon: Icon(Iconsax.call), hintText: '08123456789'), keyboardType: TextInputType.phone, validator: (v) { if (v == null || v.isEmpty) return 'Nomor telepon tidak boleh kosong'; if (!RegExp(r'^[0-9]+$').hasMatch(v)) return 'Masukkan nomor yang valid'; return null; }),
              const SizedBox(height: 16),
              TextFormField(controller: _addressController, decoration: const InputDecoration(labelText: 'Alamat Lengkap', border: OutlineInputBorder(), prefixIcon: Icon(Iconsax.location), hintText: 'Jl. Contoh No. 123, Kota'), maxLines: 3, validator: (v) => v == null || v.isEmpty ? 'Alamat tidak boleh kosong' : null),
              const SizedBox(height: 16),
              TextFormField(controller: _descriptionController, decoration: const InputDecoration(labelText: 'Keterangan (Pesanan/Kebutuhan)', border: OutlineInputBorder(), prefixIcon: Icon(Iconsax.note_text), hintText: 'Contoh: Pesan meja makan dari kayu jati'), maxLines: 2, validator: (v) => v == null || v.isEmpty ? 'Keterangan tidak boleh kosong' : null),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _updatePelanggan,
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
