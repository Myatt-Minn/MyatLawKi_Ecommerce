import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:myat_ecommerence/app/data/consts_config.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();
  var isLoading = false.obs;
  var isValidEmail = true.obs;

  // Email validation
  void validateEmail() {
    isValidEmail.value =
        RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
            .hasMatch(emailController.text.trim());
  }

  // Send forgot password request to API
  Future<void> sendForgotPasswordRequest() async {
    validateEmail();
    if (!isValidEmail.value) {
      Get.snackbar('Error', 'Please enter a valid email address',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse(
            '$baseUrl/api/v1/forgot-password'), // Replace `$baseUrl` with your API base URL
        headers: {'Content-Type': 'application/json'},
        body: '{"email": "${emailController.text.trim()}"}',
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Password reset link sent to your email',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);

        // Navigate to the Verification page and pass email as an argument
        Get.toNamed('/verification', arguments: emailController.text.trim());
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        Get.snackbar('Error', 'Failed to send reset link. Try again.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      print('Exception: $e');
      Get.snackbar('Error', '$e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
