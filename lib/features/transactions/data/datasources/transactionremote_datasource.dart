import 'package:catalog_admin/features/transactions/data/models/transaction_model.dart';

abstract class TransactionRemoteDataSource {
  Future<List<TransactionModel>> getTransactions({
    required String startDate,
    required String endDate,
    required String country,
    String? searchQuery,
  });
}

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  // TODO: Add Dio instance when backend is ready
  // final Dio _dio;

  // TransactionRemoteDataSourceImpl(this._dio);

  @override
  Future<List<TransactionModel>> getTransactions({
    required String startDate,
    required String endDate,
    required String country,
    String? searchQuery,
  }) async {
    // TODO: Replace with actual API call
    // final response = await _dio.get('/transactions', queryParameters: {
    //   'start_date': startDate,
    //   'end_date': endDate,
    //   'country': country,
    //   if (searchQuery != null) 'search': searchQuery,
    // });

    // Temporary mock data
    await Future.delayed(const Duration(seconds: 1));
    return [
      const TransactionModel(
        id: '1',
        sender: '@hazem',
        receiver: '@mahran',
        date: '12-10-2025',
        status: 'Successful',
        tags: ['Text', 'Image', 'Video', 'Doc'],
      ),
      const TransactionModel(
        id: '2',
        sender: '@ahmed',
        receiver: '@mahran',
        date: '13-10-2025',
        status: 'Failed',
        tags: ['Text', 'Video'],
      ),
    ];
  }
}
