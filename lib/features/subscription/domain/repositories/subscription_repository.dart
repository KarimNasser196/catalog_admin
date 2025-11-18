// ==================== REPOSITORY INTERFACE - FIXED ====================
// lib/subscription/domain/repositories/subscription_repository.dart

import 'package:catalog_admin/core/errors/failure.dart';
import 'package:catalog_admin/features/subscription/domain/entities/subscription_entity.dart';
import 'package:dartz/dartz.dart';

abstract class SubscriptionRepository {
  Future<Either<Failure, List<SubscriptionEntity>>> getSubscriptions({
    required int typeId,
  });

  // ✅ تحديث سعر دولة واحدة فقط
  Future<Either<Failure, void>> updateSingleCountryPrice({
    required String countryId,
    required int newPrice,
  });

  // ✅ إضافة دولة جديدة
  Future<Either<Failure, SubscriptionEntity>> addNewCountry({
    required int typeId,
    required String countryName,
    required String currency,
    required String countryCode,
    required int price,
  });
}
