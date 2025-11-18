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

// Content Types mapped to API type_id
class ContentType {
  static const String textTyping = 'Text Typing';
  static const String image = 'Image';
  static const String voice = 'Voice';
  static const String video = 'Video';

  // Map content type to API type_id
  static int getTypeId(String contentType) {
    switch (contentType) {
      case textTyping:
        return 1; // text type_id from API
      case voice:
        return 2; // voice type_id
      case video:
        return 3; // video type_id
      case image:
        return 4; // image type_id
      default:
        return 1;
    }
  }

  static String getTypeName(int typeId) {
    switch (typeId) {
      case 1:
        return textTyping;
      case 2:
        return voice;
      case 3:
        return video;
      case 4:
        return image;
      default:
        return textTyping;
    }
  }
}
