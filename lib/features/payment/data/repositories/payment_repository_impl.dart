// ========== payment_repository_impl.dart ==========
import 'package:catalog_admin/features/payment/data/datasources/payment_remote_datasource.dart';
import 'package:catalog_admin/features/payment/domain/entities/payment_entity.dart';
import 'package:catalog_admin/features/payment/domain/repositories/payment_repository.dart';
import 'package:dartz/dartz.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;

  PaymentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, List<PaymentEntity>>> getPayments({
    required String startDate,
    required String endDate,
    required String country,
  }) async {
    try {
      final payments = await remoteDataSource.getPayments(
        startDate: startDate,
        endDate: endDate,
        country: country,
      );
      return Right(payments);
    } catch (e) {
      return Left('Failed to load payments: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, String>> getTotalEarned({
    required String startDate,
    required String endDate,
    required String country,
  }) async {
    try {
      final total = await remoteDataSource.getTotalEarned(
        startDate: startDate,
        endDate: endDate,
        country: country,
      );
      return Right(total);
    } catch (e) {
      return Left('Failed to load total: ${e.toString()}');
    }
  }
}
