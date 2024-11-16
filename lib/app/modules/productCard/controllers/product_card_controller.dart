import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:myat_ecommerence/app/data/consts_config.dart';
import 'package:myat_ecommerence/app/data/product_model.dart';
import 'package:myat_ecommerence/app/data/tokenHandler.dart';

class ProductCardController extends GetxController {
  //TODO: Implement ProductCardController

  RxList<Product> savedproducts = <Product>[].obs;
  final RxMap<int, RxBool> savedStatusMap = <int, RxBool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchWishList();
  }

  Future<void> toggleSaveStatus(Product product) async {
    try {
      // Determine the new status to send in the API request
      bool isCurrentlySaved =
          savedStatusMap[product.id]?.value ?? false; // Default to false
      bool newStatus = !isCurrentlySaved;
      final authService = Tokenhandler();
      final token = await authService.getToken();
      // Make the POST request to change the save status
      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/wishlist/change'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'product_id': product.id,
        }),
      );

      if (response.statusCode == 200) {
        // Update the local saved status map if the API call succeeds
        savedStatusMap[product.id] = RxBool(newStatus);
        if (newStatus) {
          savedproducts.add(product); // Add to wishlist
        } else {
          savedproducts
              .removeWhere((p) => p.id == product.id); // Remove from wishlist
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed to update wishlist status.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred while updating the wishlist.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> fetchWishList() async {
    final url = '$baseUrl/api/v1/wishlist';
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
          savedproducts.clear();
          savedproducts.value = (jsonData['data'] as List)
              .map((data) => Product.fromJson(data))
              .toList();
        } else {
          throw Exception('Invalid data format');
        }
      } else {
        throw Exception('Failed to load banners');
      }
    } catch (e) {
      print('Error fetching banners: $e');
    }
  }

  // Checks if a product is saved locally in the savedStatusMap
  Future<void> checkIfSaved(Product product) async {
    if (savedStatusMap.isEmpty) {
      // Fetch wishlist if it's not already loaded
      await fetchWishList();
    }

    // Determine the save status for the product
    bool isSaved = savedproducts.any((p) => p.id == product.id);
    savedStatusMap[product.id] = RxBool(isSaved);
  }
}
