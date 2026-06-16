import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:scratch/models/product_model.dart';
import 'package:scratch/viewmodel/product_view_model.dart';

class ManageProductScreen extends StatefulWidget {
  const ManageProductScreen({super.key});

  @override
  State<ManageProductScreen> createState() => _ManageProductScreenState();
}

class _ManageProductScreenState extends State<ManageProductScreen> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descController = TextEditingController();
  final categoryController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    descController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProductViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text("Add Product")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Product Name"),
                  validator: (value) => value == null || value.isEmpty ? "Required" : null,
                ),
                TextFormField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: "Price"),
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || double.tryParse(value) == null ? "Enter a valid price" : null,
                ),
                TextFormField(
                  controller: categoryController,
                  decoration: const InputDecoration(labelText: "Category"),
                  validator: (value) => value == null || value.isEmpty ? "Required" : null,
                ),
                TextFormField(
                  controller: descController,
                  decoration: const InputDecoration(labelText: "Description"),
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: vm.loading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            final model = ProductModel(
                              id: "",
                              name: nameController.text,
                              price: double.parse(priceController.text),
                              description: descController.text,
                              category: categoryController.text,
                            );
                            final success = await vm.addProduct(model);
                            
                            if (!context.mounted) return;
                            
                            if (success) {
                              Navigator.pop(context);
                            } else {
                              Fluttertoast.showToast(msg: vm.error.toString());
                            }
                          }
                        },
                  child: vm.loading
                      ? const CircularProgressIndicator()
                      : const Text("Add Product"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
