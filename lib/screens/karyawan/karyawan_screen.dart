import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handycraft_app/core/providers/karyawan_provider.dart';
import 'package:iconsax/iconsax.dart';

class KaryawanScreen extends ConsumerWidget {
  const KaryawanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final KaryawansAsync = ref.watch(KaryawanListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Karyawan'),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.add),
            onPressed: () {
            },
          ),
        ],
      ),
      body: KaryawansAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (Karyawans) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: Karyawans.length,
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
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Iconsax.people, color: Colors.red),
              ),
              title: Text(Karyawans[index].name),
              subtitle: Text(Karyawans[index].position),
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