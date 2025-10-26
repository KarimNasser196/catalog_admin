// lib/auth/domain/repositories/auth_repository.dart

import 'package:catalog_admin/features/auth/domain/entities/auth_entity.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<String, AuthEntity>> login({
    required String emailOrPhone,
    required String password,
  });
  Future<Either<String, bool>> logout();
  Future<Either<String, AuthEntity?>> checkAuthStatus();
}
