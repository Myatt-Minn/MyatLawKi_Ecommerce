class CommentModel {
  int? id;
  int? userId;
  String? poster;
  String? image;
  int? postId;
  dynamic parentId;
  String? body;
  String? createdAt;
  String? updatedAt;
  List<Replies>? replies;
  bool? replyShow = false;

  CommentModel(
      {this.id,
      this.userId,
      this.poster,
      this.image,
      this.postId,
      this.parentId,
      this.body,
      this.createdAt,
      this.updatedAt,
      this.replies,
      this.replyShow});

  CommentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    poster = json['poster'];
    image = json['image'];
    postId = json['post_id'];
    parentId = json['parent_id'];
    body = json['body'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['replies'] != null) {
      replies = <Replies>[];
      json['replies'].forEach((v) {
        replies!.add(Replies.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['poster'] = poster;
    data['image'] = image;
    data['post_id'] = postId;
    data['parent_id'] = parentId;
    data['body'] = body;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (replies != null) {
      data['replies'] = replies!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Replies {
  int? id;
  int? userId;
  String? poster;
  String? image;
  int? postId;
  int? parentId;
  String? body;
  String? createdAt;
  String? updatedAt;
  List<Replies>? replies;

  Replies(
      {this.id,
      this.userId,
      this.poster,
      this.image,
      this.postId,
      this.parentId,
      this.body,
      this.createdAt,
      this.updatedAt,
      this.replies});

  Replies.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    poster = json['poster'];
    image = json['image'];
    postId = json['post_id'];
    parentId = json['parent_id'];
    body = json['body'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['replies'] != null) {
      replies = <Replies>[];
      json['replies'].forEach((v) {
        replies!.add(Replies.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['poster'] = poster;
    data['image'] = image;
    data['post_id'] = postId;
    data['parent_id'] = parentId;
    data['body'] = body;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (replies != null) {
      data['replies'] = replies!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
