// ========== payment_cubit.dart ==========
import 'package:bloc/bloc.dart';
import 'package:catalog_admin/features/payment/domain/entities/payment_entity.dart';
import 'package:catalog_admin/features/payment/domain/repositories/payment_repository.dart';
import 'package:equatable/equatable.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final PaymentRepository repository;

  PaymentCubit({required this.repository}) : super(PaymentInitial());

  String startDate = '14 Aug 2025';
  String endDate = '17 Sep 2027';
  String selectedCountry = 'Egypt';
  int currentPage = 1;
  String totalEarned = '0 EGP';

  Future<void> loadPayments() async {
    emit(PaymentLoading());

    final paymentResult = await repository.getPayments(
      startDate: startDate,
      endDate: endDate,
      country: selectedCountry,
    );

    final totalResult = await repository.getTotalEarned(
      startDate: startDate,
      endDate: endDate,
      country: selectedCountry,
    );

    totalResult.fold(
      (error) => totalEarned = '0 EGP',
      (total) => totalEarned = total,
    );

    paymentResult.fold(
      (error) => emit(PaymentError(message: error)),
      (payments) => emit(PaymentLoaded(payments: payments)),
    );
  }

  void updateStartDate(String date) {
    startDate = date;
    loadPayments();
  }

  void updateEndDate(String date) {
    endDate = date;
    loadPayments();
  }

  void updateCountry(String country) {
    selectedCountry = country;
    loadPayments();
  }

  void goToNextPage() {
    currentPage++;
    loadPayments();
  }

  void goToPreviousPage() {
    if (currentPage > 1) {
      currentPage--;
      loadPayments();
    }
  }
}
