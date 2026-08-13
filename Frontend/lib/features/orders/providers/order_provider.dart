import 'package:flutter/material.dart';
import 'package:point_sale/core/constants/api_constants.dart';
import 'package:point_sale/core/services/api_service.dart';
import 'package:point_sale/features/orders/data/models/order.dart';

class OrderProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<OrderModel> _orders = [];
  bool _isLoading = false;
  String _error = '';

  bool get isLoading => _isLoading;
  String get error => _error;

  String _searchQuery = '';
  String _selectedFilter = 'All';

  String get selectedFilter => _selectedFilter;

  List<OrderModel> get orders {
    List<OrderModel> filteredOrders = _orders;

    if (_selectedFilter != 'All') {
      filteredOrders = filteredOrders
          .where((o) => o.status == _selectedFilter.toLowerCase())
          .toList();
    }

    if (_searchQuery.isNotEmpty) {
      filteredOrders = filteredOrders
          .where(
            (o) =>
                o.id.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                o.customerName.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ),
          )
          .toList();
    }

    return filteredOrders;
  }

  int get totalOrdersCount => _orders.length;

  int get pendingOrdersCount =>
      _orders.where((o) => o.status == 'pending').length;

  int get completedOrdersCount =>
      _orders.where((o) => o.status == 'completed').length;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  Future<void> fetchOrders() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final List data = await _apiService.get(ApiConstants.orders);
      _orders = data.map((json) => OrderModel.fromJson(json)).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<OrderModel?> createOrder({
    required List<Map<String, dynamic>> items,
    required double subtotal,
    required double tax,
    required double total,
    required String paymentMethod,
    String? customerName,
  }) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final orderData = {
        'items': items,
        'subtotal': subtotal,
        'tax': tax,
        'total': total,
        'payment_method': paymentMethod,
        'customer_name': customerName ?? 'Customer',
        'status': 'pending',
      };

      final response = await _apiService.post(ApiConstants.orders, orderData);
      final newOrder = OrderModel.fromJson(response);
      _orders.insert(0, newOrder);
      return newOrder;
    } catch (e) {
      _error = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> markAsPaid(String orderId) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final response = await _apiService.put(
        '${ApiConstants.orders}/$orderId/status',
        {'status': 'completed'},
      );
      
      final index = _orders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        _orders[index] = OrderModel.fromJson(response['order']);
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateOrderStatus(String orderId, String newStatus) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      final order = _orders[index];
      _orders[index] = OrderModel(
        id: order.id,
        orderNumber: order.orderNumber,
        customerName: order.customerName,
        status: newStatus,
        itemCount: order.itemCount,
        time: order.time,
        date: order.date,
        subtotal: order.subtotal,
        tax: order.tax,
        total: order.total,
        paymentMethod: order.paymentMethod,
      );
      notifyListeners();
    }
  }
}
