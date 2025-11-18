import 'package:catalog_admin/features/dashboard/domain/entities/dashboard_entity.dart';

class DashboardStatsModel extends DashboardStatsEntity {
  DashboardStatsModel({required super.totalEarned, required super.totalUsers});

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    // Handle nested data structure from API
    final data = json['data'] ?? json;

    return DashboardStatsModel(
      totalEarned: _parseDouble(data['total_earned']),
      totalUsers: _parseInt(data['total_users']),
    );
  }

  // Helper to safely parse double
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  // Helper to safely parse int
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {'total_earned': totalEarned, 'total_users': totalUsers};
  }
}
