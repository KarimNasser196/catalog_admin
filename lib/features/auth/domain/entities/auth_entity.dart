// lib/auth/domain/entities/auth_entity.dart

class AuthEntity {
  final String id;
  final String name;
  final String email;
  final String token;
  final String? refreshToken;
  final String role;
  final DateTime expiresAtUtc;
  final bool isAuthenticated;

  AuthEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
    this.refreshToken,
    required this.role,
    required this.expiresAtUtc,
    required this.isAuthenticated,
  });

  bool get isAdmin => role.toLowerCase() == 'admin';
}

/// Token Response من Refresh Token API
class TokenEntity {
  final String accessToken;
  final String? refreshToken;
  final DateTime expiresAtUtc;

  TokenEntity({
    required this.accessToken,
    this.refreshToken,
    required this.expiresAtUtc,
  });
}
