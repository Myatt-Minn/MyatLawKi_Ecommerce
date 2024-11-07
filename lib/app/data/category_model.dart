class CategoryModel {
  String id;
  String title;

  CategoryModel({
    required this.id,
    required this.title,
  });

  // Convert BrandModel to JSON (Map<String, dynamic>)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
    };
  }

  // Factory method to create a BrandModel from JSON
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      title: json['title'],
    );
  }
}
