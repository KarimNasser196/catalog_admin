import 'package:catalog_admin/core/errors/failure.dart';
import 'package:catalog_admin/features/users/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';

abstract class UserRepository {
  Future<Either<Failure, List<UserEntity>>> getUsers({
    String? country,
    String? searchQuery,
    int page = 1,
    int perPage = 20,
  });
}
