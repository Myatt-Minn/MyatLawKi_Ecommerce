import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:myat_ecommerence/app/data/consts_config.dart';
import 'package:myat_ecommerence/app/data/payment_model.dart';
import 'package:myat_ecommerence/app/data/tokenHandler.dart';
import 'package:myat_ecommerence/app/modules/Cart/controllers/cart_controller.dart';

class PaymentController extends GetxController {
  // Rx variables for payment options

  var transitionImage = "".obs;
  File? file;
  var isProfileImageChooseSuccess = false.obs;
  var isLoading = false.obs;
  var isOrder = false.obs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  int paymentId = 0;

  var payments = <PaymentModel>[].obs; // List to store payment data
  var selectedPayment = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPayment(); // Fetch payment data when the controller initializes
    isProfileImageChooseSuccess.value = false;
  }

  // Method to select payment method
  void selectPayment(String method, int id) {
    selectedPayment.value = method;
    paymentId = id;
  }

  // Function to choose an image from File Picker
  Future<void> chooseImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      file = File(result.files.single.path!);
      isProfileImageChooseSuccess.value = true;
    } else {
      // User canceled the picker
      Get.snackbar("cancel".tr, "No Image");
    }
  }

  Future<void> fetchPayment() async {
    final url = '$baseUrl/api/v1/payments';
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
          payments.value = (jsonData['data'] as List)
              .map((data) => PaymentModel.fromJson(data))
              .toList();
        } else {
          throw Exception('Invalid data format');
        }
      } else {
        Get.snackbar("Sorry", "Something went wrong with the server");
        print("Response status code: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (e) {
      Get.snackbar("Error", "Error fetching payments");
    }
  }

  Future<void> createOrder({
    required String name,
    required String address,
    required String phone,
    required String regionId,
    required String deliId,
    required String deliFee,
  }) async {
    final authService = Tokenhandler();
    final token = await authService.getToken();

    if (token == null) {
      Get.snackbar(
        "Authentication Error",
        "User is not logged in.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    var cartItems = Get.find<CartController>().cartItems;

    // Validate cart items
    if (cartItems.isEmpty) {
      Get.snackbar(
        "Validation Error",
        "Cart cannot be empty.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Prepare the multipart request
    var request =
        http.MultipartRequest('POST', Uri.parse('$baseUrl/api/v1/orders'))
          ..headers.addAll({
            'Authorization': 'Bearer $token',
          })
          ..fields['name'] = name
          ..fields['address'] = address
          ..fields['phone'] = phone
          ..fields['payment_method'] = 'payment'
          ..fields['payment_id'] = paymentId.toString()
          ..fields['region_id'] = regionId
          ..fields['delivery_fee_id'] = deliId
          ..fields['delivery_fee'] = deliFee
          ..fields['carts'] = json.encode(
            cartItems.map((item) => item.toMap()).toList(),
          );

    // Add payment photo
    if (file!.existsSync()) {
      request.files.add(
        await http.MultipartFile.fromPath('payment_photo', file!.path),
      );
    } else {
      Get.snackbar(
        "Validation Error",
        "Please provide a valid payment photo.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        // Handle successful response
        Get.snackbar(
          "Success",
          "Order created successfully.",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offNamed('/order-success');
      } else {
        // Handle error response
        final responseBody = await response.stream.bytesToString();

        try {
          final errorResponse = json.decode(responseBody);
          Get.snackbar(
            "Order Error",
            errorResponse['message'] ?? 'An error occurred.',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        } catch (e) {
          // Fallback for non-JSON error responses
          print(e.toString());
        }
      }
    } catch (e) {
      print('Error creating order: $e');
      Get.snackbar(
        "Network Error",
        "Failed to create order. Please try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void confirmPayment() async {
    // Validate if a payment method is selected
    if (selectedPayment.value.isEmpty) {
      Get.snackbar('Invalid Payment', 'Please select a payment method.',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    // Validate if an image has been uploaded
    if (file == null) {
      Get.snackbar('Invalid Image', 'Please upload a transaction screenshot.',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;

    // Perform stock check for all items in the cart before placing the order
    // bool isStockAvailable = await checkStockForOrder(
    //   Get.find<CartController>().cartItems,
    // );

    // if (!isStockAvailable) {
    //   Get.snackbar(
    //       'Stock Error', 'Not enough stock for one or more items in your cart.',
    //       backgroundColor: Colors.red);
    //   isLoading.value = false;
    //   return;
    // }

    // Proceed with order creation if stock is sufficient
    await createOrder(
        name: Get.arguments['name'],
        phone: Get.arguments['phone'],
        deliFee: Get.arguments['deliFee'],
        deliId: Get.arguments['deliId'],
        regionId: Get.arguments['regionId'],
        address: Get.arguments['address']);
  }

// Function to check if there's enough stock for each item in the cart
  // Future<bool> checkStockForOrder(List<CartItem> cartItems) async {
  //   for (var cartItem in cartItems) {
  //     // Fetch the latest stock from Firestore for the specific product
  //     var productDoc = await FirebaseFirestore.instance
  //         .collection('new_arrivals')
  //         .doc(cartItem.productId)
  //         .get();

  //     if (!productDoc.exists) {
  //       Get.snackbar('Stock Error', 'Product not found.');
  //       return false; // Exit if product doesn't exist
  //     }

  //     // Retrieve the product data and map it to the Product model
  //     var productData = productDoc.data();
  //     var product = Product.fromJson(productData!);

  //     // Find the color option that matches the cart item's color
  //     var colorOption = product.colors?.firstWhereOrNull(
  //       (color) => color.color == cartItem.color,
  //     );

  //     if (colorOption == null) {
  //       Get.snackbar('Stock Error', 'Color not found for ${cartItem.name}.');
  //       return false; // Exit if color is not found
  //     }

  //     // Find the size option within the color option
  //     var sizeOption = colorOption.sizes.firstWhereOrNull(
  //       (size) => size.size == cartItem.size,
  //     );

  //     if (sizeOption == null) {
  //       Get.snackbar('Stock Error',
  //           'Size not found for ${cartItem.name}, color: ${cartItem.color}.');
  //       return false; // Exit if size not found
  //     }

  //     // Check if there is enough stock
  //     int availableStock = sizeOption.quantity;
  //     if (cartItem.quantity > availableStock) {
  //       Get.snackbar('Stock Error',
  //           'Not enough stock for ${cartItem.name}, color: ${cartItem.color}, size: ${cartItem.size}.',
  //           backgroundColor: Colors.red);
  //       return false; // Exit if stock is insufficient
  //     }
  //   }

  //   return true; // Return true if stock is sufficient for all items
  // }

  // Future<void> createOrder({
  //   required List<CartItem> cartItems, // List of CartItem objects
  //   required int totalPrice,
  //   required String address,
  //   required String status,
  //   required String name,
  //   required String phoneNumber,
  // }) async {
  //   try {
  //     final user = FirebaseAuth.instance.currentUser;

  //     if (user == null) {
  //       throw Exception("User not logged in");
  //     }

  //     final docRef = FirebaseFirestore.instance.collection('orders').doc();
  //     Timestamp timestamp =
  //         Timestamp.now(); // Assuming 'orderDate' is a Timestamp field
  //     DateTime dateTime = timestamp.toDate();

  //     // Create the OrderModel instance
  //     final order = OrderItem(
  //       userId: user.uid,
  //       orderId: int.parse(docRef.id),
  //       orderDate: dateTime,
  //       status: status, // Initial status
  //       totalPrice: totalPrice,
  //       paymentMethod: selectedPayment.value,
  //       transationUrl: transitionImage.value,
  //       name: name,
  //       phoneNumber: phoneNumber,
  //       address: address,
  //       items: cartItems, // Convert CartItems to Maps
  //     );

  //     // Add the order to Firestore
  //     await docRef.set(order.toMap());

  //     // Update stock for each product, color, and size
  //     for (var cartItem in cartItems) {
  //       // Fetch the product document from Firestore
  //       var productDoc = await FirebaseFirestore.instance
  //           .collection('new_arrivals')
  //           .doc(cartItem.productId)
  //           .get();

  //       if (productDoc.exists) {
  //         var productData = productDoc.data();
  //         var product = Product.fromMap(productData!);

  //         // Find the specific color option within the product
  //         var colorOption = product.colors?.firstWhereOrNull(
  //           (color) => color.color == cartItem.color,
  //         );

  //         if (colorOption != null) {
  //           // Find the specific size option within the color option
  //           var sizeOption = colorOption.sizes.firstWhereOrNull(
  //             (size) => size.size == cartItem.size,
  //           );

  //           if (sizeOption != null) {
  //             // Update the stock quantity
  //             int updatedQuantity = sizeOption.quantity - cartItem.quantity;
  //             sizeOption.quantity = updatedQuantity < 0 ? 0 : updatedQuantity;

  //             // Update Firestore with the modified product data
  //             await FirebaseFirestore.instance
  //                 .collection('new_arrivals')
  //                 .doc(cartItem.productId)
  //                 .update({
  //               'colors':
  //                   product.colors?.map((color) => color.toMap()).toList(),
  //             });
  //           } else {
  //             Get.snackbar("Stock Error",
  //                 "Size not found for ${cartItem.name}, color: ${cartItem.color}.");
  //           }
  //         } else {
  //           Get.snackbar(
  //               "Stock Error", "Color not found for ${cartItem.name}.");
  //         }
  //       }
  //     }

  //     print("Order created, stock updated, and cart cleared successfully!");
  //   } catch (e) {
  //     Get.snackbar("Error", "Sorry, error creating order: $e");
  //   }
  // }
}
