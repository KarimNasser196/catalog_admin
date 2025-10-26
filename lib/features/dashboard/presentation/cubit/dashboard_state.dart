// lib/dashboard/presentation/cubit/dashboard_state.dart

part of 'dashboard_cubit.dart';

@immutable
abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final DashboardStatsEntity stats;

  DashboardLoaded({required this.stats});
}

class DashboardError extends DashboardState {
  final String message;

  DashboardError({required this.message});
}
