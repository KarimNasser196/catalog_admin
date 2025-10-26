import 'package:catalog_admin/features/transactions/domain/entities/transaction_entity.dart';
import 'package:dartz/dartz.dart';

abstract class TransactionRepository {
  Future<Either<String, List<TransactionEntity>>> getTransactions({
    required String startDate,
    required String endDate,
    required String country,
    String? searchQuery,
  });
}
