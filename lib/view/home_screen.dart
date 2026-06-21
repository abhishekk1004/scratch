import 'package:scratch/models/product_model.dart';
import 'package:scratch/view/add_product_screen.dart';
import 'package:scratch/viewmodel/product_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductViewModel>().getAllProduct();
    });
  }

  Future<void> _handleDelete(BuildContext context, String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Product"),
        content: const Text("Are you sure you want to delete this product?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final success = await context.read<ProductViewModel>().deleteProduct(id);
      if (mounted && success) {
        context.read<ProductViewModel>().getAllProduct();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Product deleted")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProductViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Products"),
        actions: [
          IconButton(
            onPressed: () => vm.getAllProduct(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ManageProductScreen()),
          );
          if (mounted) context.read<ProductViewModel>().getAllProduct();
        },
        icon: const Icon(Icons.add),
        label: const Text("Add Product"),
      ),
      body: vm.loading && (vm.allProducts == null || vm.allProducts!.isEmpty)
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => vm.getAllProduct(),
              child: _buildBody(vm),
            ),
    );
  }

  Widget _buildBody(ProductViewModel vm) {
    if (vm.allProducts == null || vm.allProducts!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text("No products found", style: TextStyle(fontSize: 18, color: Colors.grey)),
            TextButton(
              onPressed: () => vm.getAllProduct(),
              child: const Text("Tap to retry"),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: vm.allProducts!.length,
      itemBuilder: (context, index) {
        final product = vm.allProducts![index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            contentPadding: const EdgeInsets.all(8),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 60,
                height: 60,
                color: Colors.grey[200],
                child: product.imageUrl != null && product.imageUrl!.isNotEmpty
                    ? Image.network(
                        product.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported),
                      )
                    : const Icon(Icons.image),
              ),
            ),
            title: Text(
              product.name ?? "No Name",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("\$${product.price?.toStringAsFixed(2) ?? "0.00"}",
                    style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold)),
                if (product.description != null)
                  Text(
                    product.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12),
                  ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ManageProductScreen(id: product.id),
                      ),
                    );
                    if (mounted) context.read<ProductViewModel>().getAllProduct();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _handleDelete(context, product.id ?? ""),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
