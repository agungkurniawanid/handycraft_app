import 'package:flutter/material.dart';
import 'package:handycraft_app/core/models/pelanggan_model.dart';
import 'package:handycraft_app/screens/pelanggan/edit_pelanggan_screen.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

class PelangganDetailScreen extends StatelessWidget {
  final Pelanggan pelanggan;

  const PelangganDetailScreen({super.key, required this.pelanggan});

  Future<void> _launchWhatsApp(BuildContext context, String phoneNumber) async {
    String formattedPhoneNumber = phoneNumber.trim();
    if (formattedPhoneNumber.startsWith('0')) {
      formattedPhoneNumber = '62${formattedPhoneNumber.substring(1)}';
    }
    formattedPhoneNumber = formattedPhoneNumber.replaceAll(RegExp(r'[^0-9]'), '');

    final Uri whatsappUrl = Uri.parse('https://wa.me/$formattedPhoneNumber');

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tidak bisa membuka WhatsApp untuk nomor $phoneNumber')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pelanggan.name),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.edit),
            onPressed: () {
              // Arahkan ke halaman edit
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditPelangganScreen(pelanggan: pelanggan),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon (tidak berubah)
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.purple.withOpacity(0.1), shape: BoxShape.circle),
                child: const Icon(Iconsax.profile_2user, size: 40, color: Colors.purple),
              ),
            ),
            const SizedBox(height: 24),

            // Pelanggan Information Card (tidak berubah)
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildDetailItem(context, icon: Iconsax.user, label: 'Nama Pelanggan', value: pelanggan.name),
                    const Divider(),
                    _buildDetailItem(context, icon: Iconsax.call, label: 'Telepon', value: pelanggan.phone),
                    const Divider(),
                    _buildDetailItem(context, icon: Iconsax.location, label: 'Alamat', value: pelanggan.address),
                    const Divider(),
                    _buildDetailItem(context, icon: Iconsax.note, label: 'Deskripsi', value: pelanggan.description),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 3. Modifikasi Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Iconsax.message),
                label: const Text('Hubungi via WhatsApp'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  // Panggil fungsi untuk membuka WhatsApp dengan nomor dari database
                  _launchWhatsApp(context, pelanggan.phone);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(BuildContext context, {required IconData icon, required String label, required String value}) {
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
                Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
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
