// lib/dashboard/data/datasources/dashboard_remote_datasource.dart

import 'package:catalog_admin/features/dashboard/data/models/dashboard_model.dart';

abstract class DashboardRemoteDataSource {
  Future<DashboardStatsModel> getDashboardStats();
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  @override
  Future<DashboardStatsModel> getDashboardStats() async {
    // TODO: Replace with actual API call
    // Example: final response = await dio.get('$baseUrl/dashboard/stats');
    // return DashboardStatsModel.fromJson(response.data);

    await Future.delayed(
      const Duration(milliseconds: 800),
    ); // Simulate network delay

    // Mock data
    return DashboardStatsModel(
      totalEarned: 65845.0,
      totalUsers: 1524,
      currency: 'EGP',
    );
  }
}
