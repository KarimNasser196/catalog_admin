import 'dart:math';
import 'package:catalog_admin/features/promo/data/models/promo_model.dart';

abstract class PromoRemoteDataSource {
  Future<List<PromoModel>> getAllPromoCodes();
  Future<PromoModel> createPromoCode({required double discountPercentage});
  Future<void> deletePromoCode(String promoId);
  Future<void> togglePromoStatus(String promoId);
}

class PromoRemoteDataSourceImpl implements PromoRemoteDataSource {
  // TODO: Replace with actual API calls when backend is ready

  // Temporary in-memory storage for demonstration
  final List<PromoModel> _promoCodes = [];

  String _generatePromoCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return List.generate(
      8,
      (index) => chars[random.nextInt(chars.length)],
    ).join();
  }

  @override
  Future<List<PromoModel>> getAllPromoCodes() async {
    // TODO: Implement API call
    // Example: final response = await http.get(Uri.parse('$baseUrl/promo-codes'));

    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // Simulate network delay
    return _promoCodes;
  }

  @override
  Future<PromoModel> createPromoCode({
    required double discountPercentage,
  }) async {
    // TODO: Implement API call
    // Example: final response = await http.post(
    //   Uri.parse('$baseUrl/promo-codes'),
    //   body: json.encode({'discount_percentage': discountPercentage}),
    // );

    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // Simulate network delay

    final newPromo = PromoModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      code: _generatePromoCode(),
      discountPercentage: discountPercentage,
      usedCount: 0,
      createdAt: DateTime.now(),
      isActive: true,
    );

    _promoCodes.add(newPromo);
    return newPromo;
  }

  @override
  Future<void> deletePromoCode(String promoId) async {
    // TODO: Implement API call
    // Example: await http.delete(Uri.parse('$baseUrl/promo-codes/$promoId'));

    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // Simulate network delay
    _promoCodes.removeWhere((promo) => promo.id == promoId);
  }

  @override
  Future<void> togglePromoStatus(String promoId) async {
    // TODO: Implement API call
    // Example: await http.patch(Uri.parse('$baseUrl/promo-codes/$promoId/toggle'));

    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // Simulate network delay
    final index = _promoCodes.indexWhere((promo) => promo.id == promoId);
    if (index != -1) {
      final promo = _promoCodes[index];
      _promoCodes[index] = PromoModel(
        id: promo.id,
        code: promo.code,
        discountPercentage: promo.discountPercentage,
        usedCount: promo.usedCount,
        createdAt: promo.createdAt,
        isActive: !promo.isActive,
      );
    }
  }
}
