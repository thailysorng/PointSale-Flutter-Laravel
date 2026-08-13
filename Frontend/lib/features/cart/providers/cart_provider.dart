import 'package:flutter/foundation.dart';
import 'package:point_sale/features/cart/data/models/cart_item.dart';
import 'package:point_sale/features/products/data/models/product_inventory.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get totalItems {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  double get subtotal {
    return _items.fold(
      0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );
  }

  double get tax {
    return subtotal * 0.1; // 10% tax
  }

  double get total {
    return subtotal + tax;
  }

  bool get isEmpty => _items.isEmpty;

  bool addProduct(ProductInventory product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    
    // The limit is the lesser of maxStock or actual quantity
    final limit = product.maxStock < product.quantity ? product.maxStock : product.quantity;

    if (index != -1) {
      if (_items[index].quantity >= limit) {
        return false; // Limit reached
      }
      _items[index] = _items[index].copyWith(
        quantity: _items[index].quantity + 1,
      );
    } else {
      if (limit <= 0) {
        return false; // Out of stock or limit is 0
      }
      _items.add(CartItem(product: product, quantity: 1));
    }

    notifyListeners();
    return true;
  }

  bool incrementQuantity(int? productId) {
    final index = _items.indexWhere((p) => p.product.id == productId);
    if (index != -1) {
      final product = _items[index].product;
      final limit = product.maxStock < product.quantity ? product.maxStock : product.quantity;

      if (_items[index].quantity >= limit) {
        return false; // Cannot exceed limit
      }
      _items[index] = _items[index].copyWith(
        quantity: _items[index].quantity + 1,
      );
      notifyListeners();
      return true;
    }
    return false;
  }

  void decrementQuantity(int? productId) {
    final index = _items.indexWhere((p) => p.product.id == productId);
    if (index != -1) {
      if (_items[index].quantity > 1) {
        _items[index] = _items[index].copyWith(
          quantity: _items[index].quantity - 1,
        );
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void removeItem(int? productId) {
    _items.removeWhere((p) => p.product.id == productId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  void updateQuantity(int? productId, int quantity) {
    if (quantity <= 0) {
      removeItem(productId);
      return;
    }

    final index = _items.indexWhere((p) => p.product.id == productId);
    if (index != -1) {
      final product = _items[index].product;
      final limit = product.maxStock < product.quantity ? product.maxStock : product.quantity;

      // Validate against limit
      if (quantity > limit) {
        quantity = limit;
      }
      _items[index] = _items[index].copyWith(quantity: quantity);
      notifyListeners();
    }
  }
}
