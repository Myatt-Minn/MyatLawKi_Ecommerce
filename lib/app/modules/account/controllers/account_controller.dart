import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:myat_ecommerence/app/data/consts_config.dart';
import 'package:myat_ecommerence/app/data/tokenHandler.dart';
import 'package:myat_ecommerence/app/data/user_model.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountController extends GetxController {
  var currentUser = Rxn<UserModel>();
  var selectedLanguage = 'ENG'.obs;
  var goDarkMode = true.obs;
  var notificationsEnabled = true.obs;
  var languageSelected = 'English'.obs;
  var isProfileImageChooseSuccess = false.obs;
  late File file;
  final storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    goDarkMode.value = false;
    fetchUserData();
    selectedLanguage.value = storage.read('language') ?? 'ENG';
    updateLocale();
  }

  void updateLocale() {
    if (selectedLanguage.value == 'ENG') {
      Get.updateLocale(const Locale('en', 'US'));
    } else {
      Get.updateLocale(const Locale('my', 'MM'));
    }
  }

  void toggleLanguage(String language) {
    selectedLanguage.value = language;
    storage.write('language', language); // Save to storage
    updateLocale(); // Apply the new language
  }

  void toggleDarkMode() {
    goDarkMode.value = !goDarkMode.value;
    Get.isDarkMode
        ? Get.changeTheme(ThemeData.light())
        : Get.changeTheme(ThemeData.dark());
  }

  void toggleNotifications() {
    notificationsEnabled.value = !notificationsEnabled.value;
  }

  void changeLanguage(String language) {
    languageSelected.value = language;
  }

  Future<void> logout() async {
    Get.offAllNamed('/login');
    Tokenhandler().clearToken();
  }

  Future<void> makePhoneCall() async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: ConstsConfig.phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $ConstsConfig.phoneNumber';
    }
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
        } else {
          // Get.snackbar("Error", "Error fetching data");
        }
      } else {
        // Get.snackbar("Fail", "Error fetching data");
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return;
    }
  }

  void goToWebsite() async {
    Uri url = Uri.parse(ConstsConfig.termsAndConditionLink);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar(
        'Cannot open the website',
        'Something wrong with Internet Connection or the app!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void showDeleteAccountDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        title: const Text(
          'Confirm Deletion',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to delete this account?',
          style: TextStyle(color: Colors.grey[700]),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Close the dialog without doing anything
              Get.back();
            },
            child: Text(
              'cancel'.tr,
              style: TextStyle(color: Colors.red),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back(); // Close the dialog after action
              Get.snackbar(
                'အောင်မြင်သည်',
                'အကောင့်ဖျက်မှုအောင်မြင်ပါသည်',
                backgroundColor: ConstsConfig.primarycolor,
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, // Button color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
            child: const Text('ဖျက်ရန်'),
          ),
        ],
      ),
      barrierDismissible: false, // Prevent dismissing by tapping outside
    );
  }
}
