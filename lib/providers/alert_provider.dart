import 'package:flutter/material.dart';

import '../models/alert_model.dart';
import '../services/api_service.dart';


class AlertProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Result> alerts = [];
  bool isLoading = false;

  Future<void> loadAlerts() async {
    isLoading = true;
    try {
      final data = await _apiService.fetchData('alert');
      final alertModel = AlertModel.fromRawJson(data);
      alerts = alertModel.result;
    } catch (e) {
      debugPrint('Error loading alert data: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
