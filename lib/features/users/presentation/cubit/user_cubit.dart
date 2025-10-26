// user_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:catalog_admin/features/users/domain/entities/user_entity.dart';
import 'package:catalog_admin/features/users/domain/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository repository;

  UserCubit({required this.repository}) : super(UserInitial());

  String selectedCountry = 'Egypt';
  String searchQuery = '';
  int currentPage = 1;

  Future<void> loadUsers() async {
    emit(UserLoading());

    final result = await repository.getUsers(
      country: selectedCountry,
      searchQuery: searchQuery.isEmpty ? null : searchQuery,
      page: currentPage,
    );

    result.fold(
      (error) => emit(UserError(message: error)),
      (users) => emit(UserLoaded(users: users)),
    );
  }

  void updateCountry(String country) {
    selectedCountry = country;
    currentPage = 1;
    loadUsers();
  }

  void updateSearchQuery(String query) {
    searchQuery = query;
    currentPage = 1;
    loadUsers();
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
}
