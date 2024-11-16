import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:myat_ecommerence/app/data/consts_config.dart';
import 'package:myat_ecommerence/app/data/product_model.dart';
import 'package:myat_ecommerence/app/data/tokenHandler.dart';

class AllProductsController extends GetxController {
  RxList<Product> products = <Product>[].obs; // List of all products
  RxList<Product> filteredProducts =
      <Product>[].obs; // Filtered list based on search
  RxString searchQuery = ''.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getAllProducts();
  }

  Future<void> getAllProducts({int page = 1, int limit = 70}) async {
    final url = '$baseUrl/api/v1/products?page=$page&limit=$limit';
    final authService = Tokenhandler();
    final token = await authService.getToken();

    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        // Check if 'data' key exists and is a list
        if (jsonData['data'] is List) {
          products.value = (jsonData['data'] as List)
              .map((data) => Product.fromJson(data))
              .toList();
          isLoading.value = false;
          filteredProducts.assignAll(products);
        } else {
          throw Exception('Invalid data format');
        }
      } else {
        throw Exception('Failed to load banners');
      }
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  void searchProducts(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredProducts.assignAll(products);
    } else {
      filteredProducts.assignAll(
        products
            .where((product) =>
                product.name.toLowerCase().contains(query.toLowerCase()) ||
                product.brand.toLowerCase().contains(query.toLowerCase()))
            .toList(),
      );
    }
  }
}
