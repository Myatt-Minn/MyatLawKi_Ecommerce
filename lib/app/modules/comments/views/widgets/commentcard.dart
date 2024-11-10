import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:myat_ecommerence/app/data/comment_model.dart';
import 'package:myat_ecommerence/app/modules/comments/controllers/comments_controller.dart';

class CmtCard extends GetView<CommentsController> {
  final CommentModel comment;
  const CmtCard({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: Colors.white),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(comment.userProfileUrl),
              radius: 18,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: comment.username,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        TextSpan(
                          text: " ${comment.text}",
                          style: const TextStyle(color: Colors.black),
                        ),
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        DateFormat.yMMMd().format(comment.datePublished),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Container(
            //   padding: const EdgeInsets.all(8),
            //   child: IconButton(
            //     onPressed: () {
            //       setState(() {
            //         commentLiked = true;
            //       });
            //     },
            //     icon: commentLiked
            //         ? const Icon(
            //             Icons.favorite,
            //             color: Colors.red,
            //           )
            //         : const Icon(Icons.favorite_border_outlined),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
