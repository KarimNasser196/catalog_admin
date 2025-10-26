// ========== payment_entity.dart ==========
import 'package:equatable/equatable.dart';

class PaymentEntity extends Equatable {
  final String id;
  final String user;
  final String date;
  final String amount;

  const PaymentEntity({
    required this.id,
    required this.user,
    required this.date,
    required this.amount,
  });

  @override
  List<Object?> get props => [id, user, date, amount];
}
