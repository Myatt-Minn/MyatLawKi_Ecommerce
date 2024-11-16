
import 'package:myat_ecommerence/app/data/post_model.dart';

class PostsDetailModel {
  bool? success;
  String? message;
  Post? data;

  PostsDetailModel({this.success, this.message, this.data});

  PostsDetailModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Post.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
