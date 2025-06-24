import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handycraft_app/core/providers/product_provider.dart';

class ProductScreen extends ConsumerWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: productsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (products) => ListView.builder(
          itemCount: products.length,
          itemBuilder: (_, index) => ListTile(
            title: Text(products[index].name),
            subtitle: Text('\$${products[index].price}'),
          ),
        ),
      ),
    );
  }
}
