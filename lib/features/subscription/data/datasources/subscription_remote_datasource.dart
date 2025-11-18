// ==================== REMOTE DATA SOURCE ====================
// lib/subscription/data/datasources/subscription_remote_datasource.dart

import 'package:catalog_admin/core/api/api_consumer.dart';
import 'package:catalog_admin/core/api/end_ponits.dart';
import 'package:catalog_admin/features/subscription/data/models/subscription_model.dart';

abstract class SubscriptionRemoteDataSource {
  Future<List<SubscriptionModel>> getSubscriptions({required int typeId});
  Future<void> updateSubscriptions({
    required int typeId,
    required List<SubscriptionModel> subscriptions,
  });
}

class SubscriptionRemoteDataSourceImpl implements SubscriptionRemoteDataSource {
  final ApiConsumer apiConsumer;

  SubscriptionRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<List<SubscriptionModel>> getSubscriptions({
    required int typeId,
  }) async {
    final response = await apiConsumer.get(EndPoint.pricing);
    final pricingResponse = PricingResponseModel.fromJson(response);

    // Find the message type with the given typeId
    final messageType = pricingResponse.messageTypes.firstWhere(
      (type) => type.id == typeId,
      orElse: () =>
          MessageTypeModel(id: typeId, typeName: '', countryPrices: []),
    );

    return messageType.countryPrices;
  }

  @override
  Future<void> updateSubscriptions({
    required int typeId,
    required List<SubscriptionModel> subscriptions,
  }) async {
    // Send as JSON (raw body based on Postman screenshot)
    final data = {
      'type_id': typeId,
      'countries': subscriptions.map((sub) => sub.toJson()).toList(),
    };

    await apiConsumer.post(
      EndPoint.pricing,
      data: data,
      isFormData: false, // JSON body
    );
  }
}
