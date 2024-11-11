import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
// Future<void> login(String email, String password) async {
//   final url = 'https://your-api-url/api/v1/login';
//   final response = await http.post(
//     Uri.parse(url),
//     headers: {'Content-Type': 'application/json'},
//     body: json.encode({'email': email, 'password': password}),
//   );

//   if (response.statusCode == 200) {
//     final jsonData = json.decode(response.body);
//     final token = jsonData['token']; // Adjust according to your API response

//     // Save the token in SharedPreferences
//     final authService = AuthService();
//     await authService.saveToken(token);

//     // Navigate to the home page or perform other actions after login
//   } else {
//     throw Exception('Failed to login');
//   }
// }

  // Login function
  Future<void> loginUser() async {
    // Clear any previous error messages
    emailError.value = '';
    passwordError.value = '';
    generalError.value = '';

    // Validate input
    if (!validateInput()) {
      return;
    }

    // Start loading
    isLoading.value = true;

    try {
      // Attempt to sign in with email and password
      await _auth.signInWithEmailAndPassword(
        email: phoneController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      // Handle login errors
      if (e.code == 'user-not-found') {
        generalError.value = 'No user found with this email.';
      } else if (e.code == 'wrong-password') {
        generalError.value = 'Incorrect password.';
      } else {
        generalError.value = 'User not Signed Up/Incorrect Password';
      }
    } catch (e) {
      generalError.value = 'An unexpected error occurred. Please try again.';
    } finally {
      // Stop loading
      isLoading.value = false;
    }
  }

  // Input validation function
  bool validateInput() {
    bool isValid = true;

    // Email validation
    if (phoneController.text.trim().isEmpty) {
      emailError.value = 'Please enter your phone number.';
      isValid = false;
    } else if (!GetUtils.isEmail(phoneController.text.trim())) {
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
