// ========== user_repository_impl.dart ==========
import 'package:catalog_admin/features/users/data/datasources/user_remote_datasource.dart';
import 'package:catalog_admin/features/users/domain/entities/user_entity.dart';
import 'package:catalog_admin/features/users/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, List<UserEntity>>> getUsers({
    required String country,
    String? searchQuery,
    int page = 1,
  }) async {
    try {
      final users = await remoteDataSource.getUsers(
        country: country,
        searchQuery: searchQuery,
        page: page,
      );
      return Right(users);
    } catch (e) {
      return Left('Failed to load users: ${e.toString()}');
    }
  }
}
