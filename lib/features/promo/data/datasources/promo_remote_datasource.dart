import 'package:catalog_admin/core/api/api_consumer.dart';
import 'package:catalog_admin/core/api/end_ponits.dart';
import 'package:catalog_admin/features/promo/data/models/promo_model.dart';

abstract class PromoRemoteDataSource {
  Future<List<PromoModel>> getAllPromoCodes();
  Future<PromoModel> createPromoCode({required double discountPercentage});
  Future<void> deletePromoCode(String promoId);
  Future<void> togglePromoStatus(String promoId);
}

class PromoRemoteDataSourceImpl implements PromoRemoteDataSource {
  final ApiConsumer apiConsumer;

  PromoRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<List<PromoModel>> getAllPromoCodes() async {
    final response = await apiConsumer.get(EndPoint.adminCoupons);
    final couponsResponse = CouponsResponseModel.fromJson(response);
    return couponsResponse.coupons;
  }

  @override
  Future<PromoModel> createPromoCode({
    required double discountPercentage,
  }) async {
    final response = await apiConsumer.post(
      EndPoint.adminCoupons,
      data: {'discount_value': discountPercentage},
      isFormData: true, // Based on Postman screenshot
    );

    final couponResponse = CouponResponseModel.fromJson(response);
    return couponResponse.coupon;
  }

  @override
  Future<void> deletePromoCode(String promoId) async {
    // Using POST with _method=delete as per Postman
    await apiConsumer.post(
      '${EndPoint.adminCoupons}/$promoId',
      data: {'_method': 'delete'},
      isFormData: true,
    );
  }

  @override
  Future<void> togglePromoStatus(String promoId) async {
    // Using POST with _method=patch as per Postman
    await apiConsumer.post(
      '${EndPoint.adminCoupons}/$promoId/toggle',
      data: {'_method': 'patch'},
      isFormData: true,
    );
  }
}
