import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:myat_ecommerence/app/data/consts_config.dart';

class VerificationController extends GetxController {
  var email = ''.obs; // The email transferred from ForgotPasswordView
  var code = ''.obs; // For storing the entered verification code
  var isLoading = false.obs;
  var timer = 10.obs; // Countdown timer in seconds

  // Initialize email from arguments and start the timer
  @override
  void onInit() {
    super.onInit();
    email.value = Get.arguments ??
        ''; // Retrieve the email passed from ForgotPasswordView
    startTimer();
  }

  // Countdown timer logic
  void startTimer() {
    timer.value = 10; // Reset timer to 10 seconds
    Future.doWhile(() async {
      if (timer.value <= 0) return false;
      await Future.delayed(const Duration(seconds: 1));
      timer.value--;
      return true;
    });
  }

  // Code validation: Ensures the code has the required length (adjust as needed)
  bool get isValidCode => code.value.length == 6;

  // Function to verify the code
  Future<void> verifyCode() async {
    if (!isValidCode) {
      Get.snackbar('Error', 'Please enter a valid 4-digit code',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse(
            '$baseUrl/api/v1/forgot-password-code/verify'), // Replace {{url}} with your base URL
        headers: {'Content-Type': 'application/json'},
        body: '{"email": "${email.value}", "code": "${code.value}"}',
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Verification successful!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
        // Navigate to Reset Password page (or next step)
        Get.toNamed('/changepassword', arguments: email.value);
      } else {
        Get.snackbar('Error', 'Invalid verification code. Try again.',
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
