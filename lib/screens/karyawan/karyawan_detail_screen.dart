import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handycraft_app/core/models/karyawan_model.dart';
import 'package:handycraft_app/core/providers/karyawan_provider.dart';
import 'package:handycraft_app/screens/karyawan/add_karyawan_screen.dart';
import 'package:iconsax/iconsax.dart';

class KaryawanDetailScreen extends ConsumerWidget {
  final Karyawan karyawan;

  const KaryawanDetailScreen({super.key, required this.karyawan});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(karyawan.name),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddKaryawanScreen(karyawan: karyawan),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Iconsax.trash),
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Hapus Karyawan'),
                  content: const Text(
                    'Apakah Anda yakin ingin menghapus karyawan ini?',
                  ),
                  actions: [
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Batal'),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Hapus'),
                    ),
                  ],
                ),
              );

              if (confirmed == true) {
                try {
                  final repository = ref.read(karyawanRepositoryProvider);
                  await repository.deleteKaryawan(karyawan.id);
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Error: $e')));
                  }
                }
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Iconsax.people, size: 40, color: Colors.red),
              ),
            ),
            const SizedBox(height: 24),
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
                  ],
                ),
              ),
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
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(value, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
