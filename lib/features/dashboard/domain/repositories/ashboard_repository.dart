// lib/dashboard/domain/repositories/dashboard_repository.dart

import 'package:catalog_admin/core/errors/failure.dart';
import 'package:catalog_admin/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:dartz/dartz.dart';

abstract class DashboardRepository {
  Future<Either<Failure, DashboardStatsEntity>> getDashboardStats();
}
