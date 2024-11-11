import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:myat_ecommerence/app/data/banner_model.dart';
import 'package:myat_ecommerence/app/data/category_model.dart';
import 'package:myat_ecommerence/app/data/consts_config.dart';
import 'package:myat_ecommerence/app/data/product_model.dart';
import 'package:myat_ecommerence/app/modules/notification/controllers/notification_controller.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController
  RxList<Product> productList = <Product>[].obs;
  RxList<SizeOption> sizeList = <SizeOption>[].obs;
  RxList<CategoryModel> categories = <CategoryModel>[].obs;
  late PageController pageController;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final notiController = Get.put(NotificationController());

  // List to store banner URLs
  var banners = <BannerModel>[].obs;

  var currentBanner = 0.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBanners();
    startAutoSlide();
    pageController = PageController(initialPage: currentBanner.value);
    getAllProducts();
    fetchCategories();
  }

  Future<void> getAllProducts() async {
    // Retrieve all documents from the "products" collection
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('new_arrivals').get();

      // Iterate over each document and convert it to a ProductModel
      for (var doc in querySnapshot.docs) {
        productList.add(Product.fromMap(doc.data()));
      }
    } catch (e) {
      Get.snackbar("GG", e.toString());
    }
  }

  Future<void> fetchBanners() async {
    final url = '$baseUrl/api/v1/banners';
    // final authService = Tokenhandler();
    // final token = await authService.getToken();

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
          banners.value = (jsonData['data'] as List)
              .map((data) => BannerModel.fromJson(data))
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

  void displayProductSizes(Product product) {
    for (var colorOption in product.colors!) {
      for (var sizeOption in colorOption.sizes) {
        sizeList.add(sizeOption);
      }
    }
  }

// Function to change the current page
  void changePage(int value) {
    currentBanner.value = value;
  }

  Future<void> fetchCategories() async {
    final url = '$baseUrl/api/v1/categories';
    // final authService = Tokenhandler();
    // final token = await authService.getToken();

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

// Future<BannerModel?> fetchPost(int postId) async {
//   final url = '$baseUrl/api/v1/banners/$postId';

//   final response = await http.get(
//     Uri.parse(url),
//     headers: {
//       'Authorization': 'Bearer $token',
//       'Content-Type': 'application/json',
//     },
//   );

//   if (response.statusCode == 200) {
//     final jsonData = json.decode(response.body);
//     return BannerModel.fromJson(jsonData);
//   } else {
//     throw Exception('Failed to load post');
//   }
// }

  void startAutoSlide() {
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (currentBanner.value < banners.length - 1) {
        currentBanner.value++;
      } else {
        currentBanner.value = 0; // Loop back to the first banner
      }

      pageController.animateToPage(
        currentBanner.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void onClose() {
    super.onClose();
    pageController.dispose();
    notiController.dispose();
  }
}
