// ==================== CUBIT ====================
// lib/subscription/presentation/cubit/subscription_cubit.dart

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
    selectedContentType = contentType;
    final typeId = ContentType.getTypeId(contentType);

    emit(SubscriptionLoading());

    final result = await repository.getSubscriptions(typeId: typeId);

    result.fold(
      (failure) => emit(SubscriptionError(message: failure.message)),
      (loadedSubscriptions) {
        subscriptions = List<SubscriptionEntity>.from(loadedSubscriptions);
        emit(SubscriptionLoaded(subscriptions: List.from(subscriptions)));
      },
    );
  }

  void selectContentType(String type) {
    selectedContentType = type;
    loadSubscriptions(type);
  }

  void updateCountry(int index, String newCountry, String newCode) {
    if (index >= 0 && index < subscriptions.length) {
      final oldSub = subscriptions[index];
      subscriptions = List<SubscriptionEntity>.from(subscriptions);
      subscriptions[index] = SubscriptionEntity(
        id: oldSub.id,
        country: newCountry,
        currency: oldSub.currency,
        countryCode: newCode,
        price: oldSub.price,
      );
      emit(SubscriptionLoaded(subscriptions: List.from(subscriptions)));
    }
  }

  void updateCurrency(int index, String newCurrency) {
    if (index >= 0 && index < subscriptions.length) {
      final oldSub = subscriptions[index];
      subscriptions = List<SubscriptionEntity>.from(subscriptions);
      subscriptions[index] = SubscriptionEntity(
        id: oldSub.id,
        country: oldSub.country,
        currency: newCurrency,
        countryCode: oldSub.countryCode,
        price: oldSub.price,
      );
      emit(SubscriptionLoaded(subscriptions: List.from(subscriptions)));
    }
  }

  void updatePrice(String id, int newPrice) {
    final index = subscriptions.indexWhere((sub) => sub.id == id);
    if (index != -1) {
      final oldSub = subscriptions[index];
      subscriptions = List<SubscriptionEntity>.from(subscriptions);
      subscriptions[index] = SubscriptionEntity(
        id: oldSub.id,
        country: oldSub.country,
        currency: oldSub.currency,
        countryCode: oldSub.countryCode,
        price: newPrice,
      );
      emit(SubscriptionLoaded(subscriptions: List.from(subscriptions)));
    }
  }

  void addNewCountry(String country, String currency, String countryCode) {
    final newId = DateTime.now().millisecondsSinceEpoch.toString();
    final newSubscription = SubscriptionEntity(
      id: newId,
      country: country,
      currency: currency,
      countryCode: countryCode,
      price: 0,
    );

    subscriptions = List<SubscriptionEntity>.from(subscriptions)
      ..add(newSubscription);

    emit(
      SubscriptionLoaded(
        subscriptions: List<SubscriptionEntity>.from(subscriptions),
      ),
    );
  }

  Future<void> saveChanges() async {
    final typeId = ContentType.getTypeId(selectedContentType);

    emit(SubscriptionSaving());

    final result = await repository.updateSubscriptions(
      typeId: typeId,
      subscriptions: subscriptions,
    );

    result.fold(
      (failure) => emit(SubscriptionError(message: failure.message)),
      (_) {
        emit(SubscriptionSaved());
        Future.delayed(const Duration(milliseconds: 100), () {
          emit(SubscriptionLoaded(subscriptions: List.from(subscriptions)));
        });
      },
    );
  }
}
