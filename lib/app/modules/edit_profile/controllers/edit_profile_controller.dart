import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:myat_ecommerence/app/data/consts_config.dart';
import 'package:myat_ecommerence/app/data/tokenHandler.dart';
import 'package:myat_ecommerence/app/data/user_model.dart';
import 'package:myat_ecommerence/app/modules/account/controllers/account_controller.dart';
import 'package:path/path.dart';

class EditProfileController extends GetxController {
  var currentUser = Rxn<UserModel>();
  var isLoading = false.obs;
  var isProfileImageChooseSuccess = false.obs;
  File? profileImage;
  var prof = ''.obs;

  // Text controllers for the TextFields
  late TextEditingController fullNameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;

  // Show error message if validation fails
  var showError = false.obs;

  @override
  void onReady() {
    super.onReady();
    isProfileImageChooseSuccess.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    fullNameController = TextEditingController();
    phoneController = TextEditingController();
    emailController = TextEditingController();
    fetchUserData(); // Fetch user data when the controller initializes
  }

  // Fetch current user data from API
  Future<void> fetchUserData() async {
    final url = '$baseUrl/api/v1/customer';
    final token = await Tokenhandler().getToken();

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
          emailController.text = currentUser.value!.email;
          fullNameController.text = currentUser.value!.name;
          phoneController.text = currentUser.value!.phone;
        } else {
          Get.snackbar("Error", "Error fetching data");
        }
      } else {
        Get.snackbar("Fail", "Error fetching data");
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  // Validate fields
  bool validateFields() {
    return fullNameController.text.isNotEmpty &&
        phoneController.text.isNotEmpty;
  }

  // Check if a field is empty
  bool isEmpty(TextEditingController controller) {
    return controller.text.isEmpty;
  }

  // Function to choose an image from File Picker
  Future<void> chooseImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      profileImage = File(result.files.single.path!);
      isProfileImageChooseSuccess.value = true;
    } else {
      Get.snackbar("cancel".tr, "No Image");
    }
  }

  // Function to update user profile
  Future<void> updateUserProfile() async {
    if (!validateFields()) {
      showError.value = true;
      return;
    }

    final url = '$baseUrl/api/v1/customer?_method=PUT';
    final token = await Tokenhandler().getToken();

    try {
      final request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers['Authorization'] = 'Bearer $token';

      // Add text fields
      request.fields['name'] = fullNameController.text;
      request.fields['phone'] = phoneController.text;
      request.fields['email'] = emailController.text;

      // Add image file if selected
      if (profileImage != null) {
        final fileName = basename(profileImage!.path);
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          profileImage!.path,
          filename: fileName,
        ));
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final jsonData = json.decode(responseBody);

        if (jsonData['success'] == true) {
          currentUser.value = UserModel.fromJson(jsonData['data']);
          Get.snackbar("Success", "Profile updated successfully");
          Get.find<AccountController>().fetchUserData();
        } else {
          Get.snackbar("Error", "Failed to update profile");
        }
      } else {
        print('Failed to update profile. Status code: ${response.statusCode}');
        Get.snackbar("Update Failed", "Could not update profile data");
      }
    } catch (e) {
      print('Error updating profile: $e');
      Get.snackbar("Error", "An error occurred while updating profile");
    }
  }
}
