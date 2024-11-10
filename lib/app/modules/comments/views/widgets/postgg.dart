import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myat_ecommerence/app/data/consts_config.dart';
import 'package:myat_ecommerence/app/data/post_model.dart';
import 'package:myat_ecommerence/app/modules/Feeds/controllers/feeds_controller.dart';

class PostGG extends StatelessWidget {
  final Post post;
  const PostGG({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    var userId = FirebaseAuth.instance.currentUser!.uid;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
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
          _buildBottomSection(post, userId),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(post.profImg),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            post.username,
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
      post.description,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
      ),
    );
  }

  Widget _buildImageSection() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        post.postUrl,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildBottomSection(Post post, String userId) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: 12,
            ),
            Text(
              '${Get.find<FeedsController>().commentLength} Comments',
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
