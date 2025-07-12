import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handycraft_app/core/providers/supplier_provider.dart';
import 'package:handycraft_app/screens/supplier/add_supplier_screen.dart';
import 'package:handycraft_app/screens/supplier/supplier_detail_screen.dart';
import 'package:iconsax/iconsax.dart';

class SupplierScreen extends ConsumerWidget {
  const SupplierScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suppliersAsync = ref.watch(suppliersStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Supplier'),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddSupplierScreen()),
              );
            },
          ),
        ],
      ),
      body: suppliersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (suppliers) {
          if (suppliers.isEmpty) {
            return _buildEmptySupplierState(context);
          }
          return ListView.builder(
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
          );
        },
      ),
    );
  }

  Widget _buildEmptySupplierState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Iconsax.shop_remove,
                size: 60,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Belum Ada Data Supplier',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tambahkan supplier baru untuk memulai',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade500,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Iconsax.add),
                label: const Text('Tambah Supplier Baru'),
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
                        builder: (context) => const AddSupplierScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}