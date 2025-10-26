part of 'promo_cubit.dart';

@immutable
abstract class PromoState {}

class PromoInitial extends PromoState {}

class PromoLoading extends PromoState {}

class PromoCreating extends PromoState {}

class PromoLoaded extends PromoState {
  final List<PromoEntity> promoCodes;

  PromoLoaded({required this.promoCodes});
}

class PromoError extends PromoState {
  final String message;

  PromoError({required this.message});
}
