import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myat_ecommerence/app/data/comment_model.dart';
import 'package:myat_ecommerence/app/data/post_model.dart';

class CommentsController extends GetxController {
  //TODO: Implement CommentsController
  RxList<CommentModel> comments = RxList<CommentModel>();
  Post? post;
  TextEditingController commentController = TextEditingController();
  final userId = FirebaseAuth.instance.currentUser!.uid;
  var username = ''.obs;
  var profileImg = ''.obs;
  var isProfileImageChooseSuccess = false.obs;
  RxInt commentLength = 0.obs;

  @override
  void onInit() {
    super.onInit();
    post = Get.arguments;
    getCmtLen(post!.id.toString());
    // fetchComments();
    fetchUserData();
  }

  void getCmtLen(String postId) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("posts")
          .doc(postId)
          .collection("comments")
          .get();

      commentLength.value = snapshot.docs.length;
    } catch (err) {
      Get.snackbar("Error", "failed_to_fetch_data".tr);
    }
  }

  // Future<void> fetchComments() async {
  //   try {
  //     final snapshot = await FirebaseFirestore.instance
  //         .collection("posts")
  //         .doc(post!.id)
  //         .collection("comments")
  //         .orderBy('datePublished', descending: true)
  //         .get();
  //     comments.value = snapshot.docs.map((doc) {
  //       // Check if the document data is null
  //       final data = doc.data() as Map<String, dynamic>?;
  //       if (data == null) {
  //         throw Exception('Null data in document');
  //       }
  //       return CommentModel.fromMap(data);
  //     }).toList();
  //     getCmtLen(post!.postId);
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

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

  // Future<void> addComment(
  //     String text, String uid, String username, String userprofile) async {
  //   try {
  //     if (text.isNotEmpty) {
  //       final String cmtId = const Uuid().v1();

  //       // Create a CommentModel instance
  //       CommentModel comment = CommentModel(
  //         commentid: cmtId,
  //         postId: post!.postId,
  //         uid: uid,
  //         username: username,
  //         userProfileUrl: userprofile,
  //         text: text,
  //         datePublished: DateTime.now(),
  //       );

  //       // Use CommentModel's toMap() method to convert it to a Map<String, dynamic>
  //       await FirebaseFirestore.instance
  //           .collection("posts")
  //           .doc(post!.postId)
  //           .collection("comments")
  //           .doc(cmtId)
  //           .set(comment.toMap());

  //       Get.snackbar("Success", "Comment Added Successfully");

  //       fetchComments();
  //     } else {
  //       Get.snackbar("Error", "Please enter a comment.");
  //     }
  //   } catch (err) {
  //     Get.snackbar("Error", "Failed to add comment");
  //   }
  // }
}
