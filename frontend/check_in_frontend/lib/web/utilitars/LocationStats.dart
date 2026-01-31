import 'PlanStatsRow.dart';

class LocationStats {
  final int totalCustomersThisYear;
  final int purchasesThisMonth;
  final int notFullyUsedThisMonth;
  final double usageRateThisMonth;
  final List<PlanStatsRow> topPlansThisMonth;

  LocationStats({
    required this.totalCustomersThisYear,
    required this.purchasesThisMonth,
    required this.notFullyUsedThisMonth,
    required this.usageRateThisMonth,
    required this.topPlansThisMonth,
  });
}