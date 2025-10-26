// ========== subscription_model.dart ==========

import 'package:catalog_admin/features/subscription/domain/entities/subscription_entity.dart';

class SubscriptionModel extends SubscriptionEntity {
  const SubscriptionModel({
    required super.id,
    required super.country,
    required super.currency,
    required super.price,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['id'] ?? '',
      country: json['country'] ?? '',
      currency: json['currency'] ?? '',
      price: json['price'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'country': country, 'currency': currency, 'price': price};
  }
}
