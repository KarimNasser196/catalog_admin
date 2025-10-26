// ========== payment_remote_datasource.dart ==========

import 'package:catalog_admin/features/payment/data/models/payment_model.dart';

abstract class PaymentRemoteDataSource {
  Future<List<PaymentModel>> getPayments({
    required String startDate,
    required String endDate,
    required String country,
  });

  Future<String> getTotalEarned({
    required String startDate,
    required String endDate,
    required String country,
  });
}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  // TODO: Add Dio instance when backend is ready

  @override
  Future<List<PaymentModel>> getPayments({
    required String startDate,
    required String endDate,
    required String country,
  }) async {
    // TODO: Replace with actual API call
    await Future.delayed(const Duration(seconds: 1));
    return [
      const PaymentModel(
        id: '1',
        user: '@mahran',
        date: '12-10-2025',
        amount: '1,200 EGP',
      ),
      const PaymentModel(
        id: '2',
        user: '@ahmed',
        date: '13-10-2025',
        amount: '1,240 EGP',
      ),
    ];
  }

  @override
  Future<String> getTotalEarned({
    required String startDate,
    required String endDate,
    required String country,
  }) async {
    // TODO: Replace with actual API call
    await Future.delayed(const Duration(milliseconds: 500));
    return '65,845 EGP';
  }
}
