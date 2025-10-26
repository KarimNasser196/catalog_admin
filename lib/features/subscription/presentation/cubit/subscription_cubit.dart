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
    print('🔄 Loading subscriptions for: $contentType');
    emit(SubscriptionLoading());

    final result = await repository.getSubscriptions(contentType: contentType);

    result.fold(
      (error) {
        print('❌ Error loading subscriptions: $error');
        emit(SubscriptionError(message: error));
      },
      (loadedSubscriptions) {
        print('✅ Loaded ${loadedSubscriptions.length} subscriptions');
        subscriptions = List<SubscriptionEntity>.from(loadedSubscriptions);
        print('📋 Current subscriptions: ${subscriptions.length}');
        emit(SubscriptionLoaded(subscriptions: List.from(subscriptions)));
      },
    );
  }

  void selectContentType(String type) {
    print('🔀 Selecting content type: $type');
    selectedContentType = type;
    loadSubscriptions(type);
  }

  void updateCountry(int index, String newCountry) {
    print('🌍 Updating country at index $index to $newCountry');
    if (index >= 0 && index < subscriptions.length) {
      final oldSub = subscriptions[index];
      // Create entirely new list
      subscriptions = List<SubscriptionEntity>.from(subscriptions);
      subscriptions[index] = SubscriptionEntity(
        id: oldSub.id,
        country: newCountry,
        currency: oldSub.currency,
        price: oldSub.price,
      );
      print('✅ Country updated, emitting new state');
      emit(SubscriptionLoaded(subscriptions: List.from(subscriptions)));
    }
  }

  void updateCurrency(int index, String newCurrency) {
    print('💱 Updating currency at index $index to $newCurrency');
    if (index >= 0 && index < subscriptions.length) {
      final oldSub = subscriptions[index];
      // Create entirely new list
      subscriptions = List<SubscriptionEntity>.from(subscriptions);
      subscriptions[index] = SubscriptionEntity(
        id: oldSub.id,
        country: oldSub.country,
        currency: newCurrency,
        price: oldSub.price,
      );
      print('✅ Currency updated, emitting new state');
      emit(SubscriptionLoaded(subscriptions: List.from(subscriptions)));
    }
  }

  void updatePrice(String id, int newPrice) {
    print('💰 Updating price for id $id to $newPrice');
    final index = subscriptions.indexWhere((sub) => sub.id == id);
    if (index != -1) {
      final oldSub = subscriptions[index];
      // Create entirely new list
      subscriptions = List<SubscriptionEntity>.from(subscriptions);
      subscriptions[index] = SubscriptionEntity(
        id: oldSub.id,
        country: oldSub.country,
        currency: oldSub.currency,
        price: newPrice,
      );
      print('✅ Price updated, emitting new state');
      emit(SubscriptionLoaded(subscriptions: List.from(subscriptions)));
    }
  }

  void addNewCountry() {
    print('➕ Adding new country...');
    print('📊 Before add - subscriptions count: ${subscriptions.length}');

    final newId = DateTime.now().millisecondsSinceEpoch.toString();
    final newSubscription = SubscriptionEntity(
      id: newId,
      country: 'Egypt',
      currency: 'EGP',
      price: 50,
    );

    // Create a completely new list
    subscriptions = List<SubscriptionEntity>.from(subscriptions)
      ..add(newSubscription);

    print('📊 After add - subscriptions count: ${subscriptions.length}');
    print(
      '📋 Subscription list: ${subscriptions.map((s) => '${s.country}-${s.currency}').join(', ')}',
    );

    // Emit with brand new list
    emit(
      SubscriptionLoaded(
        subscriptions: List<SubscriptionEntity>.from(subscriptions),
      ),
    );
    print('✅ State emitted with ${subscriptions.length} subscriptions');
  }

  Future<void> saveChanges() async {
    print('💾 Saving ${subscriptions.length} subscriptions...');
    emit(SubscriptionSaving());

    final result = await repository.updateSubscriptions(
      contentType: selectedContentType,
      subscriptions: subscriptions,
    );

    result.fold(
      (error) {
        print('❌ Error saving: $error');
        emit(SubscriptionError(message: error));
      },
      (_) {
        print('✅ Saved successfully!');
        emit(SubscriptionSaved());
        // Wait a tiny bit then reload to show saved data
        Future.delayed(const Duration(milliseconds: 100), () {
          emit(SubscriptionLoaded(subscriptions: List.from(subscriptions)));
        });
      },
    );
  }
}
