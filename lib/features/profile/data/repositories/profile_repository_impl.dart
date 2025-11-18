// lib/profile/data/repositories/profile_repository_impl.dart

import 'package:catalog_admin/core/errors/failure.dart';
import 'package:catalog_admin/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:catalog_admin/features/profile/domain/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, bool>> updateProfile({
    required String email,
    required String password,
  }) async {
    try {
      await remoteDataSource.updateProfile(email: email, password: password);
      return const Right(true);
    } on ServerFailure catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: $e'));
    }
  }
}
