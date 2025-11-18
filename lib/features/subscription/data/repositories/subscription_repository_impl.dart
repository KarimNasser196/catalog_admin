// ==================== REPOSITORY IMPLEMENTATION ====================
// lib/subscription/data/repositories/subscription_repository_impl.dart

import 'package:catalog_admin/core/errors/exceptions.dart';
import 'package:catalog_admin/core/errors/failure.dart';
import 'package:catalog_admin/features/subscription/data/datasources/subscription_remote_datasource.dart';
import 'package:catalog_admin/features/subscription/data/models/subscription_model.dart';
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
  Future<Either<Failure, void>> updateSubscriptions({
    required int typeId,
    required List<SubscriptionEntity> subscriptions,
  }) async {
    try {
      final models = subscriptions
          .map(
            (s) => SubscriptionModel(
              id: s.id,
              country: s.country,
              currency: s.currency,
              countryCode: s.countryCode,
              price: s.price,
            ),
          )
          .toList();

      await remoteDataSource.updateSubscriptions(
        typeId: typeId,
        subscriptions: models,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
