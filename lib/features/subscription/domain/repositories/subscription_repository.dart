// ==================== REPOSITORY INTERFACE ====================
// lib/subscription/domain/repositories/subscription_repository.dart

import 'package:catalog_admin/core/errors/failure.dart';
import 'package:catalog_admin/features/subscription/domain/entities/subscription_entity.dart';
import 'package:dartz/dartz.dart';

abstract class SubscriptionRepository {
  Future<Either<Failure, List<SubscriptionEntity>>> getSubscriptions({
    required int typeId,
  });

  Future<Either<Failure, void>> updateSubscriptions({
    required int typeId,
    required List<SubscriptionEntity> subscriptions,
  });
}
