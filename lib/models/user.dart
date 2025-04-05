// lib/models/user.dart
class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String? imageUrl;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.imageUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'] ?? '',
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'image_url': imageUrl,
    };
  }
}