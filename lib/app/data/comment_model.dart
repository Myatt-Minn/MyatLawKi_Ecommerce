class CommentModel {
  int id;
  int userId;
  String poster;
  String image;
  int postId;
  String body;
  String createdAt;

  CommentModel({
    required this.id,
    required this.userId,
    required this.poster,
    required this.image,
    required this.postId,
    required this.body,
    required this.createdAt,
  });

  // Factory constructor to create CommentModel from Firestore document data
  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'],
      userId: (map['user_id']),
      poster: map['poster'],
      image: map['image'],
      postId: map['post_id'],
      body: map['body'],
      createdAt: map['created_at'],
    );
  }
}
