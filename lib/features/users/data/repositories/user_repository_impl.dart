import 'package:catalog_admin/core/errors/exceptions.dart';
import 'package:catalog_admin/core/errors/failure.dart';
import 'package:catalog_admin/features/users/data/datasources/user_remote_datasource.dart';
import 'package:catalog_admin/features/users/domain/entities/user_entity.dart';
import 'package:catalog_admin/features/users/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<UserEntity>>> getUsers({
    String? country,
    String? searchQuery,
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final result = await remoteDataSource.getUsers(
        country: country,
        searchQuery: searchQuery,
        page: page,
        perPage: perPage,
      );
      return Right(result.users);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
