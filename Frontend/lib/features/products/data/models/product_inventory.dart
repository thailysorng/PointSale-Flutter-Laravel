import 'package:point_sale/features/products/data/models/category_model.dart';

class ProductInventory {
  final int? id;
  final String name;
  final String? skuCode;
  final double price;
  final int quantity;
  final Category? category;
  final String status;
  final int minStock;
  final int maxStock;
  final String? imageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProductInventory({
    this.id,
    required this.name,
    this.skuCode,
    required this.price,
    required this.quantity,
    this.category,
    required this.status,
    this.minStock = 10,
    this.maxStock = 100,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  ProductInventory copyWith({int? quantity}) {
    return ProductInventory(
      id: id,
      name: name,
      skuCode: skuCode,
      price: price,
      quantity: quantity ?? this.quantity,
      category: category,
      status: status,
      minStock: minStock,
      maxStock: maxStock,
      imageUrl: imageUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory ProductInventory.fromJson(Map<String, dynamic> json) {
    return ProductInventory(
      id: json['id'],
      name: json['name'],
      skuCode: json['sku_code'],
      price: _toDouble(json['price']),
      quantity: _toInt(json['quantity']),
      category: json['category'] != null
          ? Category.fromJson(json['category'])
          : null,
      status: json['status'],
      minStock: _toInt(json['min_stock'], defaultValue: 10),
      maxStock: _toInt(json['max_stock'], defaultValue: 50),
      imageUrl: json['image_url'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static int _toInt(dynamic value, {int defaultValue = 0}) {
    if (value == null) return defaultValue;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sku_code': skuCode,
      'price': price,
      'quantity': quantity,
      'category_id': category?.id,
      'status': status,
      'min_stock': minStock,
      'max_stock': maxStock,
      'image_url': imageUrl,
    };
  }
}
