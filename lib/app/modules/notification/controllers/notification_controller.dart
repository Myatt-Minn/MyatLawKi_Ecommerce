import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:myat_ecommerence/app/data/consts_config.dart';
import 'package:myat_ecommerence/app/data/notification_model.dart';
import 'package:myat_ecommerence/app/data/tokenHandler.dart';

class NotificationController extends GetxController {
  RxList<NotificationModel> notifications = RxList<NotificationModel>();
  RxList<NotificationModel> usernotifications = RxList<NotificationModel>();
  RxBool isViewingAllNotifications = true.obs;
  @override
  void onInit() async {
    super.onInit();
    fetchNotifications();
    // getUserNotifications();
  }

  // Getter for cart item count
  int get itemCount => notifications.length;

  // Function to toggle between all notifications and user's notifications
  void toggleNotificationView() {
    isViewingAllNotifications.value = !isViewingAllNotifications.value;
    // getUserNotifications();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    final url = '$baseUrl/api/v1/notifications';
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
          notifications.value = (jsonData['data'] as List)
              .map((data) => NotificationModel.fromDocument(data))
              .toList();
        } else {
          throw Exception('Invalid data format');
        }
      } else {
        throw Exception('Failed to load banners');
      }
    } catch (e) {
      print('Error fetching notifications: $e');
    }
  }

  // Future<void> deleteNotification(NotificationModel notification) async {
  //   try {
  //     // Get the current user's ID
  //     String userId = FirebaseAuth.instance.currentUser!.uid;

  //     // Update the user's document in Firestore to remove the notification
  //     await FirebaseFirestore.instance.collection('users').doc(userId).update({
  //       'notifications': FieldValue.arrayRemove([
  //         {
  //           'id': notification.id,
  //           'title': notification.title,
  //           'body': notification.body,

  //           // Include any other fields that make up the notification object
  //         }
  //       ])
  //     });

  //     // Remove from local state
  //     usernotifications.removeWhere((item) => item.id == notification.id);

  //     // Show success message
  //     Get.snackbar('succeed'.tr, 'Notification deleted successfully.');
  //   } catch (e) {
  //     print('Error deleting notification: $e');
  //     Get.snackbar('Error', 'Failed to delete notification: $e');
  //   }
  // }
}
