import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:myat_ecommerence/app/data/consts_config.dart';
import 'package:myat_ecommerence/app/data/post_model.dart';

class FeedsController extends GetxController {
  var posts = <Post>[].obs;
  var isLoading = true.obs;
  var isLikeAnimating = false.obs;
  var isSavedClicked = false.obs;
  var commentLength = 0.obs;
  var isPostSaved = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllPosts();
  }

  Future<int> getCommentLength(String postId) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("posts")
          .doc(postId)
          .collection("comments")
          .get();
      commentLength.value = snapshot.docs.length;
      return snapshot.docs.length;
    } catch (err) {
      Get.snackbar('Error', err.toString());
      return 0;
    }
  }

  Future<void> fetchAllPosts() async {
    final url = '$baseUrl/api/v1/posts';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        // Parse each JSON object in the list and add it to the posts list
        posts.value = jsonData.map((data) => Post.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      print('Error fetching posts: $e');
    }
  }

  // Future<void> fetchPosts() async {
  //   try {
  //     QuerySnapshot snapshot = await FirebaseFirestore.instance
  //         .collection('posts')
  //         .orderBy('datePublished', descending: true)
  //         .get();

  //     posts.value = snapshot.docs.map((doc) => Post.fromJson(doc)).toList();
  //   } catch (e) {
  //     print('Error fetching posts: $e');
  //   } finally {
  //     isLoading.value = false; // Set loading to false after fetching posts
  //   }
  // }
}
