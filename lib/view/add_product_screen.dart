import 'dart:io';

import 'package:scratch/models/product_model.dart';
import 'package:scratch/viewmodel/image_view_model.dart';
import 'package:scratch/viewmodel/product_view_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

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

  final picker = ImagePicker();
  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final imageVm = context.read<ImageViewModel>();
      final productVm = context.read<ProductViewModel>();

      if (widget.id != null) {
        await productVm.getProductById(widget.id!);
        if (!mounted) return;
        final product = productVm.product;
        if (product != null) {
          nameController.text = product.name ?? "";
          priceController.text = product.price?.toString() ?? "";
          descController.text = product.description ?? "";
          imageVm.setImageUrl(product.imageUrl);
        }
      } else {
        imageVm.setImageUrl(null);
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    descController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    setState(() {
      _pickedImage = File(picked.path);
    });

    if (!mounted) return;
    await context.read<ImageViewModel>().uploadImage(picked.path);
  }

  Widget _buildImagePreview(ImageViewModel imageVm) {
    if (imageVm.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_pickedImage != null) {
      return Image.file(_pickedImage!, fit: BoxFit.cover);
    }
    if (imageVm.imageUrl != null && imageVm.imageUrl!.isNotEmpty) {
      return Image.network(imageVm.imageUrl!, fit: BoxFit.cover);
    }
    return const Icon(Icons.add_a_photo, size: 40);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProductViewModel>();
    final imageVm = context.watch<ImageViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id == null ? "Add Product" : "Update Product"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: imageVm.loading ? null : _pickImage,
              child: Container(
                height: 150,
                width: 150,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _buildImagePreview(imageVm),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Product Name"),
            ),
            TextFormField(
              controller: priceController,
              decoration: const InputDecoration(labelText: "Price"),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: descController,
              decoration: const InputDecoration(labelText: "Description"),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: (vm.loading || imageVm.loading)
                  ? null
                  : () async {
                      final messenger = ScaffoldMessenger.of(context);
                      final navigator = Navigator.of(context);

                      if (imageVm.loading) {
                        messenger.showSnackBar(
                          const SnackBar(content: Text("Please wait, image is uploading")),
                        );
                        return;
                      }

                      final model = ProductModel(
                        id: widget.id ?? "",
                        name: nameController.text,
                        price: double.tryParse(priceController.text) ?? 0.0,
                        description: descController.text,
                        imageUrl: imageVm.imageUrl,
                      );

                      bool success;
                      if (widget.id == null) {
                        success = await vm.addProduct(model);
                      } else {
                        success = await vm.updateProduct(model);
                      }

                      if (!mounted) return;

                      if (success) {
                        navigator.pop();
                      } else {
                        messenger.showSnackBar(
                          SnackBar(content: Text(vm.error ?? "An error occurred")),
                        );
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
