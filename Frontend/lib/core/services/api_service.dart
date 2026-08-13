import 'dart:convert';
import 'package:point_sale/core/constants/api_constants.dart';
import 'package:point_sale/features/auth/data/auth_service.dart';
import 'package:point_sale/features/products/data/models/category_model.dart';
import 'package:http/http.dart' as http;
import 'package:point_sale/features/products/data/models/product_inventory.dart';
import 'package:point_sale/features/home/data/models/dashboard_stats.dart';
import 'package:image_picker/image_picker.dart';

class ApiService {
  Future<dynamic> get(String endpoint) async {
    final token = await AuthService().getToken();
    final response = await http.get(
      Uri.parse(endpoint),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception('Failed to load data from $endpoint');
  }
  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    final token = await AuthService().getToken();
    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    }

    final errorBody = jsonDecode(response.body);
    throw Exception(errorBody['message'] ?? 'Failed to post data to $endpoint');
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    final token = await AuthService().getToken();
    final response = await http.put(
      Uri.parse(endpoint),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    final errorBody = jsonDecode(response.body);
    throw Exception(errorBody['message'] ?? 'Failed to update data at $endpoint');
  }

  Future<dynamic> delete(String endpoint) async {
    final token = await AuthService().getToken();
    final response = await http.delete(
      Uri.parse(endpoint),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return response.body.isNotEmpty ? jsonDecode(response.body) : null;
    }

    final errorBody = jsonDecode(response.body);
    throw Exception(errorBody['message'] ?? 'Failed to delete data at $endpoint');
  }

  static String get _categoriesUrl => ApiConstants.categories;
  static String get _productsUrl => ApiConstants.products;

  Future<List<Category>> fetchCategories() async {
    final List data = await get(_categoriesUrl);
    return data.map((item) => Category.fromJson(item)).toList();
  }

  Future<Category> createCategory(String name) async {
    final Map<String, dynamic> data = await post(_categoriesUrl, {'name': name});
    return Category.fromJson(data);
  }

  Future<List<ProductInventory>> fetchProducts() async {
    final List<dynamic> data = await get(_productsUrl);
    return data.map((json) => ProductInventory.fromJson(json)).toList();
  }

  Future<ProductInventory> createProduct(Map<String, dynamic> productData, {XFile? imageFile}) async {
    final token = await AuthService().getToken();
    var request = http.MultipartRequest('POST', Uri.parse(ApiConstants.products));
    
    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });

    productData.forEach((key, value) {
      if (value != null) {
        request.fields[key] = value.toString();
      }
    });

    if (imageFile != null) {
      final bytes = await imageFile.readAsBytes();

      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          bytes,
          filename: imageFile.name,
        ),
      );
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201) {
      return ProductInventory.fromJson(jsonDecode(response.body));
    }

    final errorBody = jsonDecode(response.body);
    throw Exception(errorBody['message'] ?? 'Failed to create product');
  }

  Future<ProductInventory> updateProduct(int id, Map<String, dynamic> productData, {XFile? imageFile}) async {
    final token = await AuthService().getToken();
    // Laravel PUT doesn't work well with multipart/form-data, so we use POST with _method=PUT
    var request = http.MultipartRequest('POST', Uri.parse('${ApiConstants.products}/$id'));
    
    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });

    request.fields['_method'] = 'PUT';
    productData.forEach((key, value) {
      if (value != null) {
        request.fields[key] = value.toString();
      }
    });

    if (imageFile != null) {
      final bytes = await imageFile.readAsBytes();

      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          bytes,
          filename: imageFile.name,
        ),
      );
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return ProductInventory.fromJson(jsonDecode(response.body));
    }

    final errorBody = jsonDecode(response.body);
    throw Exception(errorBody['message'] ?? 'Failed to update product');
  }

  Future<DashboardStats> fetchDashboardStats() async {
    final data = await get(ApiConstants.dashboardStats);
    return DashboardStats.fromJson(data);
  }
}
