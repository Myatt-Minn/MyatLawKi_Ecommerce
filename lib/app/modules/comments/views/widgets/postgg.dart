import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myat_ecommerence/app/data/consts_config.dart';
import 'package:myat_ecommerence/app/data/post_model.dart';
import 'package:myat_ecommerence/app/modules/comments/controllers/comments_controller.dart';

class PostCardGG extends GetView<CommentsController> {
  final Post post;
  const PostCardGG({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/comments', arguments: post);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Color(0xFF4C312E),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(),
            const SizedBox(height: 10),
            _buildDescriptionSection(),
            const SizedBox(height: 10),
            _buildImageSection(),
            const SizedBox(height: 10),
            Obx(
              () => _buildBottomSection(post, controller.commentLength.value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: AssetImage('assets/icon.png'),
          radius: 18,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            post.poster!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Text(
      post.description!,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
      ),
    );
  }

  Widget _buildImageSection() {
    return post.images!.isEmpty
        ? const SizedBox(height: 0)
        : ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              post.images![0].path!,
              fit: BoxFit.cover,
            ),
          );
  }

  Widget _buildBottomSection(Post post, int cmtLength) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: 12,
            ),
            Text(
              '$cmtLength Comments',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
        ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                backgroundColor: ConstsConfig.secondarycolor),
            child: Row(
              children: [
                Icon(Icons.message),
                SizedBox(
                  width: 4,
                ),
                Text("Comment")
              ],
            ))
      ],
    );
  }
}
