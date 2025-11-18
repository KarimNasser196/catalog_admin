// lib/dashboard/data/datasources/dashboard_remote_datasource.dart

import 'package:catalog_admin/core/api/api_consumer.dart';
import 'package:catalog_admin/core/api/end_ponits.dart';
import 'package:catalog_admin/features/dashboard/data/models/dashboard_model.dart';

abstract class DashboardRemoteDataSource {
  Future<DashboardStatsModel> getDashboardStats();
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final ApiConsumer apiConsumer;

  DashboardRemoteDataSourceImpl(this.apiConsumer);

  @override
  Future<DashboardStatsModel> getDashboardStats() async {
    final response = await apiConsumer.get(EndPoint.dashboardStats);
    return DashboardStatsModel.fromJson(response);
  }
}
