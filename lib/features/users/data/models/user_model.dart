// ========== user_model.dart ==========
import 'package:catalog_admin/features/users/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.username,
    required super.phone,
    required super.email,
    super.country,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'phone': phone,
      'email': email,
      'country': country,
    };
  }
}
