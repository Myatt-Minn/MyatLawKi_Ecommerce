import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:myat_ecommerence/app/data/consts_config.dart';
import 'package:myat_ecommerence/app/data/post_model.dart';
import 'package:myat_ecommerence/app/data/tokenHandler.dart';
import 'package:myat_ecommerence/app/data/user_model.dart';

import '../../../data/post_detail_model.dart';

class FeedsController extends GetxController {
  var posts = <Post>[].obs;
  var isLoading = true.obs;
  var isLikeAnimating = false.obs;
  var isSavedClicked = false.obs;
  var commentLength = 0.obs;
  var isPostSaved = false.obs;
  var userID = 0;

  final TextEditingController commentController = TextEditingController();

  RxBool isReply = false.obs;
  RxInt parent_id = 0.obs;

  RxInt replyID = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllPosts();
  }

  Future<bool> checkAndPromptLogin() async {
    final authService = Tokenhandler();
    final token = await authService.getToken();

    if (token == null) {
      Get.defaultDialog(
        title: "login_first".tr,
        titleStyle: TextStyle(color: Colors.white),
        middleTextStyle: TextStyle(color: Colors.white),
        backgroundColor: ConstsConfig.primarycolor,
        confirmTextColor: Colors.black,
        buttonColor: Colors.white,
        content: Text(
          'to_proceed'.tr,
          style: TextStyle(color: Colors.white),
        ),
        textConfirm: "OK",
        onConfirm: () {
          Get.offNamed('/login'); // Navigate to the login screen
        },
      );
      return false;
    } else {
      fetchUserData();
      return true;
    }
  }

  void checkLogin() async {
    final authService = Tokenhandler();
    final token = await authService.getToken();

    if (token == null) {
      Get.defaultDialog(
        title: "login_first".tr,
        titleStyle: TextStyle(color: Colors.white),
        middleTextStyle: TextStyle(color: Colors.white),
        backgroundColor: ConstsConfig.primarycolor,
        confirmTextColor: Colors.black,
        buttonColor: Colors.white,
        content: Text(
          'to_proceed'.tr,
          style: TextStyle(color: Colors.white),
        ),
        textConfirm: "OK",
        onConfirm: () {
          Get.offNamed('/login'); // Navigate to the login screen
        },
      );
    } else {
      // Proceed to checkout if logged in
      Get.toNamed('/notification');
    }
  }

  Future<void> fetchAllPosts({int page = 1, int limit = 20}) async {
    final url = '$baseUrl/api/v1/posts?page=$page&limit=$limit';
    final authService = Tokenhandler();
    final token = await authService.getToken();

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Application': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        // Check if 'data' key exists and is a list
        if (jsonData['data'] is List) {
          posts.value = (jsonData['data'] as List)
              .map((data) => Post.fromJson(data))
              .toList();
        } else {
          Get.snackbar("GG", "GG");
        }
      } else {
        Get.snackbar("Fail", "Failed to load posts");
      }
    } catch (e) {
      Get.snackbar("Error", "Error fetching posts: $e");
    }
  }

  RxBool isCommentLoading = false.obs;

  Future<void> comment(
      {required int post_id,
      required int userID,
      required String body,
      required int parient_id}) async {
    var loading = BotToast.showCustomLoading(
        toastBuilder: (_) => const Center(
              child: CircularProgressIndicator(
                color: ConstsConfig.primarycolor,
              ),
            ));
    isCommentLoading.value = true;
    FocusManager.instance.primaryFocus?.unfocus();
    final url = '$baseUrl/api/v1/posts/$post_id/comment';
    final authService = Tokenhandler();
    final token = await authService.getToken();

    final Map<String, String> formData;
    if (isReply.value == false) {
      formData = {
        "user_id": userID.toString(),
        "post_id": post_id.toString(),
        "body": body.toString(),
      };
    } else {
      formData = {
        "user_id": userID.toString(),
        "body": body.toString(),
        "parent_id": parient_id.toString(),
      };
    }

    try {
      final response = await http.post(
        Uri.parse(url),
        body: formData,
        headers: {
          'Authorization': 'Bearer $token',
          'Application': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print("ResponComment>>>${response.body}");
        isCommentLoading.value = false;
        commentController.text = "";
        getPostDetail(post_id: post_id);
      } else {
        Get.snackbar("Fail", "Failed to load posts");
      }
    } catch (e) {
      isCommentLoading.value = false;

      Get.snackbar("Error", "Error fetching posts: $e");
    } finally {
      BotToast.closeAllLoading();
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  Rx<Post> postData = Post().obs;
  RxBool isPostLoading = false.obs;
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
          var currentUser = UserModel.fromJson(jsonData['data']);
          userID = currentUser.id;
        } else {
          Get.snackbar("Error", "Error fetching data");
        }
      } else {
        Get.snackbar("Fail", "Error fetching data");
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return;
    }
  }

  Future<void> getPostDetail({required int post_id}) async {
    isCommentLoading.value = true;

    final url = '$baseUrl/api/v1/posts/$post_id';
    final authService = Tokenhandler();
    final token = await authService.getToken();

    try {
      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Application': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final PostsDetailModel postModel =
            PostsDetailModel.fromJson(jsonDecode(response.body));
        postData.value = postModel.data!;
        for (var i = 0; i < postData.value.comments!.length; i++) {
          if (postData.value.comments![i].id == parent_id.value) {
            postData.value.comments![i].replyShow = true;
          }
        }
        isCommentLoading.value = false;
        fetchAllPosts();
      } else {
        Get.snackbar("Fail", "Failed to load posts");
      }
    } catch (e) {
      isCommentLoading.value = false;

      Get.snackbar("Error", "Error fetching posts: $e");
    } finally {
      BotToast.closeAllLoading();
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}
