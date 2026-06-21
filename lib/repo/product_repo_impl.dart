import 'package:scratch/models/product_model.dart';
import 'package:scratch/repo/product_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductRepoImpl implements ProductRepo {
  final collection = FirebaseFirestore.instance.collection("product");

  @override
  Future<void> addProduct(ProductModel model) async {
    final ref = collection.doc();
    model.id = ref.id;
    await ref.set(model.toMap());
  }

  @override
  Future<void> deleteProduct(String id) async {
    await collection.doc(id).delete();
  }

  @override
  Future<List<ProductModel>> filterProduct(double price) async {
    final querySnapshot = await collection.where('price', isLessThanOrEqualTo: price).get();
    return querySnapshot.docs.map((doc) {
      final product = ProductModel.fromMap(doc.data());
      product.id = doc.id;
      return product;
    }).toList();
  }

  @override
  Future<List<ProductModel>> getAllProduct() async {
    final querySnapshot = await collection.get();
    return querySnapshot.docs.map((doc) {
      final product = ProductModel.fromMap(doc.data());
      product.id = doc.id;
      return product;
    }).toList();
  }

  @override
  Future<List<ProductModel>> getProductByCategory(String categoryId) async {
    final querySnapshot = await collection.where('categoryId', isEqualTo: categoryId).get();
    return querySnapshot.docs.map((doc) {
      final product = ProductModel.fromMap(doc.data());
      product.id = doc.id;
      return product;
    }).toList();
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    final doc = await collection.doc(id).get();
    if (!doc.exists) {
      throw Exception("Product not found");
    }
    final product = ProductModel.fromMap(doc.data()!);
    product.id = doc.id;
    return product;
  }

  @override
  Future<List<ProductModel>> searchProduct(String name) async {
    final querySnapshot = await collection
        .where('name', isGreaterThanOrEqualTo: name)
        .where('name', isLessThanOrEqualTo: '$name\uf8ff')
        .get();
    return querySnapshot.docs.map((doc) {
      final product = ProductModel.fromMap(doc.data());
      product.id = doc.id;
      return product;
    }).toList();
  }

  @override
  Future<void> updateProduct(ProductModel model) async {
    if (model.id == null || model.id!.isEmpty) {
      throw Exception("Product ID is missing");
    }
    await collection.doc(model.id).update(model.toMap());
  }
}
