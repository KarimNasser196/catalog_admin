import 'package:catalog_admin/core/errors/failure.dart';
import 'package:catalog_admin/features/promo/domain/entities/promo_entity.dart';
import 'package:dartz/dartz.dart';

abstract class PromoRepository {
  Future<Either<Failure, List<PromoEntity>>> getAllPromoCodes();
  Future<Either<Failure, PromoEntity>> createPromoCode({
    required double discountPercentage,
  });
  Future<Either<Failure, bool>> deletePromoCode(String promoId);
  Future<Either<Failure, bool>> togglePromoStatus(String promoId);
}
