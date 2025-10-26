// lib/profile/domain/repositories/profile_repository.dart

import 'package:dartz/dartz.dart';

abstract class ProfileRepository {
  Future<Either<String, bool>> updateProfile({
    required String email,
    required String password,
  });
}
