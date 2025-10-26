// ========== payment_model.dart ==========

import 'package:catalog_admin/features/payment/domain/entities/payment_entity.dart';

class PaymentModel extends PaymentEntity {
  const PaymentModel({
    required super.id,
    required super.user,
    required super.date,
    required super.amount,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] ?? '',
      user: json['user'] ?? '',
      date: json['date'] ?? '',
      amount: json['amount'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'user': user, 'date': date, 'amount': amount};
  }
}
