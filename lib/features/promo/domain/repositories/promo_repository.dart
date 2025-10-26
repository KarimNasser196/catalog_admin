import 'package:catalog_admin/features/promo/domain/entities/promo_entity.dart';
import 'package:dartz/dartz.dart';

abstract class PromoRepository {
  Future<Either<String, List<PromoEntity>>> getAllPromoCodes();
  Future<Either<String, PromoEntity>> createPromoCode({
    required double discountPercentage,
  });
  Future<Either<String, bool>> deletePromoCode(String promoId);
  Future<Either<String, bool>> togglePromoStatus(String promoId);
}
