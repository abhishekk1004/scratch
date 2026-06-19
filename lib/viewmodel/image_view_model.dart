import 'package:scratch/repo/image_repo.dart';
import 'package:flutter/material.dart';

class ImageViewModel extends ChangeNotifier {
  final ImageRepo _imageRepo;

  ImageViewModel({required ImageRepo imageRepo}) : _imageRepo = imageRepo;

  bool _loading = false;

  bool get loading => _loading;

  String? _error;

  String? get error => _error;

  String? _imageUrl;

  String? get imageUrl => _imageUrl;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  setError(String? value) {
    _error = value;
    notifyListeners();
  }

  setImageUrl(String? value) {
    _imageUrl = value;
    notifyListeners();
  }

  Future<void> uploadImage(String filePath) async {
    setLoading(true);
    setError(null);
    try {
      _imageUrl = await _imageRepo.uploadImage(filePath);
    } on Exception catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }
}