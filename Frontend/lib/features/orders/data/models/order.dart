import 'package:point_sale/features/transactions/data/models/transaction.dart';

class OrderItem {
  final int? productId;
  final String name;
  final int quantity;
  final double price;
  final String? imageUrl;

  OrderItem({
    this.productId,
    required this.name,
    required this.quantity,
    required this.price,
    this.imageUrl,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['product_id'],
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? 0,
      price: _toDouble(json['price']),
      imageUrl: json['product'] != null ? json['product']['image_url'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'name': name,
      'quantity': quantity,
      'price': price,
      'image_url': imageUrl,
    };
  }
}

class OrderModel {
  final String id;
  final String orderNumber;
  final String customerName;
  final String status; // 'pending', 'completed', 'cancelled'
  final int itemCount;
  final String time;
  final String date;
  final double subtotal;
  final double tax;
  final double total;
  final String paymentMethod;
  final List<OrderItem> items;
  final List<Transaction> transactions;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.customerName,
    required this.status,
    required this.itemCount,
    required this.time,
    this.date = '',
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.paymentMethod,
    this.items = const [],
    this.transactions = const [],
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    var itemsList = <OrderItem>[];
    if (json['items'] != null) {
      itemsList = (json['items'] as List)
          .map((i) => OrderItem.fromJson(i))
          .toList();
    }

    var transactionsList = <Transaction>[];
    if (json['transactions'] != null) {
      transactionsList = (json['transactions'] as List)
          .map((t) => Transaction.fromJson(t))
          .toList();
    }

    final id = json['id']?.toString() ?? '';
    return OrderModel(
      id: id,
      orderNumber: json['order_number']?.toString() ?? id,
      customerName: json['customer_name'] ?? 'Guest',
      status: json['status'] ?? 'pending',
      itemCount: json['item_count'] ?? itemsList.length,
      time: json['time'] ?? '',
      date: json['date'] ?? '',
      subtotal: _toDouble(json['subtotal']),
      tax: _toDouble(json['tax']),
      total: _toDouble(json['total']),
      paymentMethod: json['payment_method'] ?? 'Cash',
      items: itemsList,
      transactions: transactionsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_number': orderNumber,
      'customer_name': customerName,
      'status': status,
      'item_count': itemCount,
      'time': time,
      'date': date,
      'subtotal': subtotal,
      'tax': tax,
      'total': total,
      'payment_method': paymentMethod,
      'items': items.map((i) => i.toJson()).toList(),
      'transactions': transactions.map((t) => t.toJson()).toList(),
    };
  }
}

double _toDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}
