import 'package:flutter/material.dart';
import 'package:point_sale/core/constants/api_constants.dart';
import 'package:point_sale/core/services/api_service.dart';
import 'package:point_sale/features/products/data/models/category_model.dart';
import 'package:point_sale/features/products/data/models/product_inventory.dart';
import 'package:image_picker/image_picker.dart';

class ProductInventoryProvider extends ChangeNotifier {
  ProductInventoryProvider() {
    loadProducts();
    loadCategories();
  }

  final ApiService _apiService = ApiService();

  List<ProductInventory> _products = [];
  List<ProductInventory> get products => _products;

  List<Category> _categories = [];
  List<Category> get categories => _categories;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> loadProducts() async {
    _setLoading(true);
    try {
      _products = await _apiService.fetchProducts();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadCategories() async {
    _setLoading(true);
    try {
      _categories = await _apiService.fetchCategories();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<Category?> addCategory(String name) async {
    try {
      final newCategory = await _apiService.createCategory(name);
      _categories.add(newCategory);
      notifyListeners();
      return newCategory;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<bool> addProduct(
    Map<String, dynamic> productData, {
    XFile? imageFile,
  }) async {
    try {
      final newProduct = await _apiService.createProduct(
        productData,
        imageFile: imageFile,
      );
      _products.insert(0, newProduct);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProduct(
    int id,
    Map<String, dynamic> productData, {
    XFile? imageFile,
  }) async {
    try {
      final updatedProduct = await _apiService.updateProduct(
        id,
        productData,
        imageFile: imageFile,
      );
      final index = _products.indexWhere((p) => p.id == id);
      if (index != -1) {
        _products[index] = updatedProduct;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // --- Products Screen Filters ---
  String _productSearchQuery = '';
  String? _productSelectedCategory;

  String get productSearchQuery => _productSearchQuery;
  String? get productSelectedCategory => _productSelectedCategory;

  void setProductSearchQuery(String query) {
    _productSearchQuery = query;
    notifyListeners();
  }

  void selectProductCategory(String category) {
    if (category == 'All') {
      _productSelectedCategory = null;
    } else {
      _productSelectedCategory = category;
    }
    notifyListeners();
  }

  List<ProductInventory> get filteredProducts {
    var result = _products;

    if (_productSelectedCategory != null) {
      result = result
          .where(
            (p) => (p.category?.name ?? 'Unknown') == _productSelectedCategory,
          )
          .toList();
    }

    if (_productSearchQuery.isNotEmpty) {
      result = result.where((p) {
        return p.name.toLowerCase().contains(
              _productSearchQuery.toLowerCase(),
            ) ||
            (p.skuCode?.toLowerCase().contains(
                  _productSearchQuery.toLowerCase(),
                ) ??
                false);
      }).toList();
    }

    return result;
  }

  // --- Stock Management Screen Filters ---
  String _stockSearchQuery = '';
  String? _stockSelectedCategory;
  String _stockSelectedStatus = 'All Items';

  String get stockSearchQuery => _stockSearchQuery;
  String? get stockSelectedCategory => _stockSelectedCategory;
  String get stockSelectedStatus => _stockSelectedStatus;

  void setStockSearchQuery(String query) {
    _stockSearchQuery = query;
    notifyListeners();
  }

  void selectStockCategory(String category) {
    if (category == 'All') {
      _stockSelectedCategory = null;
    } else {
      _stockSelectedCategory = category;
    }
    notifyListeners();
  }

  void setStockStatus(String status) {
    _stockSelectedStatus = status;
    notifyListeners();
  }

  List<ProductInventory> get stockFilteredProducts {
    var result = _products;

    if (_stockSelectedCategory != null) {
      result = result
          .where(
            (p) => (p.category?.name ?? 'Unknown') == _stockSelectedCategory,
          )
          .toList();
    }

    if (_stockSelectedStatus != 'All Items') {
      result = result.where((p) {
        if (_stockSelectedStatus == 'Low Stock') return p.quantity < p.minStock;
        if (_stockSelectedStatus == 'Normal')
          return p.quantity >= p.minStock && p.quantity < p.maxStock * 0.7;
        if (_stockSelectedStatus == 'Well Stocked')
          return p.quantity >= p.maxStock * 0.7;
        return true;
      }).toList();
    }

    if (_stockSearchQuery.isNotEmpty) {
      result = result.where((p) {
        return p.name.toLowerCase().contains(_stockSearchQuery.toLowerCase()) ||
            (p.skuCode?.toLowerCase().contains(
                  _stockSearchQuery.toLowerCase(),
                ) ??
                false);
      }).toList();
    }

    return result;
  }

  Future<bool> deleteProduct(int id) async {
    try {
      await _apiService.delete('${ApiConstants.products}/$id');
      _products.removeWhere((p) => p.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  int get totalProducts => _products.length;
  int get lowStockCount =>
      _products.where((p) => p.quantity < p.minStock).length;
  int get outOfStockCount => _products.where((p) => p.quantity == 0).length;

  double get totalStockValue =>
      _products.fold(0.0, (sum, p) => sum + (p.quantity * p.price));

  List<String> get categoryNames {
    final Set<String> names = {'All'};
    for (var p in _products) {
      if (p.category != null) {
        names.add(p.category!.name);
      }
    }
    return names.toList()..sort((a, b) {
      if (a == 'All') return -1;
      if (b == 'All') return 1;
      return a.compareTo(b);
    });
  }

  List<Map<String, dynamic>> get categoriesWithCounts {
    final Map<String, int> counts = {};
    for (var p in _products) {
      counts[p.category?.name ?? 'Unknown'] =
          (counts[p.category?.name ?? 'Unknown'] ?? 0) + 1;
    }

    final List<Map<String, dynamic>> result = [];
    // Add "All" option
    result.add({'name': 'All', 'count': _products.length});

    counts.forEach((key, value) {
      result.add({'name': key, 'count': value});
    });

    // Sort but keep "All" at the beginning
    final allOption = result.removeAt(0);
    result.sort((a, b) => a['name'].compareTo(b['name']));
    result.insert(0, allOption);

    return result;
  }

  Future<bool> restockItem(int id, int qty) async {
    try {
      final index = _products.indexWhere((item) => item.id == id);
      if (index == -1) return false;

      final item = _products[index];
      final newQuantity = item.quantity + qty;
      
      // Dynamically increase maxStock if new quantity exceeds it
      int newMaxStock = item.maxStock;
      if (newQuantity > newMaxStock) {
        newMaxStock = newQuantity;
      }

      final updatedProduct = await _apiService.updateProduct(id, {
        ...item.toJson(),
        'quantity': newQuantity,
        'max_stock': newMaxStock,
      });

      _products[index] = updatedProduct;
      notifyListeners();

      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> restockAllLow() async {
    try {
      final now = DateTime.now();
      bool hasChanges = false;

      for (int i = 0; i < _products.length; i++) {
        final item = _products[i];

        if (item.quantity < item.minStock) {
          // Note: In restockAllLow, newQuantity is item.maxStock,
          // so it won't exceed maxStock by definition here.
          final newQuantity = item.maxStock;

          final updatedProduct = await _apiService.updateProduct(item.id!, {
            ...item.toJson(),
            'quantity': newQuantity,
            'updated_at': now.toIso8601String(),
          });

          _products[i] = updatedProduct;
          hasChanges = true;
        }
      }

      if (hasChanges) {
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
