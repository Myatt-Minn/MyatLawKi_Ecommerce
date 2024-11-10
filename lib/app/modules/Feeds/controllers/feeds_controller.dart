import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
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
    fetchPosts();
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

  Future<void> fetchPosts() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('posts')
          .orderBy('datePublished', descending: true)
          .get();

      posts.value = snapshot.docs.map((doc) => Post.fromSnap(doc)).toList();
    } catch (e) {
      print('Error fetching posts: $e');
    } finally {
      isLoading.value = false; // Set loading to false after fetching posts
    }
  }
}
