import 'package:bloc/bloc.dart';
import 'package:catalog_admin/features/subscription/domain/entities/subscription_entity.dart';
import 'package:catalog_admin/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:equatable/equatable.dart';

part 'subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  final SubscriptionRepository repository;

  SubscriptionCubit({required this.repository}) : super(SubscriptionInitial());

  String selectedContentType = ContentType.textTyping;
  List<SubscriptionEntity> subscriptions = [];

  Future<void> loadSubscriptions(String contentType) async {
    emit(SubscriptionLoading());

    final result = await repository.getSubscriptions(contentType: contentType);

    result.fold((error) => emit(SubscriptionError(message: error)), (
      loadedSubscriptions,
    ) {
      subscriptions = loadedSubscriptions;
      emit(SubscriptionLoaded(subscriptions: loadedSubscriptions));
    });
  }

  void selectContentType(String type) {
    selectedContentType = type;
    loadSubscriptions(type);
  }

  void updateCountry(int index, String newCountry) {
    if (index >= 0 && index < subscriptions.length) {
      final updatedSubscription = SubscriptionEntity(
        id: subscriptions[index].id,
        country: newCountry,
        currency: subscriptions[index].currency,
        price: subscriptions[index].price,
      );
      subscriptions[index] = updatedSubscription;
      emit(SubscriptionLoaded(subscriptions: List.from(subscriptions)));
    }
  }

  void updateCurrency(int index, String newCurrency) {
    if (index >= 0 && index < subscriptions.length) {
      final updatedSubscription = SubscriptionEntity(
        id: subscriptions[index].id,
        country: subscriptions[index].country,
        currency: newCurrency,
        price: subscriptions[index].price,
      );
      subscriptions[index] = updatedSubscription;
      emit(SubscriptionLoaded(subscriptions: List.from(subscriptions)));
    }
  }

  void updatePrice(String id, int newPrice) {
    final index = subscriptions.indexWhere((sub) => sub.id == id);
    if (index != -1) {
      final updatedSubscription = SubscriptionEntity(
        id: subscriptions[index].id,
        country: subscriptions[index].country,
        currency: subscriptions[index].currency,
        price: newPrice,
      );
      subscriptions[index] = updatedSubscription;
      emit(SubscriptionLoaded(subscriptions: List.from(subscriptions)));
    }
  }

  void addNewCountry() {
    final newId = DateTime.now().millisecondsSinceEpoch.toString();
    final newSubscription = SubscriptionEntity(
      id: newId,
      country: 'Egypt',
      currency: 'EGP',
      price: 50,
    );
    subscriptions.add(newSubscription);
    emit(SubscriptionLoaded(subscriptions: List.from(subscriptions)));
  }

  Future<void> saveChanges() async {
    emit(SubscriptionSaving());

    final result = await repository.updateSubscriptions(
      contentType: selectedContentType,
      subscriptions: subscriptions,
    );

    result.fold((error) => emit(SubscriptionError(message: error)), (_) {
      emit(SubscriptionSaved());
      emit(SubscriptionLoaded(subscriptions: subscriptions));
    });
  }
}
