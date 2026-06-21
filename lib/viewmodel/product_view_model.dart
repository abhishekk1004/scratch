import 'package:flutter/foundation.dart';
import 'package:scratch/models/product_model.dart';
import 'package:scratch/repo/product_repo.dart';

class ProductViewModel extends ChangeNotifier {
  final ProductRepo _productRepo;

  ProductViewModel({required ProductRepo productRepo}) : _productRepo = productRepo;

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  ProductModel? _product;
  ProductModel? get product => _product;

  List<ProductModel>? _allProducts;
  List<ProductModel>? get allProducts => _allProducts;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setError(String? value) {
    _error = value;
    notifyListeners();
  }

  Future<bool> addProduct(ProductModel model) async {
    setLoading(true);
    try {
      await _productRepo.addProduct(model);
      setError(null);
      return true;
    } catch (e) {
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
    } catch (e) {
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
    } catch (e) {
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
    } catch (e) {
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
    } catch (e) {
      _allProducts = null;
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }
}
