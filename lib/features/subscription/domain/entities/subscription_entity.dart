import 'package:equatable/equatable.dart';

class SubscriptionEntity extends Equatable {
  final String id;
  final String country;
  final String currency;
  final int price;

  const SubscriptionEntity({
    required this.id,
    required this.country,
    required this.currency,
    required this.price,
  });

  @override
  List<Object?> get props => [id, country, currency, price];
}

class ContentType {
  static const String textTyping = 'Text Typing';
  static const String image = 'Image';
  static const String voice = 'Voice';
  static const String video = 'Video';
}
