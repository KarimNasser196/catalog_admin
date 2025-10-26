// ========== payment_state.dart ==========
part of 'payment_cubit.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentLoaded extends PaymentState {
  final List<PaymentEntity> payments;

  const PaymentLoaded({required this.payments});

  @override
  List<Object> get props => [payments];
}

class PaymentError extends PaymentState {
  final String message;

  const PaymentError({required this.message});

  @override
  List<Object> get props => [message];
}
