// ==================== REPOSITORY IMPLEMENTATION - FIXED ====================
// lib/subscription/data/repositories/subscription_repository_impl.dart

import 'package:catalog_admin/core/errors/exceptions.dart';
import 'package:catalog_admin/core/errors/failure.dart';
import 'package:catalog_admin/features/subscription/data/datasources/subscription_remote_datasource.dart';
import 'package:catalog_admin/features/subscription/domain/entities/subscription_entity.dart';
import 'package:catalog_admin/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:dartz/dartz.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final SubscriptionRemoteDataSource remoteDataSource;

  SubscriptionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<SubscriptionEntity>>> getSubscriptions({
    required int typeId,
  }) async {
    try {
      final subscriptions = await remoteDataSource.getSubscriptions(
        typeId: typeId,
      );
      return Right(subscriptions);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateSingleCountryPrice({
    required String countryId,
    required int newPrice,
  }) async {
    try {
      await remoteDataSource.updateSingleCountryPrice(
        countryId: countryId,
        newPrice: newPrice,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SubscriptionEntity>> addNewCountry({
    required int typeId,
    required String countryName,
    required String currency,
    required String countryCode,
    required int price,
  }) async {
    try {
      final newCountry = await remoteDataSource.addNewCountry(
        typeId: typeId,
        countryName: countryName,
        currency: currency,
        countryCode: countryCode,
        price: price,
      );
      return Right(newCountry);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
