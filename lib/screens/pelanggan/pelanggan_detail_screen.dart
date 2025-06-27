import 'package:flutter/material.dart';
import 'package:handycraft_app/core/models/pelanggan_model.dart';
import 'package:iconsax/iconsax.dart';

class PelangganDetailScreen extends StatelessWidget {
  final Pelanggan pelanggan;

  const PelangganDetailScreen({super.key, required this.pelanggan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pelanggan.name),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.edit),
            onPressed: () {
              // Edit pelanggan
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
                  color: Colors.purple.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Iconsax.profile_2user,
                  size: 40,
                  color: Colors.purple,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Pelanggan Information
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
                      label: 'Nama Pelanggan',
                      value: pelanggan.name,
                    ),
                    const Divider(),
                    _buildDetailItem(
                      context,
                      icon: Iconsax.call,
                      label: 'Telepon',
                      value: pelanggan.phone,
                    ),
                    const Divider(),
                    _buildDetailItem(
                      context,
                      icon: Iconsax.location,
                      label: 'Alamat',
                      value: pelanggan.address,
                    ),
                    const Divider(),
                    _buildDetailItem(
                      context,
                      icon: Iconsax.note,
                      label: 'Deskripsi',
                      value: pelanggan.description,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
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
                      // Call pelanggan
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
                      // Message pelanggan
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
          Icon(icon, size: 24, color: Colors.purple),
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