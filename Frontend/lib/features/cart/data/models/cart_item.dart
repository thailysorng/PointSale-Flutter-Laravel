import 'package:point_sale/features/products/data/models/product_inventory.dart';

class CartItem {
  final ProductInventory product;
  final int quantity;

  CartItem({
    required this.product,
    required this.quantity,
  });

  CartItem copyWith({
    ProductInventory? product,
    int? quantity,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}