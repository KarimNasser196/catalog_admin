import 'package:catalog_admin/features/promo/domain/entities/promo_entity.dart';

class PromoModel extends PromoEntity {
  PromoModel({
    required super.id,
    required super.code,
    required super.discountPercentage,
    required super.usedCount,
    required super.createdAt,
    required super.isActive,
  });

  factory PromoModel.fromJson(Map<String, dynamic> json) {
    return PromoModel(
      id: json['id'] ?? '',
      code: json['code'] ?? '',
      discountPercentage: (json['discount_percentage'] ?? 0).toDouble(),
      usedCount: json['used_count'] ?? 0,
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'discount_percentage': discountPercentage,
      'used_count': usedCount,
      'created_at': createdAt.toIso8601String(),
      'is_active': isActive,
    };
  }
}
