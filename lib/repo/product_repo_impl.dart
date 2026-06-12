import 'package:flutter/foundation.dart';
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
    final data = await collection.where('price',isLessThanOrEqualTo: price).get();
    //return data.docs.map((doc) => ProductModel.fromMap(doc.data())).toList();

    List<ProductModel> products=[];

    for(int i=0;i<data.docs.length;i++){
      products.add(ProductModel.fromMap(data.docs[i].data()));
    }
    return products;
  }

  @override
  Future<List<ProductModel>> getAllProduct() async {
    final data = await collection.get();
    //return data.docs.map((doc) => ProductModel.fromMap(doc.data())).toList();

    List<ProductModel> products=[];

    for(int i=0;i<data.docs.length;i++){
      products.add(ProductModel.fromMap(data.docs[i].data()));
    }
    return products;
  }

  @override
  Future<List<ProductModel>> getProductByCategory(String categoryId) async {
    final data = await collection.where('categoryId',isEqualTo: categoryId).get();
    //return data.docs.map((doc) => ProductModel.fromMap(doc.data())).toList();

    List<ProductModel> products=[];

    for(int i=0;i<data.docs.length;i++){
      products.add(ProductModel.fromMap(data.docs[i].data()));
    }
    return products;
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    final data = await collection.doc(id).get();
    final products= data.data();


    if(products==null){
      throw Exception("Product 404");
    }
    return ProductModel.fromMap(products);
  }

  @override
  Future<List<ProductModel>> searchProduct(String name) async {
    final querySnapshot = await collection
        .where('name', isGreaterThanOrEqualTo: name)
        .where('name', isLessThanOrEqualTo: '$name\uf8ff')
        .get();
    return querySnapshot.docs.map((doc) => ProductModel.fromMap(doc.data())).toList();
  }

  @override
  Future<void> updateProduct(ProductModel model) async {
    await collection.doc(model.id).update(model.toMap());
  }
}
