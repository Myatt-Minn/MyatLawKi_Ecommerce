import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myat_ecommerence/app/data/consts_config.dart';
import 'package:myat_ecommerence/app/data/post_model.dart';

class PostCard extends StatefulWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int _commentLength = 0;
  @override
  void initState() {
    super.initState();
    getCmtLen();
  }

  void getCmtLen() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("posts")
          .doc(widget.post.postId)
          .collection("comments")
          .get();

      setState(() {
        _commentLength = snapshot.docs.length;
      });
    } catch (err) {
      Get.snackbar("Error", "failed_to_fetch_data".tr);
    }
  }

  @override
  Widget build(BuildContext context) {
    var userId = FirebaseAuth.instance.currentUser!.uid;

    return GestureDetector(
      onTap: () {
        Get.toNamed('/comments', arguments: widget.post);
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
            _buildBottomSection(widget.post, userId, _commentLength),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(widget.post.profImg),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            widget.post.username,
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
      widget.post.description,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
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
        widget.post.postUrl,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildBottomSection(Post post, String userId, int cmtLength) {
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
