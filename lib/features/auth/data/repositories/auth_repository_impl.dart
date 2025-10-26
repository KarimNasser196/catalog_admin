// lib/auth/data/repositories/auth_repository_impl.dart

import 'package:catalog_admin/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:catalog_admin/features/auth/domain/entities/auth_entity.dart';
import 'package:catalog_admin/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, AuthEntity>> login({
    required String emailOrPhone,
    required String password,
  }) async {
    try {
      final result = await remoteDataSource.login(
        emailOrPhone: emailOrPhone,
        password: password,
      );
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, bool>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(true);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, AuthEntity?>> checkAuthStatus() async {
    try {
      final result = await remoteDataSource.getStoredAuth();
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
