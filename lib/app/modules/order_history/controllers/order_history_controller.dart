import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:myat_ecommerence/app/data/order_model.dart';

class OrderHistoryController extends GetxController {
  //TODO: Implement OrderHistoryController

  var orderList = <OrderItem>[].obs; // Reactive list to store orders
  var isLoading = true.obs;

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
