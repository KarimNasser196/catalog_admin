// lib/auth/presentation/cubit/auth_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:catalog_admin/features/auth/domain/entities/auth_entity.dart';
import 'package:catalog_admin/features/auth/domain/repositories/auth_repository.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repository;

  AuthCubit({required this.repository}) : super(AuthInitial());

  Future<void> login({
    required String emailOrPhone,
    required String password,
  }) async {
    emit(AuthLoading());

    final result = await repository.login(
      emailOrPhone: emailOrPhone,
      password: password,
    );

    result.fold(
      (error) => emit(AuthError(message: error)),
      (auth) => emit(AuthAuthenticated(user: auth)),
    );
  }

  Future<void> logout() async {
    emit(AuthLoading());

    final result = await repository.logout();

    result.fold(
      (error) => emit(AuthError(message: error)),
      (_) => emit(AuthUnauthenticated()),
    );
  }

  Future<void> checkAuthStatus() async {
    emit(AuthLoading());

    final result = await repository.checkAuthStatus();

    result.fold((error) => emit(AuthUnauthenticated()), (auth) {
      if (auth != null && auth.isAuthenticated) {
        emit(AuthAuthenticated(user: auth));
      } else {
        emit(AuthUnauthenticated());
      }
    });
  }
}
