// lib/profile/domain/repositories/profile_repository.dart

import 'package:catalog_admin/core/errors/failure.dart';
import 'package:dartz/dartz.dart';

abstract class ProfileRepository {
  Future<Either<Failure, bool>> updateProfile({
    required String email,
    required String password,
  });
}
