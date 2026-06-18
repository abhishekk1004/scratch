import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scratch/models/product_model.dart';
import 'package:scratch/viewmodel/product_view_model.dart';

class ManageProductScreen extends StatefulWidget {
  final String? id;
  const ManageProductScreen({super.key, this.id});

  @override
  State<ManageProductScreen> createState() => _ManageProductScreenState();
}

class _ManageProductScreenState extends State<ManageProductScreen> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProductViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id == null ? "Add Product" : "Update Product"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            TextFormField(
              controller: priceController,
              decoration: const InputDecoration(labelText: "Price"),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: descController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: vm.loading
                  ? null
                  : () async {
                      if (widget.id == null) {
                        // Add
                        final model = ProductModel(
                          id: "",
                          name: nameController.text,
                          price: double.tryParse(priceController.text) ?? 0.0,
                          description: descController.text,
                        );
                        final success = await vm.addProduct(model);
                        if (mounted) {
                          if (success) {
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(vm.error ?? "Failed to add product")),
                            );
                          }
                        }
                      } else {
                        // Update
                      }
                    },
              child: vm.loading
                  ? const CircularProgressIndicator()
                  : Text(widget.id == null ? "Add Product" : "Update Product"),
            ),
          ],
        ),
      ),
    );
  }
}
