import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handycraft_app/core/models/karyawan_model.dart';
import 'package:handycraft_app/core/providers/karyawan_provider.dart';
import 'package:iconsax/iconsax.dart';

class KaryawanDetailScreen extends ConsumerWidget {
  final Karyawan karyawan;

  const KaryawanDetailScreen({super.key, required this.karyawan});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final honorsAsync = ref.watch(honorListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(karyawan.name),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.edit),
            onPressed: () {
              // Edit karyawan
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Iconsax.people,
                  size: 40,
                  color: Colors.red,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Karyawan Information
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildDetailItem(
                      context,
                      icon: Iconsax.user,
                      label: 'Nama Karyawan',
                      value: karyawan.name,
                    ),
                    const Divider(),
                    _buildDetailItem(
                      context,
                      icon: Iconsax.call,
                      label: 'Telepon',
                      value: karyawan.phone,
                    ),
                    const Divider(),
                    _buildDetailItem(
                      context,
                      icon: Iconsax.location,
                      label: 'Alamat',
                      value: karyawan.address,
                    ),
                    const Divider(),
                    _buildDetailItem(
                      context,
                      icon: Iconsax.profile_2user,
                      label: 'Status',
                      value: karyawan.status,
                    ),
                    const Divider(),
                    _buildDetailItem(
                      context,
                      icon: Iconsax.briefcase,
                      label: 'Posisi',
                      value: karyawan.position,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Daftar Honor Section
            Text(
              'Daftar Honor',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            honorsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Error: $err')),
              data: (honors) {
                final karyawanHonors = honors.where(
                  (h) => h.karyawanId == karyawan.id).toList();
                
                if (karyawanHonors.isEmpty) {
                  return const Center(child: Text('Tidak ada data honor'));
                }

                return Column(
                  children: karyawanHonors.map((honor) => _buildHonorCard(honor)).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: Colors.red),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHonorCard(Honor honor) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Iconsax.money, size: 20, color: Colors.orange),
                ),
                const SizedBox(width: 12),
                Text(
                  honor.jenisPekerjaan,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Status: ${honor.statusKaryawan}',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                Text(
                  'Satuan: ${honor.satuan}',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Gaji: Rp${honor.gaji.toStringAsFixed(0).replaceAllMapped(
                    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                    (match) => '${match[1]}.',
                  )}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}