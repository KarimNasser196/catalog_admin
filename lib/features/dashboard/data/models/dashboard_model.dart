// lib/dashboard/data/models/dashboard_model.dart

import 'package:catalog_admin/features/dashboard/domain/entities/dashboard_entity.dart';

class DashboardStatsModel extends DashboardStatsEntity {
  DashboardStatsModel({
    required super.totalEarned,
    required super.totalUsers,
    super.currency,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatsModel(
      totalEarned: (json['total_earned'] ?? 0).toDouble(),
      totalUsers: json['total_users'] ?? 0,
      currency: json['currency'] ?? 'EGP',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_earned': totalEarned,
      'total_users': totalUsers,
      'currency': currency,
    };
  }
}
