import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:myat_ecommerence/app/data/consts_config.dart';
import 'package:myat_ecommerence/app/data/region_deli_model.dart';
import 'package:myat_ecommerence/app/data/tokenHandler.dart';
import 'package:myat_ecommerence/app/data/user_model.dart';
import 'package:myat_ecommerence/app/modules/Cart/controllers/cart_controller.dart';

class CheckOutController extends GetxController {
  //TODO: Implement CheckOutController
  var currentUser = Rxn<UserModel>();
  var isLoading = false.obs;
  RxList<RegionModel> regions = <RegionModel>[].obs;
  RxList<DeliFeeModel> deliFees = <DeliFeeModel>[].obs;
  Rx<RegionModel?> selectedRegion = Rx<RegionModel?>(null);
  RxList<String> citiesForSelectedRegion = <String>[].obs;
  RxString selectedCity = ''.obs;
  RxString selectedFee = ''.obs;
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  String feeId = "";

  @override
  void onInit() {
    super.onInit();
    fetchDeliFees();
    fetchRegions();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final url = '$baseUrl/api/v1/customer';
    final token = await Tokenhandler()
        .getToken(); // Make sure to replace this with your method for retrieving the token.

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['success'] == true) {
          currentUser.value = UserModel.fromJson(jsonData['data']);
          nameController.text = currentUser.value!.name;
          phoneNumberController.text = currentUser.value!.phone;
        } else {
          Get.snackbar("Error", "Error fetching data");
        }
      } else {
        Get.snackbar("Fail", "Error fetching data");
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return;
    }
  }

  double get finaltotalcost {
    if (selectedFee.isNotEmpty) {
      return Get.find<CartController>().totalAmount.value +
          int.parse(selectedFee.value);
    } else {
      return Get.find<CartController>().totalAmount.value;
    }
  }

  bool setOrder() {
    if (nameController.text.isNotEmpty &&
        phoneNumberController.text.isNotEmpty &&
        addressController.text.isNotEmpty &&
        selectedFee.value.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> fetchRegions() async {
    final url = '$baseUrl/api/v1/regions';
    final token = await Tokenhandler().getToken();

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      regions.value =
          data.map<RegionModel>((json) => RegionModel.fromJson(json)).toList();
    } else {
      Get.snackbar("Fail", "Failed to load regions");
    }
  }

  Future<void> fetchDeliFees() async {
    final url = '$baseUrl/api/v1/delivery-fees';
    final token = await Tokenhandler().getToken();

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      deliFees.value = data
          .map<DeliFeeModel>((json) => DeliFeeModel.fromJson(json))
          .toList();
    } else {
      Get.snackbar("Fail", "Failed to load delivery fees");
    }
  }

  void onRegionSelected(RegionModel region) {
    selectedRegion.value = region;
    citiesForSelectedRegion.value = deliFees
        .where((fee) => fee.regionId == region.id)
        .map((fee) => fee.city)
        .toSet()
        .toList();
    selectedCity.value = '';
    selectedFee.value = '';
  }

  void onCitySelected(String city) {
    selectedCity.value = city;
    final fee = deliFees.firstWhere(
      (fee) => fee.regionId == selectedRegion.value!.id && fee.city == city,
    );
    selectedFee.value = fee.fee;
    feeId = fee.id.toString();
  }

  Future<void> createOrder() async {
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

    // Prepare the request body
    final Map<String, dynamic> requestBody = {
      'name': nameController.text,
      'address': addressController.text,
      'phone': phoneNumberController.text,
      'payment_method': 'cod', // Adjust payment method if needed
      'carts': json.encode(
        cartItems.map((item) => item.toMap()).toList(),
      ),
      'region_id': selectedRegion.value!.id.toString(),
      'delivery_fee_id': feeId,
      'delivery_fee': selectedFee.value,
    };

    print('Request Body: ${json.encode(requestBody)}'); // Log the request body

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/orders'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json', // Added Accept header
          'Authorization': 'Bearer $token',
        },
        body: json.encode(requestBody),
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}'); // Log the response body

      if (response.statusCode == 200) {
        // Successfully created order
        Get.offNamed('/order-success');
      } else {
        // Handle error response
        try {
          final responseBody = json.decode(response.body);
          Get.snackbar(
            "Order Error",
            responseBody['message'] ?? 'An error occurred.',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        } catch (e) {
          // Fallback for non-JSON error responses
          Get.snackbar(
            "Order Error",
            "Unexpected error: ${response.body}",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
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

  // Filter cities based on the selected region

// // Method to confirm the payment
//   void confirmPayment() async {
//     isLoading.value = true;

//     // Perform stock check for all items in the cart before placing the order
//     bool isStockAvailable = await checkStockForOrder(
//       Get.find<CartController>()
//           .cartItems, // Pass the observable cartItems list here
//     );

//     if (!isStockAvailable) {
//       Get.snackbar('stock_error'.tr, 'not_enough_stock'.tr,
//           backgroundColor: Colors.red);
//       isLoading.value = false;
//       return; // Exit the function if stock is insufficient
//     }

//     // Proceed with order creation if stock is sufficient
//     await createOrder(
//       name: nameController.text,
//       phoneNumber: phoneNumberController.text,
//       cartItems: Get.find<CartController>().cartItems,
//       totalPrice: finaltotalcost,
//       address: addressController.text,
//       status: "Pending",
//     );

//     Get.offNamed('/order-success');
//     isLoading.value = false;
//   }

// Function to check if there's enough stock for each item in the cart
  // Future<bool> checkStockForOrder(List<CartItem> cartItems) async {
  //   for (var cartItem in cartItems) {
  //     // Fetch the latest stock from Firestore for the specific product
  //     var productDoc = await FirebaseFirestore.instance
  //         .collection('new_arrivals')
  //         .doc(cartItem.productId)
  //         .get();

  //     if (!productDoc.exists) {
  //       Get.snackbar('stock_error'.tr, 'Product not found.');
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
  //       Get.snackbar('stock_error'.tr, 'Color not found for ${cartItem.name}.');
  //       return false; // Exit if color is not found
  //     }

  //     // Find the size option within the color option
  //     var sizeOption = colorOption.sizes.firstWhereOrNull(
  //       (size) => size.size == cartItem.size,
  //     );

  //     if (sizeOption == null) {
  //       Get.snackbar('stock_error'.tr,
  //           'Size not found for ${cartItem.name}, color: ${cartItem.color}.');
  //       return false; // Exit if size not found
  //     }

  //     // Check if there is enough stock
  //     int availableStock = sizeOption.quantity;
  //     if (cartItem.quantity > availableStock) {
  //       Get.snackbar('stock_error'.tr,
  //           '${'not_enough_stock'.tr} for ${cartItem.name}, color: ${cartItem.color}, size: ${cartItem.size}.',
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
  //       paymentMethod: 'COD',

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
  //             Get.snackbar('stock_error'.tr,
  //                 "Size not found for ${cartItem.name}, color: ${cartItem.color}.");
  //           }
  //         } else {
  //           Get.snackbar(
  //               'stock_error'.tr, "Color not found for ${cartItem.name}.");
  //         }
  //       }
  //     }
  //   } catch (e) {
  //     Get.snackbar("Error", "Sorry, error creating order: $e");
  //   }
  // }

  // Fetch current user data from Firestore
}
