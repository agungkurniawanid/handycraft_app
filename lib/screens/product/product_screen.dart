import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handycraft_app/core/models/product_model.dart';
import 'package:handycraft_app/core/providers/product_provider.dart';
import 'package:handycraft_app/screens/product/add_bahan_screen.dart';
import 'package:handycraft_app/screens/product/add_product_screen.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import 'edit_product_screen.dart';

class ProductScreen extends ConsumerWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final materialsAsync = ref.watch(rawMaterialsStreamProvider);
    final productsAsync = ref.watch(productsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Produk & Bahan Baku', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              context,
              title: 'Data Bahan Baku',
              onAddPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddBahanScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildMaterialList(materialsAsync, ref, context),
            const SizedBox(height: 24),
            _buildSectionHeader(
              context,
              title: 'Data Produk/Jasa',
              onAddPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddProductScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildProductList(productsAsync, ref, context),
          ],
        ),
      ),
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
      builder: (BuildContext dialogContext) {
        return AlertDialog(
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
        );
      },
    );
  }

  Widget _buildOptionsMenu(
    BuildContext context, {
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    return PopupMenuButton<String>(
      icon: const Icon(Iconsax.more),
      onSelected: (value) {
        if (value == 'edit') {
          onEdit();
        } else if (value == 'delete') {
          onDelete();
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

  Widget _buildMaterialList(
    AsyncValue<List<RawMaterialModel>> asyncMaterials,
    WidgetRef ref,
    BuildContext context,
  ) {
    return asyncMaterials.when(
      loading: () =>
          const Center(child: CircularProgressIndicator(color: Colors.orange)),
      error: (err, _) => Center(child: Text('Error: $err')),
      data: (materials) {
        if (materials.isEmpty)
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text('Belum ada data bahan baku.'),
            ),
          );
        return Column(
          children: materials
              .map((material) => _buildMaterialCard(material, ref, context))
              .toList(),
        );
      },
    );
  }

  Widget _buildMaterialCard(
    RawMaterialModel material,
    WidgetRef ref,
    BuildContext context,
  ) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Iconsax.box_1, color: Colors.blue),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    material.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Harga: ${_formatCurrency(material.price)} / ${material.unit}',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            _buildOptionsMenu(
              context,
              onEdit: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditItemScreen(
                      item: material,
                      type: ItemType.rawMaterial,
                    ),
                  ),
                );
              },
              onDelete: () {
                _showDeleteConfirmationDialog(
                  context,
                  title: 'Hapus Bahan Baku',
                  content: 'Anda yakin ingin menghapus "${material.name}"?',
                  onConfirm: () async {
                    try {
                      await ref
                          .read(productRepositoryProvider)
                          .deleteRawMaterial(material.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Bahan baku berhasil dihapus'),
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
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductList(
    AsyncValue<List<Product>> asyncProducts,
    WidgetRef ref,
    BuildContext context,
  ) {
    return asyncProducts.when(
      loading: () =>
          const Center(child: CircularProgressIndicator(color: Colors.orange)),
      error: (err, _) => Center(child: Text('Error: $err')),
      data: (products) {
        if (products.isEmpty)
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text('Belum ada data produk.'),
            ),
          );
        return Column(
          children: products
              .map((product) => _buildProductCard(product, ref, context))
              .toList(),
        );
      },
    );
  }

  Widget _buildProductCard(
    Product product,
    WidgetRef ref,
    BuildContext context,
  ) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Iconsax.shop, color: Colors.green),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Harga: ${_formatCurrency(product.price)} / ${product.unit}',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            _buildOptionsMenu(
              context,
              onEdit: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EditItemScreen(item: product, type: ItemType.product),
                  ),
                );
              },
              onDelete: () {
                _showDeleteConfirmationDialog(
                  context,
                  title: 'Hapus Produk',
                  content: 'Anda yakin ingin menghapus "${product.name}"?',
                  onConfirm: () async {
                    try {
                      await ref
                          .read(productRepositoryProvider)
                          .deleteProduct(product.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Produk berhasil dihapus'),
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
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatCurrency(double amount) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatCurrency.format(amount);
  }
}
