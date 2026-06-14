import 'package:flutter/cupertino.dart';
import 'package:scratch/models/product_model.dart';
import 'package:scratch/repo/product_repo.dart';

class ProductViewModel extends ChangeNotifier {
  final ProductRepo _productRepo;

  ProductViewModel({required ProductRepo productRepo}) : _productRepo = productRepo;

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setError(String? value) {
    _error = value;
    notifyListeners();
  }

  ProductModel? _product;
  ProductModel? get product => _product;

  List<ProductModel>? _allProducts;
  List<ProductModel>? get allProducts => _allProducts;

  List<ProductModel>? _categoryProducts;
  List<ProductModel>? get categoryProducts => _categoryProducts;

  List<ProductModel>? _filterProducts;
  List<ProductModel>? get filterProducts => _filterProducts;

  List<ProductModel>? _searchProducts;
  List<ProductModel>? get searchProducts => _searchProducts;

  Future<bool> addProduct(ProductModel model) async {
    setLoading(true);
    try {
      await _productRepo.addProduct(model);
      setError(null);
      return true;
    } on Exception catch (e) {
      setError(e.toString());
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> deleteProduct(String id) async {
    setLoading(true);
    try {
      await _productRepo.deleteProduct(id);
      setError(null);
      return true;
    } on Exception catch (e) {
      setError(e.toString());
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> updateProduct(ProductModel model) async {
    setLoading(true);
    try {
      await _productRepo.updateProduct(model);
      setError(null);
      return true;
    } on Exception catch (e) {
      setError(e.toString());
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<void> getProductById(String id) async {
    setLoading(true);
    try {
      _product = await _productRepo.getProductById(id);
      setError(null);
    } on Exception catch (e) {
      _product = null;
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  Future<void> getAllProduct() async {
    setLoading(true);
    try {
      _allProducts = await _productRepo.getAllProduct();
      setError(null);
    } on Exception catch (e) {
      _allProducts = null;
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  Future<void> getProductByCategory(String category) async {
    setLoading(true);
    try {
      _categoryProducts = await _productRepo.getProductByCategory(category);
      setError(null);
    } on Exception catch (e) {
      _categoryProducts = null;
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  Future<void> searchProduct(String name) async {
    setLoading(true);
    try {
      _searchProducts = await _productRepo.searchProduct(name);
      setError(null);
    } on Exception catch (e) {
      _searchProducts = null;
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  Future<void> filterProduct(double price) async {
    setLoading(true);
    try {
      _filterProducts = await _productRepo.filterProduct(price);
      setError(null);
    } on Exception catch (e) {
      _filterProducts = null;
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }
}
