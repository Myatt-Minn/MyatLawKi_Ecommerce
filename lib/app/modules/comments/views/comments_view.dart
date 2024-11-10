import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myat_ecommerence/app/data/consts_config.dart';
import 'package:myat_ecommerence/app/data/post_model.dart';
import 'package:myat_ecommerence/app/modules/comments/views/widgets/commentcard.dart';
import 'package:myat_ecommerence/app/modules/comments/views/widgets/postgg.dart';

import '../controllers/comments_controller.dart';

class CommentsView extends GetView<CommentsController> {
  const CommentsView({super.key});

  @override
  Widget build(BuildContext context) {
    Post post = Get.arguments;
    return Scaffold(
      backgroundColor: ConstsConfig.primarycolor,
      appBar: AppBar(
        title: const Text("Comments"),
      ),
      body: SingleChildScrollView(
        // Make the entire screen scrollable
        child: Column(
          children: [
            PostGG(post: post),
            SizedBox(height: 8),
            Obx(
              () => controller.comments.isEmpty
                  ? Center(
                      child: Text("There is no comments yet"),
                    )
                  : ListView.builder(
                      shrinkWrap:
                          true, // Makes ListView behave like a non-scrollable child
                      physics:
                          NeverScrollableScrollPhysics(), // Prevents ListView from scrolling
                      itemCount: controller.comments.length,
                      itemBuilder: (context, index) {
                        final comment = controller.comments[index];
                        return CmtCard(comment: comment);
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Obx(
          () => Container(
            color: Colors.white,
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(controller.profileImg.value),
                  radius: 18,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: TextField(
                      controller: controller.commentController,
                      decoration: const InputDecoration(
                        hintText: "Enter your comment..",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (controller.commentController.text.isNotEmpty) {
                      controller.addComment(
                        controller.commentController.text,
                        controller.userId,
                        controller.username.value,
                        controller.profileImg.value,
                      );
                      controller.commentController.clear();
                    }
                  },
                  child: const Text(
                    "Post",
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
