import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:myat_ecommerence/app/data/consts_config.dart';
import 'package:myat_ecommerence/app/data/post_model.dart';
import 'package:myat_ecommerence/app/data/tokenHandler.dart';

class FeedsController extends GetxController {
  var posts = <Post>[].obs;
  var isLoading = true.obs;
  var isLikeAnimating = false.obs;
  var isSavedClicked = false.obs;
  var commentLength = 0.obs;
  var isPostSaved = false.obs;

  Rx<Post> postData = Post().obs;

  final TextEditingController commentController = TextEditingController();


  RxBool isReply = false.obs;
  RxInt parent_id = 0.obs;

  RxInt replyID = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllPosts();
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
          'Content-Type': 'application/json',
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
}
