import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handycraft_app/core/providers/supplier_provider.dart';
import 'package:handycraft_app/screens/supplier/supplier_detail_screen.dart';
import 'package:iconsax/iconsax.dart';

class SupplierScreen extends ConsumerWidget {
  const SupplierScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suppliersAsync = ref.watch(supplierListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Supplier'),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.add),
            onPressed: () {
              // Add new supplier
            },
          ),
        ],
      ),
      body: suppliersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (suppliers) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: suppliers.length,
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
                  color: Colors.orange.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Iconsax.shop, color: Colors.orange),
              ),
              title: Text(suppliers[index].name),
              subtitle: Text(suppliers[index].phone),
              trailing: const Icon(Iconsax.arrow_right_3),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SupplierDetailScreen(
                      supplier: suppliers[index],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}