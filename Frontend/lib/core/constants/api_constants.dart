import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform, kIsWeb;

class ApiConstants {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://127.0.0.1:8000/api';
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8000/api';
    }

    return 'http://127.0.0.1:8000/api';
  }
  static String get register => '$baseUrl/auth/register';
  static String get login => '$baseUrl/auth/login';
  static String get logout => '$baseUrl/auth/logout';
  static String get me => '$baseUrl/auth/me';
  static String get products => '$baseUrl/products';
  static String get categories => '$baseUrl/categories';
  static String get orders => '$baseUrl/orders';
  static String get transactions => '$baseUrl/transactions';
  static String get transactionStats => '$baseUrl/transactions/stats';
  static String get analytics => '$baseUrl/analytics';
  static String get dashboardStats => '$baseUrl/dashboard/stats';
}