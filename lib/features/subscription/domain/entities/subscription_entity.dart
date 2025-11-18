// ==================== ENTITY ====================
// lib/subscription/domain/entities/subscription_entity.dart

import 'package:equatable/equatable.dart';

class SubscriptionEntity extends Equatable {
  final String id;
  final String country;
  final String currency;
  final String countryCode;
  final int price;

  const SubscriptionEntity({
    required this.id,
    required this.country,
    required this.currency,
    required this.countryCode,
    required this.price,
  });

  @override
  List<Object?> get props => [id, country, currency, countryCode, price];
}
