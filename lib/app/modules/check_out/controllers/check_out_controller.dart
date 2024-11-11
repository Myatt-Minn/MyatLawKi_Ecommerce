import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:myat_ecommerence/app/data/cart_model.dart';
import 'package:myat_ecommerence/app/data/consts_config.dart';
import 'package:myat_ecommerence/app/data/order_model.dart';
import 'package:myat_ecommerence/app/data/product_model.dart';
import 'package:myat_ecommerence/app/data/region_deli_model.dart';
import 'package:myat_ecommerence/app/modules/Cart/controllers/cart_controller.dart';

class CheckOutController extends GetxController {
  //TODO: Implement CheckOutController

  var isLoading = false.obs;
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  RxList<DeliFeeModel> deliFees = <DeliFeeModel>[].obs;
  var selectedFee = Rxn<DeliFeeModel>();

  @override
  void onInit() {
    super.onInit();
    fetchDeliFees();
    fetchUserData();
  }

  int get finaltotalcost {
    return Get.find<CartController>().totalAmount.value +
        int.parse(selectedFee.value!.fee);
  }

  bool setOrder() {
    if (nameController.text.isNotEmpty &&
        phoneNumberController.text.isNotEmpty &&
        addressController.text.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> fetchDeliFees() async {
    final url = '$baseUrl/api/v1/delivery-fees';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> data = jsonData['data'];

      deliFees.value = data.map((json) => DeliFeeModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load delivery fees');
    }
  }

// Method to confirm the payment
  void confirmPayment() async {
    isLoading.value = true;

    // Perform stock check for all items in the cart before placing the order
    bool isStockAvailable = await checkStockForOrder(
      Get.find<CartController>()
          .cartItems, // Pass the observable cartItems list here
    );

    if (!isStockAvailable) {
      Get.snackbar(
          'Stock Error', 'Not enough stock for one or more items in your cart.',
          backgroundColor: Colors.red);
      isLoading.value = false;
      return; // Exit the function if stock is insufficient
    }

    // Proceed with order creation if stock is sufficient
    await createOrder(
      name: nameController.text,
      phoneNumber: phoneNumberController.text,
      cartItems: Get.find<CartController>().cartItems,
      totalPrice: finaltotalcost,
      address: addressController.text,
      status: "Pending",
    );

    Get.offNamed('/order-success');
    isLoading.value = false;
  }

// Function to check if there's enough stock for each item in the cart
  Future<bool> checkStockForOrder(List<CartItem> cartItems) async {
    for (var cartItem in cartItems) {
      // Fetch the latest stock from Firestore for the specific product
      var productDoc = await FirebaseFirestore.instance
          .collection('new_arrivals')
          .doc(cartItem.productId)
          .get();

      if (!productDoc.exists) {
        Get.snackbar('Stock Error', 'Product not found.');
        return false; // Exit if product doesn't exist
      }

      // Retrieve the product data and map it to the Product model
      var productData = productDoc.data();
      var product = Product.fromMap(productData!);

      // Find the color option that matches the cart item's color
      var colorOption = product.colors?.firstWhereOrNull(
        (color) => color.color == cartItem.color,
      );

      if (colorOption == null) {
        Get.snackbar('Stock Error', 'Color not found for ${cartItem.name}.');
        return false; // Exit if color is not found
      }

      // Find the size option within the color option
      var sizeOption = colorOption.sizes.firstWhereOrNull(
        (size) => size.size == cartItem.size,
      );

      if (sizeOption == null) {
        Get.snackbar('Stock Error',
            'Size not found for ${cartItem.name}, color: ${cartItem.color}.');
        return false; // Exit if size not found
      }

      // Check if there is enough stock
      int availableStock = sizeOption.quantity;
      if (cartItem.quantity > availableStock) {
        Get.snackbar('Stock Error',
            '${'not_enough_stock'.tr} for ${cartItem.name}, color: ${cartItem.color}, size: ${cartItem.size}.',
            backgroundColor: Colors.red);
        return false; // Exit if stock is insufficient
      }
    }

    return true; // Return true if stock is sufficient for all items
  }

  Future<void> createOrder({
    required List<CartItem> cartItems, // List of CartItem objects
    required int totalPrice,
    required String address,
    required String status,
    required String name,
    required String phoneNumber,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception("User not logged in");
      }

      final docRef = FirebaseFirestore.instance.collection('orders').doc();
      Timestamp timestamp =
          Timestamp.now(); // Assuming 'orderDate' is a Timestamp field
      DateTime dateTime = timestamp.toDate();

      // Create the OrderModel instance
      final order = OrderItem(
        userId: user.uid,
        orderId: int.parse(docRef.id),
        orderDate: dateTime,
        status: status, // Initial status
        totalPrice: totalPrice,
        paymentMethod: 'COD',

        name: name,
        phoneNumber: phoneNumber,
        address: address,
        items: cartItems, // Convert CartItems to Maps
      );

      // Add the order to Firestore
      await docRef.set(order.toMap());

      // Update stock for each product, color, and size
      for (var cartItem in cartItems) {
        // Fetch the product document from Firestore
        var productDoc = await FirebaseFirestore.instance
            .collection('new_arrivals')
            .doc(cartItem.productId)
            .get();

        if (productDoc.exists) {
          var productData = productDoc.data();
          var product = Product.fromMap(productData!);

          // Find the specific color option within the product
          var colorOption = product.colors?.firstWhereOrNull(
            (color) => color.color == cartItem.color,
          );

          if (colorOption != null) {
            // Find the specific size option within the color option
            var sizeOption = colorOption.sizes.firstWhereOrNull(
              (size) => size.size == cartItem.size,
            );

            if (sizeOption != null) {
              // Update the stock quantity
              int updatedQuantity = sizeOption.quantity - cartItem.quantity;
              sizeOption.quantity = updatedQuantity < 0 ? 0 : updatedQuantity;

              // Update Firestore with the modified product data
              await FirebaseFirestore.instance
                  .collection('new_arrivals')
                  .doc(cartItem.productId)
                  .update({
                'colors':
                    product.colors?.map((color) => color.toMap()).toList(),
              });
            } else {
              Get.snackbar("Stock Error",
                  "Size not found for ${cartItem.name}, color: ${cartItem.color}.");
            }
          } else {
            Get.snackbar(
                "Stock Error", "Color not found for ${cartItem.name}.");
          }
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Sorry, error creating order: $e");
    }
  }

  // Fetch current user data from Firestore
  void fetchUserData() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      if (userDoc.exists) {
        nameController.text = userDoc['name'] ?? '';
        phoneNumberController.text =
            userDoc['phoneNumber'] ?? ''; // Fetch phone number
      }
    } catch (e) {
      Get.snackbar('Error', 'failed_to_fetch_data'.tr);
    }
  }
}
