import 'package:flutter/material.dart';

import '../models/shape_model.dart';
import '../services/api_service.dart';

class MapProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  ShapeModel? shapes;
  bool isLoading = false;

  Future<void> loadShapes() async {
    isLoading = true;
    try {
      final data = await _apiService.fetchData('shape');
      shapes = ShapeModel.fromRawJson(data); // Parse entire ShapeModel
    } catch (e) {
      debugPrint('Error loading shapes: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
