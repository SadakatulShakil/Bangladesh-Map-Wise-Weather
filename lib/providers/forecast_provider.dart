import 'package:flutter/material.dart';

import '../models/forecast_model.dart';
import '../services/api_service.dart';

class ForecastProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool isLoading = false;
  List<Result> forecasts = [];

  Future<void> loadForecasts(int upazilaId) async {
    isLoading = true;
    notifyListeners();
    try {
      final data = await _apiService.fetchData('forecast?upazila_id=$upazilaId');
      final forecastModel = ForecastModel.fromRawJson(data);
      forecasts = forecastModel.result;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading forecasts: $e');
    }finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
