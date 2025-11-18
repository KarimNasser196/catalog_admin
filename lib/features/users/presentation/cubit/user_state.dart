// lib/users/presentation/cubit/user_state.dart

import 'package:catalog_admin/features/users/domain/entities/user_entity.dart';

// ✅ امسح Equatable - ده السبب في إن الـ UI مش بيتحدث
abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<UserEntity> users;
  final int totalCount;

  UserLoaded({required this.users, this.totalCount = 0});
}

class UserError extends UserState {
  final String message;

  UserError({required this.message});
}
