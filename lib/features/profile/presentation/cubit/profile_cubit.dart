// lib/profile/presentation/cubit/profile_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:catalog_admin/features/profile/domain/repositories/profile_repository.dart';
import 'package:meta/meta.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository repository;

  ProfileCubit({required this.repository}) : super(ProfileInitial());

  Future<void> updateProfile({
    required String email,
    required String password,
  }) async {
    emit(ProfileLoading());

    final result = await repository.updateProfile(
      email: email,
      password: password,
    );

    result.fold(
      (error) => emit(ProfileError(message: error)),
      (_) => emit(ProfileSuccess()),
    );
  }
}
