import 'package:flutter/material.dart';
import 'package:point_sale/core/constants/api_constants.dart';
import 'package:point_sale/core/services/api_service.dart';

class AnalyticsProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  Map<String, dynamic>? _data;
  bool _isLoading = false;
  String _error = '';
  String _period = 'week';

  bool get isLoading => _isLoading;
  String get error => _error;
  String get period => _period;
  Map<String, dynamic>? get data => _data;

  void setPeriod(String period) {
    _period = period.toLowerCase();
    fetchAnalytics();
  }

  Future<void> fetchAnalytics() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final response = await _apiService.get('${ApiConstants.analytics}?period=$_period');
      _data = response;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
