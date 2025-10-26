import 'package:catalog_admin/features/transactions/data/datasources/transactionremote_datasource.dart';
import 'package:catalog_admin/features/transactions/domain/entities/transaction_entity.dart';
import 'package:catalog_admin/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:dartz/dartz.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remoteDataSource;

  TransactionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, List<TransactionEntity>>> getTransactions({
    required String startDate,
    required String endDate,
    required String country,
    String? searchQuery,
  }) async {
    try {
      final transactions = await remoteDataSource.getTransactions(
        startDate: startDate,
        endDate: endDate,
        country: country,
        searchQuery: searchQuery,
      );
      return Right(transactions);
    } catch (e) {
      return Left('Failed to load transactions: ${e.toString()}');
    }
  }
}
