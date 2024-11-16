import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:myat_ecommerence/app/data/consts_config.dart';
import 'package:myat_ecommerence/app/data/product_model.dart';
import 'package:myat_ecommerence/app/data/tokenHandler.dart';

class AllCategoryProductsController extends GetxController {
  //TODO: Implement AllCategoryProductsController

  RxList<Product> products = <Product>[].obs; // List of all products

  RxList<Product> filteredProducts =
      <Product>[].obs; // Filtered list based on search
  RxString searchQuery = ''.obs;
  RxBool isLoading = false.obs;
  RxString categorygg = ''.obs;
  @override
  void onInit() {
    super.onInit();
    categorygg.value = Get.arguments;
    // fetchProducts(category: categorygg!.value);
    getAllProductsByCategory();
  }

  Future<void> getAllProductsByCategory({int page = 1, int limit = 70}) async {
    final url = '$baseUrl/api/v1/products?page=$page&limit=$limit';
    final authService = Tokenhandler();
    final token = await authService.getToken();

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        if (jsonData['data'] is List) {
          // First, map all products from the response
          final allProducts = (jsonData['data'] as List)
              .map((data) => Product.fromJson(data))
              .toList();

          // Then filter the products based on the category parameter
          products.value = allProducts
              .where((product) => product.category == categorygg.value)
              .toList();
          filteredProducts.assignAll(products);
          if (products.isEmpty) {
            print('No products found for category: $categorygg');
          }
        } else {
          throw Exception('Invalid data format');
        }
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Error fetching products by category: $e');
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
                product.category.toLowerCase().contains(query.toLowerCase()))
            .toList(),
      );
    }
  }
}
