// lib/auth/data/repositories/auth_repository_impl.dart

import 'package:catalog_admin/core/errors/exceptions.dart';
import 'package:catalog_admin/core/errors/failure.dart';
import 'package:catalog_admin/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:catalog_admin/features/auth/domain/entities/auth_entity.dart';
import 'package:catalog_admin/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'dart:developer' as developer;

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, AuthEntity>> login({
    required String emailOrPhone,
    required String password,
  }) async {
    try {
      developer.log('🔐 Repository: Login attempt', name: 'AuthRepository');

      final result = await remoteDataSource.login(
        emailOrPhone: emailOrPhone,
        password: password,
      );

      developer.log('✅ Repository: Login successful', name: 'AuthRepository');

      return Right(result);
    } on ServerException catch (e) {
      developer.log(
        '❌ Repository: Login failed - ${e.errorMessageModel.errorMessage}',
        name: 'AuthRepository',
      );
      return Left(ServerFailure(e.errorMessageModel.errorMessage));
    } catch (e) {
      developer.log(
        '❌ Repository: Unexpected error - $e',
        name: 'AuthRepository',
      );
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TokenEntity>> refreshAccessToken() async {
    try {
      developer.log(
        '🔄 Repository: Refresh token attempt',
        name: 'AuthRepository',
      );

      final result = await remoteDataSource.refreshToken();

      developer.log('✅ Repository: Token refreshed', name: 'AuthRepository');

      return Right(result);
    } on ServerException catch (e) {
      developer.log(
        '❌ Repository: Refresh failed - ${e.errorMessageModel.errorMessage}',
        name: 'AuthRepository',
      );
      return Left(ServerFailure(e.errorMessageModel.errorMessage));
    } catch (e) {
      developer.log(
        '❌ Repository: Unexpected error - $e',
        name: 'AuthRepository',
      );
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      developer.log('🚪 Repository: Logout attempt', name: 'AuthRepository');

      await remoteDataSource.logout();

      developer.log('✅ Repository: Logout successful', name: 'AuthRepository');

      return const Right(true);
    } on ServerException catch (e) {
      developer.log(
        '❌ Repository: Logout failed - ${e.errorMessageModel.errorMessage}',
        name: 'AuthRepository',
      );
      return Left(ServerFailure(e.errorMessageModel.errorMessage));
    } catch (e) {
      developer.log(
        '❌ Repository: Unexpected error - $e',
        name: 'AuthRepository',
      );
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity?>> checkAuthStatus() async {
    try {
      developer.log(
        '🔍 Repository: Checking auth status',
        name: 'AuthRepository',
      );

      final result = await remoteDataSource.getStoredAuth();

      if (result != null) {
        developer.log(
          '✅ Repository: User authenticated',
          name: 'AuthRepository',
        );
      } else {
        developer.log(
          '⚪ Repository: User not authenticated',
          name: 'AuthRepository',
        );
      }

      return Right(result);
    } on ServerException catch (e) {
      developer.log(
        '❌ Repository: Error checking auth - ${e.errorMessageModel.errorMessage}',
        name: 'AuthRepository',
      );
      return Left(ServerFailure(e.errorMessageModel.errorMessage));
    } catch (e) {
      developer.log(
        '❌ Repository: Error checking auth - $e',
        name: 'AuthRepository',
      );
      return Left(ServerFailure(e.toString()));
    }
  }
}
