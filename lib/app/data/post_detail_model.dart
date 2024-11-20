import 'package:myat_ecommerence/app/data/post_model.dart';

class PostsDetailModel {
  bool? success;
  String? message;
  Post? data;

  PostsDetailModel({this.success, this.message, this.data});

  PostsDetailModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Post.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
