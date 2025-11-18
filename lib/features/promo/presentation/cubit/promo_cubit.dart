import 'package:bloc/bloc.dart';
import 'package:catalog_admin/features/promo/domain/entities/promo_entity.dart';
import 'package:catalog_admin/features/promo/domain/repositories/promo_repository.dart';
import 'package:meta/meta.dart';

part 'promo_state.dart';

class PromoCubit extends Cubit<PromoState> {
  final PromoRepository repository;

  PromoCubit({required this.repository}) : super(PromoInitial());

  Future<void> loadPromoCodes() async {
    emit(PromoLoading());

    final result = await repository.getAllPromoCodes();

    result.fold(
      (failure) => emit(PromoError(message: failure.message)),
      (promoCodes) => emit(PromoLoaded(promoCodes: promoCodes)),
    );
  }

  Future<void> createPromoCode(double discountPercentage) async {
    final currentState = state;
    emit(PromoCreating());

    final result = await repository.createPromoCode(
      discountPercentage: discountPercentage,
    );

    result.fold(
      (failure) {
        emit(PromoError(message: failure.message));
        // Restore previous state after showing error
        if (currentState is PromoLoaded) {
          emit(currentState);
        }
      },
      (_) {
        // Reload all promo codes after creation
        loadPromoCodes();
      },
    );
  }

  Future<void> deletePromoCode(String promoId) async {
    final result = await repository.deletePromoCode(promoId);

    result.fold(
      (failure) => emit(PromoError(message: failure.message)),
      (_) => loadPromoCodes(),
    );
  }

  Future<void> togglePromoStatus(String promoId) async {
    final result = await repository.togglePromoStatus(promoId);

    result.fold(
      (failure) => emit(PromoError(message: failure.message)),
      (_) => loadPromoCodes(),
    );
  }
}
