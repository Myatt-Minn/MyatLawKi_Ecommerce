class BrandModel {
  int id;

  String title;

  BrandModel({
    required this.id,
    required this.title,
  });

  // Convert BrandModel to JSON (Map<String, dynamic>)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': title,
    };
  }

  // Factory method to create a BrandModel from JSON
  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: json['id'],
      title: json['name'],
    );
  }
}
