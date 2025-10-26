// ========== subscription_repository_impl.dart ==========

import 'package:catalog_admin/features/subscription/data/datasources/subscription_remote_datasource.dart';
import 'package:catalog_admin/features/subscription/data/models/subscription_model.dart';
import 'package:catalog_admin/features/subscription/domain/entities/subscription_entity.dart';
import 'package:catalog_admin/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:dartz/dartz.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final SubscriptionRemoteDataSource remoteDataSource;

  SubscriptionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, List<SubscriptionEntity>>> getSubscriptions({
    required String contentType,
  }) async {
    try {
      final subscriptions = await remoteDataSource.getSubscriptions(
        contentType: contentType,
      );
      return Right(subscriptions);
    } catch (e) {
      return Left('Failed to load subscriptions: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> updateSubscriptions({
    required String contentType,
    required List<SubscriptionEntity> subscriptions,
  }) async {
    try {
      final models = subscriptions
          .map(
            (s) => SubscriptionModel(
              id: s.id,
              country: s.country,
              currency: s.currency,
              price: s.price,
            ),
          )
          .toList();

      await remoteDataSource.updateSubscriptions(
        contentType: contentType,
        subscriptions: models,
      );
      return const Right(null);
    } catch (e) {
      return Left('Failed to update subscriptions: ${e.toString()}');
    }
  }
}
