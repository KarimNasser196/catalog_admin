import 'package:catalog_admin/features/promo/data/datasources/promo_remote_datasource.dart';
import 'package:catalog_admin/features/promo/domain/entities/promo_entity.dart';
import 'package:catalog_admin/features/promo/domain/repositories/promo_repository.dart';
import 'package:dartz/dartz.dart';

class PromoRepositoryImpl implements PromoRepository {
  final PromoRemoteDataSource remoteDataSource;

  PromoRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, List<PromoEntity>>> getAllPromoCodes() async {
    try {
      final result = await remoteDataSource.getAllPromoCodes();
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, PromoEntity>> createPromoCode({
    required double discountPercentage,
  }) async {
    try {
      final result = await remoteDataSource.createPromoCode(
        discountPercentage: discountPercentage,
      );
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, bool>> deletePromoCode(String promoId) async {
    try {
      await remoteDataSource.deletePromoCode(promoId);
      return const Right(true);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, bool>> togglePromoStatus(String promoId) async {
    try {
      await remoteDataSource.togglePromoStatus(promoId);
      return const Right(true);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
