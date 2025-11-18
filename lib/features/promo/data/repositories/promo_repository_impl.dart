// lib/promo/data/repositories/promo_repository_impl.dart

import 'package:catalog_admin/core/errors/exceptions.dart';
import 'package:catalog_admin/core/errors/failure.dart';
import 'package:catalog_admin/features/promo/data/datasources/promo_remote_datasource.dart';
import 'package:catalog_admin/features/promo/domain/entities/promo_entity.dart';
import 'package:catalog_admin/features/promo/domain/repositories/promo_repository.dart';
import 'package:dartz/dartz.dart';

class PromoRepositoryImpl implements PromoRepository {
  final PromoRemoteDataSource remoteDataSource;

  PromoRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<PromoEntity>>> getAllPromoCodes() async {
    try {
      final result = await remoteDataSource.getAllPromoCodes();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PromoEntity>> createPromoCode({
    required double discountPercentage,
  }) async {
    try {
      final result = await remoteDataSource.createPromoCode(
        discountPercentage: discountPercentage,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deletePromoCode(String promoId) async {
    try {
      await remoteDataSource.deletePromoCode(promoId);
      return const Right(true);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> togglePromoStatus(String promoId) async {
    try {
      await remoteDataSource.togglePromoStatus(promoId);
      return const Right(true);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel.errorMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
