part of 'subscription_cubit.dart';

abstract class SubscriptionState extends Equatable {
  const SubscriptionState();

  @override
  List<Object> get props => [];
}

class SubscriptionInitial extends SubscriptionState {}

class SubscriptionLoading extends SubscriptionState {}

class SubscriptionLoaded extends SubscriptionState {
  final List<SubscriptionEntity> subscriptions;

  const SubscriptionLoaded({required this.subscriptions});

  @override
  List<Object> get props => [subscriptions];
}

class SubscriptionSaving extends SubscriptionState {}

class SubscriptionSaved extends SubscriptionState {}

class SubscriptionError extends SubscriptionState {
  final String message;

  const SubscriptionError({required this.message});

  @override
  List<Object> get props => [message];
}
