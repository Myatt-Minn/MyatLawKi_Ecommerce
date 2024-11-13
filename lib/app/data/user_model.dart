class UserModel {
  final int id;
  final String name;
  final String phone;
  final String email;
  final String fcmTokenKey;
  final bool isBanned;
  final String image;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.fcmTokenKey,
    required this.isBanned,
    required this.image,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      fcmTokenKey: json['fcm_token_key'] ?? '',
      isBanned: json['is_banned'] == '1',
      image: json['image'],
    );
  }
}
