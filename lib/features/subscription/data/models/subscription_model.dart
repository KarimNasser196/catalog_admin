import 'package:catalog_admin/features/subscription/domain/entities/subscription_entity.dart';

class SubscriptionModel extends SubscriptionEntity {
  const SubscriptionModel({
    required super.id,
    required super.country,
    required super.currency,
    required super.countryCode,
    required super.price,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['id']?.toString() ?? '',
      country: json['name'] ?? '',
      currency: json['currency'] ?? '',
      countryCode: json['country_code'] ?? '',
      price: _parseInt(json['price']),
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': country,
      'currency': currency,
      'country_code': countryCode,
      'price': price,
    };
  }
}

// Message Type Response Model
class MessageTypeModel {
  final int id;
  final String typeName;
  final String? description;
  final List<SubscriptionModel> countryPrices;

  MessageTypeModel({
    required this.id,
    required this.typeName,
    this.description,
    required this.countryPrices,
  });

  factory MessageTypeModel.fromJson(Map<String, dynamic> json) {
    return MessageTypeModel(
      id: json['id'] ?? 0,
      typeName: json['type_name'] ?? '',
      description: json['description'],
      countryPrices:
          (json['country_prices'] as List<dynamic>?)
              ?.map(
                (price) =>
                    SubscriptionModel.fromJson(price as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }
}

// Full Response Model
class PricingResponseModel {
  final bool success;
  final List<MessageTypeModel> messageTypes;

  PricingResponseModel({required this.success, required this.messageTypes});

  factory PricingResponseModel.fromJson(Map<String, dynamic> json) {
    return PricingResponseModel(
      success: json['success'] ?? false,
      messageTypes:
          (json['data'] as List<dynamic>?)
              ?.map(
                (type) =>
                    MessageTypeModel.fromJson(type as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }
}
