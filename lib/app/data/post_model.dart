import 'package:myat_ecommerence/app/data/comment_model.dart';

class Post {
  final int id;
  final int userId;
  final String poster;
  final String description;
  final List<PostImage> images;
  final List<CommentModel> comments;

  Post({
    required this.id,
    required this.userId,
    required this.poster,
    required this.description,
    required this.images,
    required this.comments,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      userId: json['user_id'],
      poster: json['poster'],
      description: json['description'],
      images: (json['images'] as List)
          .map((item) => PostImage.fromJson(item))
          .toList(),
      comments: (json['comments'] as List)
          .map((item) => CommentModel.fromMap(item))
          .toList(),
    );
  }
}

class PostImage {
  final int id;
  final int postId;
  final String path;
  final String description;

  PostImage({
    required this.id,
    required this.postId,
    required this.path,
    required this.description,
  });

  factory PostImage.fromJson(Map<String, dynamic> json) {
    return PostImage(
      id: json['id'],
      postId: json['post_id'],
      path: json['path'],
      description: json['description'],
    );
  }
}
