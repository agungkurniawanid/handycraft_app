import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handycraft_app/core/models/supplier_model.dart';
import 'package:handycraft_app/core/providers/supplier_provider.dart' show supplierRepositoryProvider;
import 'package:handycraft_app/screens/supplier/add_supplier_screen.dart';
import 'package:iconsax/iconsax.dart';

class SupplierDetailScreen extends ConsumerWidget {
  final Supplier supplier;

  const SupplierDetailScreen({super.key, required this.supplier});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(supplier.name),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddSupplierScreen(supplier: supplier),
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
                  title: const Text('Hapus Supplier'),
                  content: const Text('Apakah Anda yakin ingin menghapus supplier ini?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Hapus', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );

              if (confirmed == true) {
                try {
                  final repository = ref.read(supplierRepositoryProvider);
                  await repository.deleteSupplier(supplier.id);
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
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
                  color: Colors.orange.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Iconsax.shop,
                  size: 40,
                  color: Colors.orange,
                ),
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
                      label: 'Nama Supplier',
                      value: supplier.name,
                    ),
                    const Divider(),
                    _buildDetailItem(
                      context,
                      icon: Iconsax.call,
                      label: 'Telepon',
                      value: supplier.phone,
                    ),
                    const Divider(),
                    _buildDetailItem(
                      context,
                      icon: Iconsax.location,
                      label: 'Alamat',
                      value: supplier.address,
                    ),
                    const Divider(),
                    _buildDetailItem(
                      context,
                      icon: Iconsax.note,
                      label: 'Deskripsi',
                      value: supplier.description,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Iconsax.call),
                    label: const Text('Hubungi'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      // Call supplier
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Iconsax.message),
                    label: const Text('Pesan'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      // Message supplier
                    },
                  ),
                ),
              ],
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
          Icon(icon, size: 24, color: Colors.orange),
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
}