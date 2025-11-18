// ==================== REMOTE DATA SOURCE - FIXED ====================
// lib/subscription/data/datasources/subscription_remote_datasource.dart

import 'package:catalog_admin/core/api/api_consumer.dart';
import 'package:catalog_admin/core/api/end_ponits.dart';
import 'package:catalog_admin/features/subscription/data/models/subscription_model.dart';

abstract class SubscriptionRemoteDataSource {
  Future<List<SubscriptionModel>> getSubscriptions({required int typeId});

  // ✅ تحديث دولة واحدة فقط
  Future<void> updateSingleCountryPrice({
    required String countryId,
    required int newPrice,
  });

  // ✅ إضافة دولة جديدة
  Future<SubscriptionModel> addNewCountry({
    required int typeId,
    required String countryName,
    required String currency,
    required String countryCode,
    required int price,
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

    final messageType = pricingResponse.messageTypes.firstWhere(
      (type) => type.id == typeId,
      orElse: () =>
          MessageTypeModel(id: typeId, typeName: '', countryPrices: []),
    );

    return messageType.countryPrices;
  }

  @override
  Future<void> updateSingleCountryPrice({
    required String countryId,
    required int newPrice,
  }) async {
    // ✅ حسب الصورة: PUT /api/v1/pricing/2 مع {"price": 20}
    final data = {'price': newPrice};

    await apiConsumer.put(
      '${EndPoint.pricing}/$countryId',
      data: data,
      isFormData: false,
    );
  }

  // ==================== REMOTE DATASOURCE - addNewCountry ====================
  @override
  Future<SubscriptionModel> addNewCountry({
    required int typeId,
    required String countryName,
    required String currency,
    required String countryCode,
    required int price,
  }) async {
    // ✅ تنظيف وتنسيق الـ country_code
    String formattedCode = countryCode.trim();

    // ✅ إضافة + إذا لم تكن موجودة
    if (formattedCode.isNotEmpty && !formattedCode.startsWith('+')) {
      formattedCode = '+$formattedCode';
    }

    final data = {
      'type_id': typeId,
      'countries': [
        {
          'name': countryName,
          'currency': currency,
          'country_code': formattedCode,
          'price': price,
        },
      ],
    };

    final response = await apiConsumer.post(
      EndPoint.pricing,
      data: data,
      isFormData: false,
    );

    if (response['success'] == true &&
        response['data'] != null &&
        response['data']['inserted'] != null &&
        (response['data']['inserted'] as List).isNotEmpty) {
      final insertedCountry = response['data']['inserted'][0];
      return SubscriptionModel.fromJson(insertedCountry);
    }

    throw Exception('Failed to add country');
  }
}
