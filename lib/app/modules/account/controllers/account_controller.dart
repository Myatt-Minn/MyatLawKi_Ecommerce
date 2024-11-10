import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myat_ecommerence/app/data/consts_config.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountController extends GetxController {
  var username = ''.obs;
  var profileImg = ''.obs;
  var selectedLanguage = 'ENG'.obs;
  var goDarkMode = true.obs;
  var notificationsEnabled = true.obs;
  var languageSelected = 'English'.obs;
  var isProfileImageChooseSuccess = false.obs;
  late File file;
  final storage = GetStorage();
  final String userId =
      FirebaseAuth.instance.currentUser!.uid; // Replace with actual user ID

  @override
  void onInit() {
    super.onInit();
    goDarkMode.value = false;
    fetchUserData(); // Fetch profile pic when the controller initializes
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

  void signOut() {
    FirebaseAuth.instance.signOut();
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

  void goToWebsite() async {
    Uri url = Uri.parse(ConstsConfig.websiteLink);
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
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.red),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              deleteUser();
              Get.back(); // Close the dialog after action
              Get.snackbar(
                'Account Deleted',
                'Your account has been successfully deleted.',
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
            child: const Text('Delete'),
          ),
        ],
      ),
      barrierDismissible: false, // Prevent dismissing by tapping outside
    );
  }

  Future<void> deleteUser() async {
    try {
      // Delete user data from Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).delete();

      // Delete user account from Firebase Authentication
      await FirebaseAuth.instance.currentUser!.delete();

      Get.snackbar(
        'Account Deleted',
        'Your account has been successfully deleted.',
        backgroundColor: ConstsConfig.primarycolor,
        colorText: Colors.white,
      );
    } catch (e) {
      if (e is FirebaseAuthException && e.code == 'requires-recent-login') {
        print('Error: User needs to re-authenticate before account deletion.');
        // Handle re-authentication here if needed
      } else {
        print('Error deleting user: $e');
      }
    }
  }

  // Function to retrieve the profile picture from Firestore
  Future<void> fetchUserData() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (userDoc.exists && userDoc.data() != null) {
        // Assuming that the profile pic URL is stored in the 'profilepic' field
        profileImg.value = userDoc['profilepic'] ??
            ''; // Use an empty string if the field is null
        username.value = userDoc['name'];

        isProfileImageChooseSuccess.value = true;
      } else {
        Get.snackbar('Error', 'User document does not exist.');
      }
    } catch (e) {
      Get.snackbar('Error', 'failed_to_fetch_data'.tr);
    }
  }
}
