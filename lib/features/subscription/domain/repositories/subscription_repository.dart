// ========== subscription_repository.dart ==========
import 'package:catalog_admin/features/subscription/domain/entities/subscription_entity.dart';
import 'package:dartz/dartz.dart';

abstract class SubscriptionRepository {
  Future<Either<String, List<SubscriptionEntity>>> getSubscriptions({
    required String contentType,
  });

  Future<Either<String, void>> updateSubscriptions({
    required String contentType,
    required List<SubscriptionEntity> subscriptions,
  });
}
