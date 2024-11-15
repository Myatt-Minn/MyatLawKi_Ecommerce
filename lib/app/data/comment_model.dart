class CommentModel {
  int? id;
  int? userId;
  String? poster;
  String? image;
  int? postId;
  dynamic? parentId;
  String? body;
  String? createdAt;
  String? updatedAt;
  List<Replies>? replies;
  bool? replyShow=false;


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
        replies!.add(new Replies.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['poster'] = this.poster;
    data['image'] = this.image;
    data['post_id'] = this.postId;
    data['parent_id'] = this.parentId;
    data['body'] = this.body;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.replies != null) {
      data['replies'] = this.replies!.map((v) => v.toJson()).toList();
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
        replies!.add(new Replies.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['poster'] = this.poster;
    data['image'] = this.image;
    data['post_id'] = this.postId;
    data['parent_id'] = this.parentId;
    data['body'] = this.body;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.replies != null) {
      data['replies'] = this.replies!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
