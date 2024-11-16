import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:myat_ecommerence/app/data/consts_config.dart';

class ChangepasswordController extends GetxController {
  var email = ''.obs; // Passed from the previous page
  var newPassword = ''.obs;
  var confirmPassword = ''.obs;
  var isPasswordHidden = true.obs; // For toggling visibility
  var isConfirmPasswordHidden = true.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    email.value = Get.arguments ?? ''; // Get email from previous page
  }

  // Function to update the password
  Future<void> updatePassword() async {
    if (newPassword.value.isEmpty || confirmPassword.value.isEmpty) {
      Get.snackbar('Error', 'Both fields are required.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }
    if (newPassword.value != confirmPassword.value) {
      Get.snackbar('Error', 'Passwords do not match.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse(
            '$baseUrl/api/v1/update-password'), // Replace $baseUrl with your base URL
        headers: {'Content-Type': 'application/json'},
        body:
            '{"email": "${email.value}", "password": "${newPassword.value}", "password_confirmation": "${confirmPassword.value}"}',
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Password updated successfully!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
        Get.offAllNamed('/login'); // Redirect to login page
      } else {
        Get.snackbar('Error', 'Failed to update password. Please try again.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}
