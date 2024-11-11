import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final int commentid;
  final String username;
  final String userProfileUrl;
  final String text;
  final DateTime datePublished;
  final String uid;
  final String postId;

  CommentModel({
    required this.commentid,
    required this.username,
    required this.userProfileUrl,
    required this.text,
    required this.datePublished,
    required this.uid,
    required this.postId,
  });

  // Factory constructor to create CommentModel from Firestore document data
  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      commentid: map['commentid'],
      username: map['username'] ?? '',
      userProfileUrl: map['userProfileUrl'] ?? '',
      text: map['text'] ?? '',
      datePublished: (map['datePublished'] as Timestamp).toDate(),
      uid: map['uid'] ?? '',
      postId: map['postId'] ?? '',
    );
  }

  // Convert CommentModel to map for storing in Firestore
  Map<String, dynamic> toMap() {
    return {
      'commentid': commentid,
      'username': username,
      'userProfileUrl': userProfileUrl,
      'text': text,
      'datePublished': Timestamp.fromDate(datePublished),
      'uid': uid,
      'postId': postId,
    };
  }
}
