class PlanStatsRow {
  final String planName;
  final int purchasedThisMonth;
  final int fullyUsedThisMonth;
  final int notFullyUsedThisMonth;

  const PlanStatsRow({
    required this.planName,
    required this.purchasedThisMonth,
    required this.fullyUsedThisMonth,
    required this.notFullyUsedThisMonth,
  });
}