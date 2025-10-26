// lib/dashboard/domain/entities/dashboard_entity.dart

class DashboardStatsEntity {
  final double totalEarned;
  final int totalUsers;
  final String currency;

  DashboardStatsEntity({
    required this.totalEarned,
    required this.totalUsers,
    this.currency = 'EGP',
  });
}
