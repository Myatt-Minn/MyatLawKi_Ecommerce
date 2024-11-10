import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String username;
  final String postId;
  final DateTime datePublished;
  final String description;
  final String postUrl;
  final String profImg;
  final List likes;
  const Post(
      {required this.username,
      required this.postId,
      required this.datePublished,
      required this.description,
      required this.postUrl,
      required this.profImg,
      required this.likes});

  static Post fromSnap(DocumentSnapshot snapshot) {
    var snap = (snapshot.data() as Map<String, dynamic>);

    return Post(
      username: snap["username"],
      description: snap["description"],
      postId: snap["postId"],
      datePublished:
          (snap['datePublished'] as Timestamp?)?.toDate() ?? DateTime.now(),
      postUrl: snap["postUrl"],
      profImg: snap["profileImg"],
      likes: snap['likes'] ?? [],
    );
  }
}
