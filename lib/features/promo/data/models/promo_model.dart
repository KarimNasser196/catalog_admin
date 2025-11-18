import 'package:catalog_admin/features/promo/domain/entities/promo_entity.dart';

class PromoModel extends PromoEntity {
  PromoModel({
    required super.id,
    required super.code,
    required super.discountPercentage,
    required super.usedCount,
    required super.isActive,
  });

  factory PromoModel.fromJson(Map<String, dynamic> json) {
    return PromoModel(
      id: json['id']?.toString() ?? '', // Convert to string for consistency
      code: json['code'] ?? '',
      discountPercentage: _parseDouble(json['discount']),
      usedCount: json['used'] ?? 0,
      isActive: json['is_active'] ?? true,
    );
  }

  // Helper to safely parse double
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'discount': discountPercentage,
      'used': usedCount,
      'is_active': isActive,
    };
  }
}

// Response wrapper for list of coupons
class CouponsResponseModel {
  final bool success;
  final String message;
  final List<PromoModel> coupons;

  CouponsResponseModel({
    required this.success,
    required this.message,
    required this.coupons,
  });

  factory CouponsResponseModel.fromJson(Map<String, dynamic> json) {
    return CouponsResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      coupons:
          (json['data'] as List<dynamic>?)
              ?.map(
                (coupon) => PromoModel.fromJson(coupon as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }
}

// Response wrapper for single coupon creation
class CouponResponseModel {
  final bool success;
  final String message;
  final PromoModel coupon;

  CouponResponseModel({
    required this.success,
    required this.message,
    required this.coupon,
  });

  factory CouponResponseModel.fromJson(Map<String, dynamic> json) {
    return CouponResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      coupon: PromoModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}
