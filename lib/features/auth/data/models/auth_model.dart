// lib/auth/data/models/auth_model.dart

import 'package:catalog_admin/core/api/jwt_decoder.dart';
import 'package:catalog_admin/features/auth/domain/entities/auth_entity.dart';
import 'dart:developer' as developer;

class AuthModel extends AuthEntity {
  AuthModel({
    required super.id,
    required super.name,
    required super.email,
    required super.token,
    super.refreshToken,
    required super.role,
    required super.expiresAtUtc,
    required super.isAuthenticated,
  });

  /// من API Response
  /// Response format:
  /// {
  ///   "access_token": "eyJ0eXAi...",
  ///   "token_type": "bearer",
  ///   "expires_in": 3600
  /// }
  factory AuthModel.fromJson(Map<String, dynamic> json) {
    try {
      final accessToken = json['access_token'] as String;
      final expiresIn = json['expires_in'] as int; // seconds

      // Decode JWT to get user info
      final decodedToken = JwtDecoder.decode(accessToken);

      if (decodedToken == null) {
        throw Exception('Failed to decode JWT token');
      }

      // Extract user info from JWT
      final userId = decodedToken['sub'] as String;
      final userName = decodedToken['name'] as String;
      final userRole = decodedToken['role'] as String;

      // Calculate expiry date
      final expiresAtUtc = DateTime.now().add(Duration(seconds: expiresIn));

      developer.log('''
✅ Auth parsed successfully:
  - User ID: $userId
  - Name: $userName
  - Role: $userRole
  - Expires in: $expiresIn seconds
  - Expires at: $expiresAtUtc
      ''', name: 'AuthModel');

      // Get email from response if available, otherwise extract from token if present
      String email = '';
      if (json.containsKey('user') && json['user'] is Map) {
        email = json['user']['email'] ?? '';
      }

      return AuthModel(
        id: userId,
        name: userName,
        email: email,
        token: accessToken,
        refreshToken:
            null, // Laravel Sanctum might not return refresh token with login
        role: userRole,
        expiresAtUtc: expiresAtUtc,
        isAuthenticated: true,
      );
    } catch (e) {
      developer.log('❌ Error parsing Auth response: $e', name: 'AuthModel');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'token': token,
      'refresh_token': refreshToken,
      'role': role,
      'expires_at_utc': expiresAtUtc.toIso8601String(),
      'is_authenticated': isAuthenticated,
    };
  }

  /// From cached data
  factory AuthModel.fromCache(Map<String, dynamic> cache) {
    return AuthModel(
      id: cache['id'] ?? '',
      name: cache['name'] ?? '',
      email: cache['email'] ?? '',
      token: cache['token'] ?? '',
      refreshToken: cache['refresh_token'],
      role: cache['role'] ?? '',
      expiresAtUtc: DateTime.parse(
        cache['expires_at_utc'] ?? DateTime.now().toIso8601String(),
      ),
      isAuthenticated: cache['is_authenticated'] ?? false,
    );
  }
}

/// Token Model for refresh token response
class TokenModel extends TokenEntity {
  TokenModel({
    required super.accessToken,
    super.refreshToken,
    required super.expiresAtUtc,
  });

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    final accessToken = json['access_token'] as String;
    final expiresIn = json['expires_in'] as int;
    final expiresAtUtc = DateTime.now().add(Duration(seconds: expiresIn));

    return TokenModel(
      accessToken: accessToken,
      refreshToken: json['refresh_token'], // might be null
      expiresAtUtc: expiresAtUtc,
    );
  }
}
