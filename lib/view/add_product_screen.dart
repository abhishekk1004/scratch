import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scratch/models/product_model.dart';
import 'package:scratch/viewmodels/product_view_model.dart';

class ManageProductScreen extends StatefulWidget {
  const ManageProductScreen({super.key});

  @override
  State<ManageProductScreen> createState() => _ManageProductScreenState();
}

class _ManageProductScreenState extends State<ManageProductScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productViewModel = context.watch<ProductViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Product"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Product Name",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter product name";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: "Price",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter price";
                    }
                    if (double.tryParse(value) == null) {
                      return "Please enter a valid number";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _categoryController,
                  decoration: const InputDecoration(
                    labelText: "Category",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter category";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: productViewModel.loading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              final product = ProductModel(
                                name: _nameController.text,
                                price: double.parse(_priceController.text),
                                category: _categoryController.text,
                                description: _descriptionController.text,
                              );

                              final success = await productViewModel.addProduct(product);

                              if (mounted) {
                                if (success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Product saved successfully!")),
                                  );
                                  Navigator.pop(context);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(productViewModel.error ?? "Failed to save product")),
                                  );
                                }
                              }
                            }
                          },
                    child: productViewModel.loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Save Product",
                            style: TextStyle(fontSize: 18),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
