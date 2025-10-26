// ========== payment_repository.dart ==========
import 'package:catalog_admin/features/payment/domain/entities/payment_entity.dart';
import 'package:dartz/dartz.dart';

abstract class PaymentRepository {
  Future<Either<String, List<PaymentEntity>>> getPayments({
    required String startDate,
    required String endDate,
    required String country,
  });

  Future<Either<String, String>> getTotalEarned({
    required String startDate,
    required String endDate,
    required String country,
  });
}
