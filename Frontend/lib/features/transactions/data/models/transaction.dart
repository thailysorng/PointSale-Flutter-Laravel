import 'package:point_sale/features/orders/data/models/order.dart';

class Transaction {
  final String id;
  final String? transactionNumber;
  final String type; // 'sale'
  final String description;
  final String paymentMethod;
  final String time;
  final String date;
  final double amount;
  final String? orderId;
  final int itemCount;
  final OrderModel? order;

  Transaction({
    required this.id,
    this.transactionNumber,
    required this.type,
    required this.description,
    required this.paymentMethod,
    required this.time,
    this.date = '',
    required this.amount,
    this.orderId,
    this.itemCount = 0,
    this.order,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id']?.toString() ?? '',
      transactionNumber: json['transaction_number'],
      type: json['type'] ?? 'sale',
      description: json['description'] ?? '',
      paymentMethod: json['payment_method'] ?? 'Cash',
      time: json['time'] ?? '',
      date: json['date'] ?? '',
      amount: _toDouble(json['amount']),
      orderId: json['order_id']?.toString(),
      itemCount: json['item_count'] ?? 0,
      order: json['order'] != null ? OrderModel.fromJson(json['order']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transaction_number': transactionNumber,
      'type': type,
      'description': description,
      'payment_method': paymentMethod,
      'time': time,
      'date': date,
      'amount': amount,
      'order_id': orderId,
      'item_count': itemCount,
      'order': order?.toJson(),
    };
  }
}

double _toDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}
