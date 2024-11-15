import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:myat_ecommerence/app/data/comment_model.dart';
import 'package:myat_ecommerence/app/data/consts_config.dart';
import 'package:myat_ecommerence/app/data/post_model.dart';
import 'package:myat_ecommerence/app/data/tokenHandler.dart';
import 'package:myat_ecommerence/app/data/user_model.dart';
import 'package:myat_ecommerence/app/modules/Feeds/controllers/feeds_controller.dart';

class CommentsController extends GetxController {
  //TODO: Implement CommentsController
  RxList<CommentModel> comments = RxList<CommentModel>();
  Post? post;
  TextEditingController commentController = TextEditingController();
  var isProfileImageChooseSuccess = false.obs;
  RxInt commentLength = 0.obs;
  var currentUser = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    post = Get.arguments;
    comments.value = post!.comments!;
    commentLength.value = comments.length;

    fetchUserData();
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

  Future<void> addComment(int postId, String commentText) async {
    final url = '$baseUrl/api/v1/posts/$postId/comment';
    final authService =
        Tokenhandler(); // Assuming you have a token handler class
    final token =
        await authService.getToken(); // Retrieve the saved bearer token

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'user_id': currentUser.value!.id,
          'post_id': postId,
          'body': commentText, // Replace 'comment' key based on API requirement
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Submitted", 'လုပ်ဆောင်မှုအောင်မြင်ပါသည်');
        // getAllComments(postId);
        final responseData = json.decode(response.body);

        // Convert responseData to CommentModel and add to comments
        final newComment = CommentModel.fromJson(responseData['data']);
        comments.add(newComment);
        Get.find<FeedsController>().fetchAllPosts();
      } else {
        print('Failed to add comment. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error adding comment: $e');
    }
  }
}
