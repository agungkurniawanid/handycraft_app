import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handycraft_app/core/models/honor_model.dart';
import 'package:handycraft_app/core/models/karyawan_model.dart';
import 'package:handycraft_app/core/providers/honor_provider.dart';
import 'package:handycraft_app/core/providers/karyawan_provider.dart';
import 'package:handycraft_app/screens/karyawan/add_honor_screen.dart';
import 'package:handycraft_app/screens/karyawan/add_karyawan_screen.dart';
import 'package:handycraft_app/screens/karyawan/karyawan_detail_screen.dart';
import 'package:iconsax/iconsax.dart';

class KaryawanScreen extends ConsumerWidget {
  const KaryawanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final karyawanAsync = ref.watch(karyawanStreamProvider);
    final honorAsync = ref.watch(honorStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Data Karyawan',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Data Karyawan Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: _buildSectionHeader(
                context,
                title: 'Daftar Karyawan',
                onAddPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddKaryawanScreen(),
                    ),
                  );
                },
              ),
            ),
            karyawanAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: Colors.orange),
              ),
              error: (err, _) => Center(child: Text('Error: $err')),
              data: (karyawans) {
                if (karyawans.isEmpty) {
                  return _buildEmptyKaryawanState(context);
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: karyawans
                        .map(
                          (karyawan) => _buildKaryawanCard(context, karyawan),
                        )
                        .toList(),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Daftar Honor Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: _buildSectionHeader(
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
            ),
            honorAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: Colors.orange),
              ),
              error: (err, _) => Center(child: Text('Error: $err')),
              data: (honors) {
                if (honors.isEmpty) {
                  return _buildEmptyHonorState(context);
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: honors
                        .map((honor) => _buildHonorCard(context, honor, ref))
                        .toList(),
                  ),
                );
              },
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
              color: Colors.orange,
              shape: BoxShape.circle,
            ),
            child: const Icon(Iconsax.add, color: Colors.white, size: 20),
          ),
          onPressed: onAddPressed,
        ),
      ],
    );
  }

  Widget _buildEmptyKaryawanState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: const Icon(Iconsax.people, size: 40, color: Colors.red),
            ),
            const SizedBox(height: 15),
            Text(
              'Belum Ada Data Karyawan',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tambahkan karyawan baru untuk memulai',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Iconsax.add),
                  label: const Text('Tambah Karyawan Baru'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddKaryawanScreen(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyHonorState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: const Icon(Iconsax.money, size: 40, color: Colors.orange),
            ),
            const SizedBox(height: 15),
            Text(
              'Belum Ada Daftar Honor',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tambahkan daftar honor baru untuk memulai',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Iconsax.add),
                  label: const Text('Tambah Honor Baru'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddHonorScreen(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
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

  Widget _buildHonorCard(BuildContext context, Honor honor, WidgetRef ref) {
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
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
                      Expanded(
                        child: Text(
                          honor.jenisPekerjaan,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton(
                  icon: const Icon(Iconsax.more, size: 20),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: const Row(
                        children: [
                          Icon(Iconsax.edit, size: 20),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddHonorScreen(honor: honor),
                          ),
                        );
                      },
                    ),
                    PopupMenuItem(
                      child: const Row(
                        children: [
                          Icon(Iconsax.trash, size: 20, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Hapus', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                      onTap: () async {
                        await Future.delayed(Duration.zero);
                        _showDeleteDialog(context, honor.id, ref);
                      },
                    ),
                  ],
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

  void _showDeleteDialog(BuildContext context, String honorId, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Honor'),
        content: const Text('Apakah Anda yakin ingin menghapus honor ini?'),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(context);
              try {
                final repository = ref.read(honorRepositoryProvider);
                await repository.deleteHonor(honorId);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Honor berhasil dihapus'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Gagal menghapus honor: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
