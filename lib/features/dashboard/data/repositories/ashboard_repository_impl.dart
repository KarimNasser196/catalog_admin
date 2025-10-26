// lib/dashboard/data/repositories/dashboard_repository_impl.dart

import 'package:catalog_admin/features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:catalog_admin/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:catalog_admin/features/dashboard/domain/repositories/ashboard_repository.dart';
import 'package:dartz/dartz.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, DashboardStatsEntity>> getDashboardStats() async {
    try {
      final result = await remoteDataSource.getDashboardStats();
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
