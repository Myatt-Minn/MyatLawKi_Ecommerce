import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:myat_ecommerence/app/data/brand_model.dart';
import 'package:myat_ecommerence/app/data/category_model.dart';
import 'package:myat_ecommerence/app/data/consts_config.dart';
import 'package:myat_ecommerence/app/data/product_model.dart';
import 'package:myat_ecommerence/app/data/tokenHandler.dart';

class CategoryController extends GetxController {
  var selectedCategory = 'Categories'.obs; // Observable for category selection
  var searchText = ''.obs; // Observable for search input
  var isFavorite = false.obs;
  var brands = <BrandModel>[].obs;
  var categories = <CategoryModel>[].obs;
  RxList<Product> productList = <Product>[].obs; // Observable list of products
  RxList<Product> productsByBrand = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();

    fetchBrands();
    fetchCategories();
  }

  // Fetch brands from Firestore

  Future<void> fetchBrands() async {
    final url = '$baseUrl/api/v1/brands';
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

        // Check if 'data' key exists and is a list
        if (jsonData['data'] is List) {
          brands.value = (jsonData['data'] as List)
              .map((data) => BrandModel.fromJson(data))
              .toList();
        } else {
          throw Exception('Invalid data format');
        }
      } else {
        Get.snackbar("Error", "Something went wrong");
      }
    } catch (e) {
      Get.snackbar("Error", "fail to fetch brands");
    }
  }

  // Fetch categories

  Future<void> fetchCategories() async {
    final url = '$baseUrl/api/v1/categories';
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

        // Check if 'data' key exists and is a list
        if (jsonData['data'] is List) {
          categories.value = (jsonData['data'] as List)
              .map((data) => CategoryModel.fromJson(data))
              .toList();
        } else {
          throw Exception('Invalid data format');
        }
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  // Add to cart
  void addToCart(Product product) {
    Get.snackbar('Cart', '${product.name} added to cart!');
  }

  // Filtered products based on search query
  List<Product> get filteredProducts {
    if (searchText.isEmpty) {
      return productList;
    } else {
      return productList
          .where((product) =>
              product.name.toLowerCase().contains(searchText.toLowerCase()) ||
              product.category.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    }
  }

  // Filtered products based on search query
  List<Product> get filteredBrand {
    if (searchText.isEmpty) {
      return productsByBrand;
    } else {
      return productsByBrand
          .where((product) =>
              product.name.toLowerCase().contains(searchText.toLowerCase()) ||
              product.brand.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    }
  }
}
