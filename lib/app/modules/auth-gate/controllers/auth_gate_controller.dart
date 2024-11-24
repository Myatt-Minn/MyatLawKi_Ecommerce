import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:myat_ecommerence/app/data/constsconfig.dart';
import 'package:myat_ecommerence/app/data/tokenHandler.dart';

class AuthGateController extends GetxController {
  //TODO: Implement AuthGateController

  final Connectivity _connectivity = Connectivity();
  RxBool hasInternet = true.obs; // Observable for internet connection status
  var isLoading = false.obs;
  var selectedLanguage = 'ENG'.obs;

  @override
  void onInit() {
    super.onInit();
    // Listen for connectivity changes
    // Listen for connectivity changes using the connectivity_plus stream
    _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      // Check if the list contains any active network connection type
      if (results.contains(ConnectivityResult.none)) {
        hasInternet.value = false;
        Get.toNamed('/no-internet');
        isLoading.value = false;
      } else {
        hasInternet.value = true;
        _checkAuthentication();
      }
    });

    // Initial check for internet and authentication
    _checkInternetConnection();
  }

  _checkInternetConnection() async {
    isLoading.value = true; // Start loading
    final result = await _connectivity.checkConnectivity();
    if (result.contains(ConnectivityResult.none)) {
      hasInternet.value = false;
      Get.offAndToNamed('/no-internet');
      isLoading.value = false; // Stop loading if there's no connection
    } else {
      hasInternet.value = true;
      isLoading.value = false; // Stop loading when connection is restored
      _checkAuthentication();
    }
    isLoading.value = false; // Stop loading after the check
  }

  Future<void> _checkAuthentication() async {
    isLoading.value = true;
    final authService = Tokenhandler();
    final token = await authService.getToken();

    if (token == null) {
      isLoading.value = false;
      // Navigate to main screen
      Get.offAllNamed('/navigation-screen');
      return;
    }

    try {
      final url = '$baseUrl/api/v1/customer';
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
          final userData = jsonData['data'];
          // Navigate to main screen
          Get.offAllNamed('/navigation-screen');
        } else {
          // Invalid response, navigate to login
          Get.offNamed('/login');
        }
      } else {
        // Token might be invalid or expired, navigate to login
        Get.offNamed('/login');
      }
    } catch (error) {
      print('Error checking authentication: $error');
      Get.offNamed('/login');
    } finally {
      isLoading.value = false;
    }
  }

  retryConnection() {
    _checkInternetConnection();
  }
}
