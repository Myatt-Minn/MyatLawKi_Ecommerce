import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:myat_ecommerence/app/data/consts_config.dart';
import 'package:myat_ecommerence/app/data/tokenHandler.dart';

class LoginController extends GetxController {
  // Controllers for TextFields
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  // Reactive variables
  var isPasswordHidden = true.obs; // To toggle password visibility
  var isLoading = false.obs; // To show a loading indicator
  var emailError = ''.obs; // Validation error for email
  var passwordError = ''.obs; // Validation error for password
  var generalError = ''.obs; // General error message for login failure

  Future<void> login() async {
    if (validateInput()) {
      try {
        final url = '$baseUrl/api/v1/login';
        final response = await http.post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'emailOrPhone': phoneController.text,
            'password': passwordController.text,
            'fcm_token_key': phoneController.text,
          }),
        );

        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);
          final token =
              jsonData['token']; // Adjust according to your API response

          // Save the token in SharedPreferences
          final authService = Tokenhandler();
          await authService.saveToken(token);

          // Navigate to the home page or perform other actions after login
          Get.offAllNamed('/navigation-screen');
        } else {
          print("Response status code: ${response.statusCode}");
          print("Response body: ${response.body}");
          Get.snackbar('Error', "Fail to signup",
              snackPosition: SnackPosition.BOTTOM);
        }
      } catch (e) {
        Get.snackbar('Error', e.toString(),
            snackPosition: SnackPosition.BOTTOM);
      }
    } else {
      Get.snackbar('Error', "Please fill all the fields",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Input validation function
  bool validateInput() {
    bool isValid = true;

    // Email validation
    if (phoneController.text.trim().isEmpty) {
      emailError.value = 'Please enter your phone number.';
      isValid = false;
    } else if (!GetUtils.isNum(phoneController.text.trim())) {
      emailError.value = 'Please enter a valid phone number.';
      isValid = false;
    }

    // Password validation
    if (passwordController.text.trim().isEmpty) {
      passwordError.value = 'Please enter your password.';
      isValid = false;
    } else if (passwordController.text.trim().length < 6) {
      passwordError.value = 'Password must be at least 6 characters long.';
      isValid = false;
    }

    return isValid;
  }

  // Clear error messages on text change
  void clearErrorMessages() {
    emailError.value = '';
    passwordError.value = '';
    generalError.value = '';
  }

  // Dispose controllers when not needed
  @override
  void onClose() {
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
