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
import 'package:myat_ecommerence/app/data/tokenHandler.dart';
import 'package:myat_ecommerence/app/modules/notification/controllers/notification_controller.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController
  RxList<Product> productList = <Product>[].obs;

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

  Future<void> getAllProducts({int page = 1, int limit = 50}) async {
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

        // Check if 'data' key exists and is a list
        if (jsonData['data'] is List) {
          productList.value = (jsonData['data'] as List)
              .map((data) => Product.fromJson(data))
              .toList();
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

  Future<void> fetchBanners() async {
    final url = '$baseUrl/api/v1/banners';
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

  void checkAndPromptLogin() async {
    final authService = Tokenhandler();
    final token = await authService.getToken();

    if (token == null) {
      Get.defaultDialog(
        title: "login_first".tr,
        titleStyle: TextStyle(color: Colors.white),
        middleTextStyle: TextStyle(color: Colors.white),
        backgroundColor: ConstsConfig.primarycolor,
        confirmTextColor: Colors.black,
        buttonColor: Colors.white,
        content: Text(
          'to_proceed'.tr,
          style: TextStyle(color: Colors.white),
        ),
        textConfirm: "OK",
        onConfirm: () {
          Get.offNamed('/login'); // Navigate to the login screen
        },
      );
    } else {
      // Proceed to checkout if logged in
      Get.toNamed('/notification');
    }
  }

// Function to change the current page
  void changePage(int value) {
    currentBanner.value = value;
  }

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
        Get.snackbar("Fail", "Fail to load categories");
      }
    } catch (e) {
      Get.snackbar("Error", "Error loading data");
    }
  }

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
