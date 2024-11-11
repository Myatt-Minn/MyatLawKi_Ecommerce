class BannerModel {
  final int id;
  final String imgUrl;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;

  BannerModel(
      {required this.id,
      required this.imgUrl,
      required this.title,
      required this.createdAt,
      required this.updatedAt});

  // Create CartItem from JSON
  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'],
      imgUrl: json['image'],
      title: json['title'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
