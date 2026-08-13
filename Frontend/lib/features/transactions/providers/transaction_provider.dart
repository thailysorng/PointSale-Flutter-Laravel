import 'package:flutter/material.dart';
import 'package:point_sale/core/constants/api_constants.dart';
import 'package:point_sale/core/services/api_service.dart';
import 'package:point_sale/features/transactions/data/models/transaction.dart';

class TransactionProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Transaction> _transactions = [];
  bool _isLoading = false;
  String _error = '';

  bool get isLoading => _isLoading;
  String get error => _error;

  String _searchQuery = '';
  List<Transaction> get transactions {
    if (_searchQuery.isEmpty) {
      return _transactions;
    }

    return _transactions
        .where(
          (t) =>
              (t.transactionNumber ?? t.id)
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              t.description.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  ),
        )
        .toList();
  }

  double _totalSales = 0.0;
  int _totalItems = 0;
  int _transactionCount = 0;

  double get totalSales => _totalSales;
  int get totalItems => _totalItems;
  int get transactionCount => _transactionCount;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> fetchTransactions() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final List data = await _apiService.get(ApiConstants.transactions);
      _transactions = data.map((json) => Transaction.fromJson(json)).toList();
      await fetchStats();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchStats() async {
    try {
      final data = await _apiService.get(ApiConstants.transactionStats);
      _totalSales = _toDouble(data['total_sales']);
      _totalItems = _toInt(data['total_items']);
      _transactionCount = _toInt(data['transaction_count']);
    } catch (e) {
      debugPrint('Error fetching stats: $e');
    }
  }

  int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Future<void> createTransaction({
    required String type,
    required String description,
    required String paymentMethod,
    required double amount,
    String? orderId,
  }) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final transactionData = {
        'type': type,
        'description': description,
        'payment_method': paymentMethod,
        'amount': amount,
        'order_id': orderId,
      };

      final response = await _apiService.post(ApiConstants.transactions, transactionData);
      final newTransaction = Transaction.fromJson(response);
      _transactions.insert(0, newTransaction);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
