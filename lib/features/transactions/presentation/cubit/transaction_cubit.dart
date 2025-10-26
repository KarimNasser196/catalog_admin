import 'package:bloc/bloc.dart';
import 'package:catalog_admin/features/transactions/domain/entities/transaction_entity.dart';
import 'package:catalog_admin/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:equatable/equatable.dart';

part 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  final TransactionRepository repository;

  TransactionCubit({required this.repository}) : super(TransactionInitial());

  String startDate = '14 Aug 2025';
  String endDate = '17 Sep 2027';
  String selectedCountry = 'Egypt';
  String searchQuery = '';
  int currentPage = 1;

  Future<void> loadTransactions() async {
    emit(TransactionLoading());

    final result = await repository.getTransactions(
      startDate: startDate,
      endDate: endDate,
      country: selectedCountry,
      searchQuery: searchQuery.isEmpty ? null : searchQuery,
    );

    result.fold(
      (error) => emit(TransactionError(message: error)),
      (transactions) => emit(TransactionLoaded(transactions: transactions)),
    );
  }

  void updateStartDate(String date) {
    startDate = date;
    loadTransactions();
  }

  void updateEndDate(String date) {
    endDate = date;
    loadTransactions();
  }

  void updateCountry(String country) {
    selectedCountry = country;
    loadTransactions();
  }

  void updateSearchQuery(String query) {
    searchQuery = query;
    loadTransactions();
  }

  void goToNextPage() {
    currentPage++;
    loadTransactions();
  }

  void goToPreviousPage() {
    if (currentPage > 1) {
      currentPage--;
      loadTransactions();
    }
  }
}
