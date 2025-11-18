// lib/users/presentation/cubit/user_cubit.dart

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:catalog_admin/features/users/domain/repositories/user_repository.dart';
import 'package:catalog_admin/features/users/presentation/cubit/user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository repository;

  UserCubit({required this.repository}) : super(UserInitial());

  String selectedCountry = 'All';
  String searchQuery = '';
  int currentPage = 1;
  int perPage = 20;
  Timer? _debounce;

  Future<void> loadUsers() async {
    emit(UserLoading());

    final result = await repository.getUsers(
      country: selectedCountry == 'All' ? null : selectedCountry,
      searchQuery: searchQuery.isEmpty ? null : searchQuery,
      page: currentPage,
      perPage: perPage,
    );

    result.fold(
      (failure) => emit(UserError(message: failure.message)),
      (users) => emit(UserLoaded(users: users, totalCount: users.length)),
    );
  }

  void updateCountry(String country) {
    if (selectedCountry == country) return;

    selectedCountry = country;
    currentPage = 1;

    emit(UserLoading());
    loadUsers();
  }

  void updateSearchQuery(String query) {
    searchQuery = query;
    currentPage = 1;

    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      emit(UserLoading());
      loadUsers();
    });
  }

  void goToNextPage() {
    currentPage++;
    loadUsers();
  }

  void goToPreviousPage() {
    if (currentPage > 1) {
      currentPage--;
      loadUsers();
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
