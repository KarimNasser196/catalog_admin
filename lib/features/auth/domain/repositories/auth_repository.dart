// lib/auth/domain/repositories/auth_repository.dart

import 'package:catalog_admin/core/errors/failure.dart';
import 'package:catalog_admin/features/auth/domain/entities/auth_entity.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  /// تسجيل الدخول بـ email أو username
  Future<Either<Failure, AuthEntity>> login({
    required String emailOrPhone,
    required String password,
  });

  /// تحديث Access Token باستخدام Refresh Token
  Future<Either<Failure, TokenEntity>> refreshAccessToken();

  /// تسجيل الخروج
  Future<Either<Failure, bool>> logout();

  /// التحقق من حالة المصادقة (من الـ cache)
  Future<Either<Failure, AuthEntity?>> checkAuthStatus();
}
