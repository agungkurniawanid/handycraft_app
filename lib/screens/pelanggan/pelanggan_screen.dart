import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handycraft_app/core/providers/pelanggan_provider.dart';
import 'package:iconsax/iconsax.dart';

class PelangganScreen extends ConsumerWidget {
  const PelangganScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PelanggansAsync = ref.watch(PelangganListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Pelanggan'),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.add),
            onPressed: () {
            },
          ),
        ],
      ),
      body: PelanggansAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (Pelanggans) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: Pelanggans.length,
          itemBuilder: (_, index) => Card(
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
                child: const Icon(Iconsax.profile_2user, color: Colors.purple),
              ),
              title: Text(Pelanggans[index].name),
              subtitle: Text(Pelanggans[index].phone),
              trailing: const Icon(Iconsax.arrow_right_3),
              onTap: () {
              },
            ),
          ),
        ),
      ),
    );
  }
}