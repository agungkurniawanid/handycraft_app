import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handycraft_app/core/models/pelanggan_model.dart';
import 'package:handycraft_app/core/providers/pelanggan_provider.dart';
import 'package:handycraft_app/screens/pelanggan/add_pelanggan_screen.dart';
import 'package:handycraft_app/screens/pelanggan/edit_pelanggan_screen.dart';
import 'package:handycraft_app/screens/pelanggan/pelanggan_detail_screen.dart';
import 'package:iconsax/iconsax.dart';

class PelangganScreen extends ConsumerWidget {
  const PelangganScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Ganti provider ke stream provider
    final pelanggansAsync = ref.watch(pelanggansStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Pelanggan', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Iconsax.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddPelangganScreen(),
              ),
            ),
          ),
        ],
      ),
      body: pelanggansAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Colors.orange),
        ),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (pelanggans) {
          if (pelanggans.isEmpty) {
            return const Center(child: Text('Belum ada data pelanggan.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: pelanggans.length,
            itemBuilder: (_, index) {
              final pelanggan = pelanggans[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Iconsax.profile_2user,
                      color: Colors.purple,
                    ),
                  ),
                  title: Text(pelanggan.name),
                  subtitle: Text(pelanggan.phone),
                  // 2. Ganti trailing icon dengan menu opsi
                  trailing: _buildOptionsMenu(context, ref, pelanggan),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PelangganDetailScreen(pelanggan: pelanggan),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // 3. Widget untuk membuat menu opsi (Edit & Hapus)
  Widget _buildOptionsMenu(
    BuildContext context,
    WidgetRef ref,
    Pelanggan pelanggan,
  ) {
    return PopupMenuButton<String>(
      icon: const Icon(Iconsax.more),
      onSelected: (value) {
        if (value == 'edit') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditPelangganScreen(pelanggan: pelanggan),
            ),
          );
        } else if (value == 'delete') {
          _showDeleteConfirmationDialog(
            context,
            title: 'Hapus Pelanggan',
            content: 'Anda yakin ingin menghapus "${pelanggan.name}"?',
            onConfirm: () async {
              try {
                await ref
                    .read(pelangganRepositoryProvider)
                    .deletePelanggan(pelanggan.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pelanggan berhasil dihapus'),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Gagal menghapus: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          );
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'edit',
          child: ListTile(leading: Icon(Iconsax.edit), title: Text('Edit')),
        ),
        const PopupMenuItem<String>(
          value: 'delete',
          child: ListTile(
            leading: Icon(Iconsax.trash, color: Colors.red),
            title: Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmationDialog(
    BuildContext context, {
    required String title,
    required String content,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Batal'),
            onPressed: () => Navigator.of(dialogContext).pop(),
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
            onPressed: () {
              onConfirm();
              Navigator.of(dialogContext).pop();
            },
          ),
        ],
      ),
    );
  }
}
