// ==================== CUBIT - FIXED ====================
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
      (failure) {
        if (!isClosed) emit(SubscriptionError(message: failure.message));
      },
      (loadedSubscriptions) {
        subscriptions = List<SubscriptionEntity>.from(loadedSubscriptions);
        if (!isClosed) {
          emit(SubscriptionLoaded(subscriptions: List.from(subscriptions)));
        }
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
      if (!isClosed) {
        emit(SubscriptionLoaded(subscriptions: List.from(subscriptions)));
      }
    }
  }

  Future<void> addNewCountry(
    String country,
    String currency,
    String countryCode,
  ) async {
    final typeId = ContentType.getTypeId(selectedContentType);

    if (!isClosed) emit(SubscriptionSaving());

    final result = await repository.addNewCountry(
      typeId: typeId,
      countryName: country,
      currency: currency,
      countryCode: countryCode,
      price: 0,
    );

    result.fold(
      (failure) {
        if (!isClosed) emit(SubscriptionError(message: failure.message));
        Future.delayed(const Duration(milliseconds: 500), () {
          if (!isClosed) {
            emit(SubscriptionLoaded(subscriptions: List.from(subscriptions)));
          }
        });
      },
      (newCountry) {
        subscriptions = List<SubscriptionEntity>.from(subscriptions)
          ..add(newCountry);
        if (!isClosed) {
          emit(SubscriptionSaved(updatedSubscriptionId: newCountry.id));
        }
        Future.delayed(const Duration(milliseconds: 100), () {
          if (!isClosed) {
            emit(SubscriptionLoaded(subscriptions: List.from(subscriptions)));
          }
        });
      },
    );
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
      if (!isClosed) {
        emit(SubscriptionLoaded(subscriptions: List.from(subscriptions)));
      }
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
      if (!isClosed) {
        emit(SubscriptionLoaded(subscriptions: List.from(subscriptions)));
      }
    }
  }

  Future<void> updateSingleCountry(String subscriptionId) async {
    final subscriptionToUpdate = subscriptions.firstWhere(
      (sub) => sub.id == subscriptionId,
    );

    if (!isClosed) emit(SubscriptionSaving());

    final result = await repository.updateSingleCountryPrice(
      countryId: subscriptionId,
      newPrice: subscriptionToUpdate.price,
    );

    result.fold(
      (failure) {
        if (!isClosed) emit(SubscriptionError(message: failure.message));
        Future.delayed(const Duration(milliseconds: 500), () {
          if (!isClosed) {
            emit(SubscriptionLoaded(subscriptions: List.from(subscriptions)));
          }
        });
      },
      (_) {
        if (!isClosed) {
          emit(SubscriptionSaved(updatedSubscriptionId: subscriptionId));
        }
        Future.delayed(const Duration(milliseconds: 100), () {
          if (!isClosed) {
            emit(SubscriptionLoaded(subscriptions: List.from(subscriptions)));
          }
        });
      },
    );
  }
}

// Content Types mapped to API type_id
class ContentType {
  static const String textTyping = 'Text Typing';
  static const String image = 'Image';
  static const String voice = 'Voice';
  static const String video = 'Video';

  static int getTypeId(String contentType) {
    switch (contentType) {
      case textTyping:
        return 1;
      case voice:
        return 2;
      case video:
        return 3;
      case image:
        return 4;
      default:
        return 1;
    }
  }

  static String getTypeName(int typeId) {
    switch (typeId) {
      case 1:
        return textTyping;
      case 2:
        return voice;
      case 3:
        return video;
      case 4:
        return image;
      default:
        return textTyping;
    }
  }
}
