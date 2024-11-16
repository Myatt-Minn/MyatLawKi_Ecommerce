import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:myat_ecommerence/app/data/consts_config.dart';
import 'package:myat_ecommerence/app/data/order_model.dart';
import 'package:myat_ecommerence/app/data/tokenHandler.dart';

class OrderHistoryController extends GetxController {
  //TODO: Implement OrderHistoryController

  var orderList = <Order>[].obs; // Reactive list to store orders
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    final url = '$baseUrl/api/v1/orders';
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
          orderList.value = (jsonData['data'] as List)
              .map((data) => Order.fromJson(data))
              .toList();
          isLoading.value = false;
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
  // Future<void> fetchOrderHistory() async {
  //   try {
  //     isLoading(true); // Set loading to true

  //     // Get the current user's ID
  //     String userId = FirebaseAuth.instance.currentUser!.uid;

  //     // Query Firestore to get orders for the current user, ordered by 'orderDate' in descending order
  //     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //         .collection('orders')
  //         .where('userId', isEqualTo: userId) // Filter by userId
  //         .orderBy('orderDate', descending: true) // Order by 'orderDate'
  //         .get();

  //     // Map Firestore documents to OrderItem model using the fromMap method
  //     var orders = querySnapshot.docs.map((doc) {
  //       final data = doc.data() as Map<String, dynamic>;
  //       return OrderItem.fromMap(data); // Use the fromMap function here
  //     }).toList();

  //     orderList.assignAll(orders); // Update reactive order list
  //   } catch (e) {
  //     print(e.toString());
  //   } finally {
  //     isLoading(false); // Set loading to false
  //   }
  // }

  String formatDate(String dateString) {
    // Parse the date string into a DateTime object
    DateTime parsedDate = DateTime.parse(dateString);

    // Format the date to "yyyy-MM-dd" format or any other format you want
    String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

    return formattedDate;
  }
}
