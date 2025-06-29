import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handycraft_app/core/models/karyawan_model.dart';
import 'package:handycraft_app/core/providers/karyawan_provider.dart';
import 'package:handycraft_app/screens/karyawan/add_honor_screen.dart';
import 'package:handycraft_app/screens/karyawan/add_karyawan_screen.dart';
import 'package:handycraft_app/screens/karyawan/karyawan_detail_screen.dart';
import 'package:iconsax/iconsax.dart';

class KaryawanScreen extends ConsumerWidget {
  const KaryawanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final karyawansAsync = ref.watch(karyawanListProvider);
    final honorsAsync = ref.watch(honorListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Data Karyawan'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Data Karyawan Section
            _buildSectionHeader(
              context,
              title: 'Data Karyawan',
              onAddPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddKaryawanScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            karyawansAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Error: $err')),
              data: (karyawans) => Column(
                children: karyawans
                    .map((karyawan) => _buildKaryawanCard(context, karyawan))
                    .toList(),
              ),
            ),
            const SizedBox(height: 24),

            // Daftar Honor Section
            _buildSectionHeader(
              context,
              title: 'Daftar Honor',
              onAddPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddHonorScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            honorsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Error: $err')),
              data: (honors) => Column(
                children: honors
                    .map((honor) => _buildHonorCard(honor))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    required VoidCallback onAddPressed,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Iconsax.add, color: Colors.white, size: 20),
          ),
          onPressed: onAddPressed,
        ),
      ],
    );
  }

  Widget _buildKaryawanCard(BuildContext context, Karyawan karyawan) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Iconsax.people, color: Colors.red),
        ),
        title: Text(karyawan.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text(karyawan.phone), Text('Status: ${karyawan.status}')],
        ),
        trailing: const Icon(Iconsax.arrow_right_3),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => KaryawanDetailScreen(karyawan: karyawan),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHonorCard(Honor honor) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                  child: const Icon(
                    Iconsax.money,
                    size: 20,
                    color: Colors.orange,
                  ),
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
              'Gaji: Rp${honor.gaji.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')}',
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
