// lib/auth/data/models/auth_model.dart

import 'package:catalog_admin/features/auth/domain/entities/auth_entity.dart';

class AuthModel extends AuthEntity {
  AuthModel({
    required super.id,
    required super.email,
    required super.token,
    required super.isAuthenticated,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      token: json['token'] ?? '',
      isAuthenticated: json['is_authenticated'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'token': token,
      'is_authenticated': isAuthenticated,
    };
  }
}
