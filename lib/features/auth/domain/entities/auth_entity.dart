// lib/auth/domain/entities/auth_entity.dart

class AuthEntity {
  final String id;
  final String email;
  final String token;
  final bool isAuthenticated;

  AuthEntity({
    required this.id,
    required this.email,
    required this.token,
    required this.isAuthenticated,
  });
}
