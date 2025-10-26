// ========== user_repository.dart ==========
import 'package:catalog_admin/features/users/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';

abstract class UserRepository {
  Future<Either<String, List<UserEntity>>> getUsers({
    required String country,
    String? searchQuery,
    int page = 1,
  });
}
