import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myat_ecommerence/app/data/category_model.dart';
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
  var banners = <String>[].obs;

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

  // Fetch categories from Firestore
  Future<void> fetchCategories() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('categories').get();
      categories.value = snapshot.docs
          .map((doc) =>
              CategoryModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      Get.snackbar('Error', 'failed_to_fetch_data'.tr);
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

  // Fetch banner URLs from Firestore
  void fetchBanners() async {
    try {
      QuerySnapshot snapshot = await firestore.collection('banners').get();
      banners.value =
          snapshot.docs.map((doc) => doc['imgUrl'].toString()).toList();
    } catch (e) {
      Get.snackbar('Error', 'failed_to_fetch_data'.tr);
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
