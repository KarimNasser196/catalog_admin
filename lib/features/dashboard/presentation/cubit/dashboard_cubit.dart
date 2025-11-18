// lib/dashboard/presentation/cubit/dashboard_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:catalog_admin/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:catalog_admin/features/dashboard/domain/repositories/ashboard_repository.dart';
import 'package:meta/meta.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepository repository;

  DashboardCubit({required this.repository}) : super(DashboardInitial());

  Future<void> loadDashboardStats() async {
    emit(DashboardLoading());

    final result = await repository.getDashboardStats();

    result.fold(
      (error) => emit(DashboardError(message: error.message)),
      (stats) => emit(DashboardLoaded(stats: stats)),
    );
  }
}
