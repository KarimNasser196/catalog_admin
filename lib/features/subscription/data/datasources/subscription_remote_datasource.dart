// ========== subscription_remote_datasource.dart ==========
import 'package:catalog_admin/features/subscription/data/models/subscription_model.dart';

abstract class SubscriptionRemoteDataSource {
  Future<List<SubscriptionModel>> getSubscriptions({
    required String contentType,
  });

  Future<void> updateSubscriptions({
    required String contentType,
    required List<SubscriptionModel> subscriptions,
  });
}

class SubscriptionRemoteDataSourceImpl implements SubscriptionRemoteDataSource {
  // TODO: Add Dio instance when backend is ready

  // In-memory storage grouped by content type
  final Map<String, List<SubscriptionModel>> _storage = {
    'Text Typing': [
      const SubscriptionModel(
        id: '1',
        country: 'Egypt',
        currency: 'EGP',
        price: 50,
      ),
      const SubscriptionModel(
        id: '2',
        country: 'UAE',
        currency: 'AED',
        price: 30,
      ),
      const SubscriptionModel(
        id: '3',
        country: 'Kuwait',
        currency: 'KWD',
        price: 15,
      ),
    ],
    'Image': [
      const SubscriptionModel(
        id: '4',
        country: 'Egypt',
        currency: 'EGP',
        price: 100,
      ),
      const SubscriptionModel(
        id: '5',
        country: 'UAE',
        currency: 'AED',
        price: 60,
      ),
    ],
    'Voice': [
      const SubscriptionModel(
        id: '6',
        country: 'Egypt',
        currency: 'EGP',
        price: 75,
      ),
    ],
    'Video': [
      const SubscriptionModel(
        id: '7',
        country: 'Egypt',
        currency: 'EGP',
        price: 150,
      ),
    ],
  };

  @override
  Future<List<SubscriptionModel>> getSubscriptions({
    required String contentType,
  }) async {
    // TODO: Replace with actual API call
    // final response = await _dio.get('/subscriptions/$contentType');

    await Future.delayed(const Duration(milliseconds: 500));

    // Return a copy of the list for the content type, or empty list if not found
    return List<SubscriptionModel>.from(_storage[contentType] ?? []);
  }

  @override
  Future<void> updateSubscriptions({
    required String contentType,
    required List<SubscriptionModel> subscriptions,
  }) async {
    // TODO: Replace with actual API call
    // await _dio.put('/subscriptions/$contentType', data: {
    //   'subscriptions': subscriptions.map((s) => s.toJson()).toList(),
    // });

    await Future.delayed(const Duration(milliseconds: 500));

    // Update the in-memory storage
    _storage[contentType] = List<SubscriptionModel>.from(subscriptions);
  }
}
