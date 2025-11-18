class PromoEntity {
  final String id;
  final String code;
  final double discountPercentage;
  final int usedCount;
  final bool isActive;

  PromoEntity({
    required this.id,
    required this.code,
    required this.discountPercentage,
    required this.usedCount,
    required this.isActive,
  });
}
