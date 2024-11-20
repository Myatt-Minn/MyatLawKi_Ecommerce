import 'package:myat_ecommerence/app/data/comment_model.dart';

class Post {
  int? id;
  int? userId;
  String? poster;
  String? description;
  List<PostImage>? images;
  List<CommentModel>? comments;
  String? createdAt;
  String? updatedAt;

  Post(
      {this.id,
      this.userId,
      this.poster,
      this.description,
      this.images,
      this.comments,
      this.createdAt,
      this.updatedAt});

  Post.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    poster = json['poster'];
    description = json['description'];
    if (json['images'] != null) {
      images = <PostImage>[];
      json['images'].forEach((v) {
        images!.add(PostImage.fromJson(v));
      });
    }
    if (json['comments'] != null) {
      comments = <CommentModel>[];
      json['comments'].forEach((v) {
        comments!.add(CommentModel.fromJson(v));
      });
    }
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['poster'] = poster;
    data['description'] = description;
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    if (comments != null) {
      data['comments'] = comments!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class PostImage {
  int? id;
  int? postId;
  String? path;
  String? description;
  String? createdAt;
  String? updatedAt;

  PostImage(
      {this.id,
      this.postId,
      this.path,
      this.description,
      this.createdAt,
      this.updatedAt});

  PostImage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postId = json['post_id'];
    path = json['path'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['post_id'] = postId;
    data['path'] = path;
    data['description'] = description;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
