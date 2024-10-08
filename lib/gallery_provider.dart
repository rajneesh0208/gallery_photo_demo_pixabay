import 'package:demo_test/service.dart';
import 'package:flutter/material.dart';

class GalleryProvider extends ChangeNotifier {
  final PixabayService _pixabayService = PixabayService();
  List<dynamic> _images = [];
  int _page = 1;
  bool _isLoading = false;

  List<dynamic> get images => _images;

  bool get isLoading => _isLoading;

  Future<void> fetchImages() async {
    _isLoading = true;
    notifyListeners();

    try {
      final fetchedImages = await _pixabayService.fetchImages(_page);
      _images.addAll(fetchedImages);
      _page++;
    } catch (e) {
      print('Error fetching images: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
