import 'package:catalog_admin/features/users/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.username,
    required super.phone,
    required super.email,
    super.image,
    super.provider,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      username: json['user_name'] ?? '', // API uses 'user_name'
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      image: json['image'],
      provider: json['provider'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'user_name': username,
      'phone': phone,
      'email': email,
      'image': image,
      'provider': provider,
    };
  }
}
