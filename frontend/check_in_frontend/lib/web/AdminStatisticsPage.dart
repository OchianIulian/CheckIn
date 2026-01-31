import 'package:check_in_frontend/web/utilitars/KpiItem.dart';
import 'package:check_in_frontend/web/utilitars/LocationStats.dart';
import 'package:check_in_frontend/web/utilitars/PlanStatsRow.dart';
import 'package:check_in_frontend/web/utilitars/StatsLocation.dart';
import 'package:flutter/material.dart';

import 'custom_widgets/statistics/KpiCard.dart';
import 'custom_widgets/statistics/TopPlansForThisMonth.dart';

class AdminStatisticsPage extends StatefulWidget {
  const AdminStatisticsPage({super.key});

  @override
  State<AdminStatisticsPage> createState() => _AdminStatisticsPageState();
}

enum YesNo { yes, no }
enum StatsOp { count, sumPurchases, sumNotFullyUsed, avgUsageRate, minUsageRate, maxUsageRate }


class _AdminStatisticsPageState extends State<AdminStatisticsPage> {
  bool loading = false;
  String? error;

  // Filters (nullable => optional)
  int? selectedYear;
  int? selectedMonth; // 1..12
  YesNo? usageYesNo; // yes => >= percent, no => <= percent
  String? selectedPlan; // null = any, '__none__' = no plan, altfel numele planului
  StatsOp selectedOp = StatsOp.count;
  static const String _noPlanValue = '__none__';


  final TextEditingController usagePercentCtrl = TextEditingController();

  // Mock locations (in real app: from backend)
  final List<StatsLocation> locations = const [
    StatsLocation(id: 'loc_1', name: 'Location 1 (Bucharest)'),
    StatsLocation(id: 'loc_2', name: 'Location 2 (Cluj)'),
    StatsLocation(id: 'loc_3', name: 'Location 3 (Iasi)'),
  ];

  String selectedLocationId = 'loc_1';

  // Data loaded for selected location (mocked)
  LocationStats? stats;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  @override
  void dispose() {
    usagePercentCtrl.dispose();
    super.dispose();
  }

  double? _parseUsagePercent() {
    final raw = usagePercentCtrl.text.trim();
    if (raw.isEmpty) return null;
    final v = double.tryParse(raw);
    if (v == null) return null;
    if (v < 0) return 0;
    if (v > 100) return 100;
    return v;
  }

  Map<String, dynamic> _buildQueryParams() {
    final params = <String, dynamic>{};

    if (selectedPlan != null) {
      params['plan'] = selectedPlan == _noPlanValue ? 'none' : selectedPlan;
    }

    if (selectedYear != null) params['year'] = selectedYear;
    if (selectedMonth != null) params['month'] = selectedMonth;

    final pct = _parseUsagePercent();
    if (usageYesNo != null && pct != null) {
      params['usageFilter'] = usageYesNo == YesNo.yes ? 'yes' : 'no';
      params['usagePercent'] = pct;
    }

    params['op'] = selectedOp.name; // ex: "count", "avgUsageRate" etc.

    return params;
  }


  Future<void> _loadStats() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      final queryParameters = _buildQueryParams();

      // TODO: call backend with filters
      // Example:
      // final res = await api.get(
      //   '/admin/locations/$selectedLocationId/stats',
      //   queryParameters: queryParameters,
      // );
      // stats = LocationStats.fromJson(res.data);

      await Future.delayed(const Duration(milliseconds: 500));
      stats = _mockStats(
        selectedLocationId,
        year: selectedYear,
        month: selectedMonth,
        usageYesNo: usageYesNo,
        usagePercent: _parseUsagePercent(),
      );
    } catch (e) {
      error = 'Failed to load statistics.';
    } finally {
      if (!mounted) return;
      setState(() => loading = false);
    }
  }

  void _resetFilters() {
    setState(() {
      selectedPlan = null;
      selectedYear = null;
      selectedMonth = null;
      usageYesNo = null;
      usagePercentCtrl.clear();
      selectedOp = StatsOp.count;
    });
    _loadStats();
  }


  List<String> _planOptionsFromStats() {
    final s = stats;
    if (s == null) return const [];
    final names = s.topPlansThisMonth.map((e) => e.planName).toSet().toList();
    names.sort();
    return names;
  }

  String _opLabel(StatsOp op) {
    switch (op) {
      case StatsOp.count:
        return 'Count';
      case StatsOp.sumPurchases:
        return 'Sum purchases';
      case StatsOp.sumNotFullyUsed:
        return 'Sum not fully used';
      case StatsOp.avgUsageRate:
        return 'Avg usage rate';
      case StatsOp.minUsageRate:
        return 'Min usage rate';
      case StatsOp.maxUsageRate:
        return 'Max usage rate';
    }
  }




  @override
  Widget build(BuildContext context) {
    final s = stats;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(
        title: const Text('Admin Statistics'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: loading ? null : _loadStats,
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _topBar(context),
            const SizedBox(height: 12),
            Expanded(child: _body(context, s)),
          ],
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return Card(
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.place, color: Colors.black),
            const SizedBox(width: 10),
            const Text('Location', style: TextStyle(fontWeight: FontWeight.w900)),
            const SizedBox(width: 10),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: selectedLocationId,
                items: locations
                    .map(
                      (l) => DropdownMenuItem(
                    value: l.id,
                    child: Text(l.name, overflow: TextOverflow.ellipsis),
                  ),
                )
                    .toList(),
                onChanged: loading
                    ? null
                    : (v) {
                  if (v == null) return;
                  setState(() => selectedLocationId = v);
                  _loadStats();
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: loading ? null : _loadStats,
              icon: const Icon(Icons.analytics),
              label: const Text('Reload'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _body(BuildContext context, LocationStats? s) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (error != null) {
      return _errorState();
    }
    if (s == null) {
      return _emptyState();
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          _kpiGrid(s),
          const SizedBox(height: 16),

          _card(child: TopPlansThisMonth(plans: s.topPlansThisMonth)),
          const SizedBox(height: 16),

          // Advanced filters (under KPI + TopPlans)
          _card(child: _advancedFiltersBar()),
        ],
      ),
    );
  }

  Widget _advancedFiltersBar() {
    final nowYear = DateTime.now().year;
    final years = List.generate(8, (i) => nowYear - i); // last 8 years

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.filter_alt_outlined, color: Colors.black),
            SizedBox(width: 8),
            Text(
              'Advanced filters',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Use Wrap to avoid overflow on small widths
        LayoutBuilder(
          builder: (context, c) {
            final w = c.maxWidth;

            // latimi "elastice" (min/max), ca sa nu mai depaseasca
            double fieldW(double desired) => desired.clamp(160.0, (w - 24).clamp(160.0, 520.0));

            final planW = fieldW(260);
            final yearW = fieldW(160);
            final monthW = fieldW(200);
            final usedW = fieldW(200);
            final pctW = fieldW(200);
            final opW = fieldW(220);

            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                SizedBox(width: planW, child: _planDropdown()), // primul

                SizedBox(width: yearW, child: _yearDropdown(years)),
                SizedBox(width: monthW, child: _monthDropdown()),
                SizedBox(width: usedW, child: _usedDropdown()),
                SizedBox(width: pctW, child: _percentField()),

                SizedBox(width: opW, child: _operationDropdown()), // ultimul

                OutlinedButton(
                  onPressed: loading ? null : _resetFilters,
                  child: const Text('Reset'),
                ),
                ElevatedButton.icon(
                  onPressed: loading ? null : _loadStats,
                  icon: const Icon(Icons.search),
                  label: const Text('Apply'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            );
          },
        ),


        const SizedBox(height: 10),

        // Show which filters are active (optional but helpful)
        _activeFiltersChips(),
      ],
    );
  }

  Widget _planDropdown() {
    final plans = _planOptionsFromStats();

    return DropdownButtonFormField<String?>(
      value: selectedPlan,
      items: [
        const DropdownMenuItem<String?>(
          value: null,
          child: Text('Any plan'),
        ),
        const DropdownMenuItem<String?>(
          value: _noPlanValue,
          child: Text('No plan'),
        ),
        ...plans.map(
              (p) => DropdownMenuItem<String?>(
            value: p,
            child: Text(p, overflow: TextOverflow.ellipsis),
          ),
        ),
      ],
      onChanged: loading ? null : (v) => setState(() => selectedPlan = v),
      decoration: const InputDecoration(
        labelText: 'Plan',
        border: OutlineInputBorder(),
        isDense: true,
      ),
    );
  }

  Widget _operationDropdown() {
    return DropdownButtonFormField<StatsOp>(
      value: selectedOp,
      items: StatsOp.values
          .map(
            (op) => DropdownMenuItem<StatsOp>(
          value: op,
          child: Text(_opLabel(op)),
        ),
      )
          .toList(),
      onChanged: loading ? null : (v) {
        if (v == null) return;
        setState(() => selectedOp = v);
      },
      decoration: const InputDecoration(
        labelText: 'Operation',
        border: OutlineInputBorder(),
        isDense: true,
      ),
    );
  }


  Widget _usedDropdown() {
    return DropdownButtonFormField<YesNo?>(
      value: usageYesNo,
      items: const [
        DropdownMenuItem<YesNo?>(value: null, child: Text('Usage filter: Any')),
        DropdownMenuItem<YesNo?>(value: YesNo.yes, child: Text('Yes (>= %)')),
        DropdownMenuItem<YesNo?>(value: YesNo.no, child: Text('No (<= %)')),
      ],
      onChanged: loading ? null : (v) => setState(() => usageYesNo = v),
      decoration: const InputDecoration(
        labelText: 'Used?',
        border: OutlineInputBorder(),
        isDense: true,
      ),
    );
  }

  Widget _percentField() {
    return TextField(
      controller: usagePercentCtrl,
      enabled: !loading,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Percent (0-100)',
        hintText: 'e.g. 70',
        border: OutlineInputBorder(),
        isDense: true,
      ),
    );
  }

  Widget _yearDropdown(List<int> years) {
    return DropdownButtonFormField<int?>(
      value: selectedYear,
      items: [
        const DropdownMenuItem<int?>(
          value: null,
          child: Text('Any year'),
        ),
        ...years.map(
              (y) => DropdownMenuItem<int?>(
            value: y,
            child: Text('$y'),
          ),
        ),
      ],
      onChanged: loading ? null : (v) => setState(() => selectedYear = v),
      decoration: const InputDecoration(
        labelText: 'Year',
        border: OutlineInputBorder(),
        isDense: true,
      ),
    );
  }

  Widget _monthDropdown() {
    const months = [
      'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'
    ];

    return DropdownButtonFormField<int?>(
      value: selectedMonth,
      items: [
        const DropdownMenuItem<int?>(
          value: null,
          child: Text('Any month'),
        ),
        ...List.generate(
          12,
              (i) => DropdownMenuItem<int?>(
            value: i + 1,
            child: Text(months[i]),
          ),
        ),
      ],
      onChanged: loading ? null : (v) => setState(() => selectedMonth = v),
      decoration: const InputDecoration(
        labelText: 'Month',
        border: OutlineInputBorder(),
        isDense: true,
      ),
    );
  }


  Widget _activeFiltersChips() {
    final chips = <Widget>[];

    if (selectedYear != null) {
      chips.add(_chip('Year: $selectedYear'));
    }
    if (selectedMonth != null) {
      chips.add(_chip('Month: $selectedMonth'));
    }
    final pct = _parseUsagePercent();
    if (usageYesNo != null && pct != null) {
      final label = usageYesNo == YesNo.yes ? 'Usage >= ${pct.toStringAsFixed(0)}%' : 'Usage <= ${pct.toStringAsFixed(0)}%';
      chips.add(_chip(label));
    }

    if (selectedPlan != null) {
      final label = selectedPlan == _noPlanValue ? 'Plan: none' : 'Plan: $selectedPlan';
      chips.add(_chip(label));
    }

    if (selectedOp != StatsOp.count) {
      chips.add(_chip('Op: ${_opLabel(selectedOp)}'));
    }


    if (chips.isEmpty) {
      return Text(
        'No filters applied (all optional).',
        style: TextStyle(color: Colors.black.withOpacity(0.65)),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: chips,
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.06),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _kpiGrid(LocationStats s) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 900;
        final crossAxisCount = wide ? 4 : 2;

        final items = <KpiItem>[
          KpiItem(
            title: 'Total customers this year',
            value: '${s.totalCustomersThisYear}',
            subtitle: 'Unique customers (YTD)',
            icon: Icons.people,
          ),
          KpiItem(
            title: 'Purchases this month',
            value: '${s.purchasesThisMonth}',
            subtitle: 'All plans purchased',
            icon: Icons.shopping_cart,
          ),
          KpiItem(
            title: 'Not fully used (month)',
            value: '${s.notFullyUsedThisMonth}',
            subtitle: 'Customers bought but unused quota left',
            icon: Icons.timelapse,
          ),
          KpiItem(
            title: 'Usage rate (month)',
            value: '${(s.usageRateThisMonth * 100).toStringAsFixed(1)}%',
            subtitle: 'Avg used quota / bought quota',
            icon: Icons.percent,
          ),
        ];

        return GridView.builder(
          itemCount: items.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: wide ? 2.3 : 1.9,
          ),
          itemBuilder: (_, i) => KpiCard(item: items[i]),
        );
      },
    );
  }

  Widget _card({required Widget child}) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Text(
        'No statistics available.',
        style: TextStyle(color: Colors.black.withOpacity(0.7)),
      ),
    );
  }

  Widget _errorState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 40, color: Colors.red.shade700),
          const SizedBox(height: 10),
          Text(
            error ?? 'Something went wrong.',
            style: TextStyle(color: Colors.black.withOpacity(0.75)),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _loadStats,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
            child: const Text('Try again'),
          ),
        ],
      ),
    );
  }

  // Mock data (optional filters affect output just to prove wiring works)
  LocationStats _mockStats(
      String locId, {
        required int? year,
        required int? month,
        required YesNo? usageYesNo,
        required double? usagePercent,
      }) {
    final y = year ?? DateTime.now().year;
    final m = month ?? DateTime.now().month;

    // Small deterministic variation based on year/month
    final monthFactor = (m % 4) * 0.05; // 0, 0.05, 0.10, 0.15
    final yearFactor = ((y % 3) * 0.03); // 0, 0.03, 0.06

    LocationStats base;
    if (locId == 'loc_1') {
      base = LocationStats(
        totalCustomersThisYear: 1240,
        purchasesThisMonth: 186,
        notFullyUsedThisMonth: 57,
        usageRateThisMonth: 0.72,
        topPlansThisMonth: const [
          PlanStatsRow(planName: 'Basic - 8 entries', purchasedThisMonth: 72, fullyUsedThisMonth: 41, notFullyUsedThisMonth: 31),
          PlanStatsRow(planName: 'Premium - Unlimited', purchasedThisMonth: 49, fullyUsedThisMonth: 33, notFullyUsedThisMonth: 16),
          PlanStatsRow(planName: 'Student - 6 entries', purchasedThisMonth: 36, fullyUsedThisMonth: 18, notFullyUsedThisMonth: 18),
        ],
      );
    } else if (locId == 'loc_2') {
      base = LocationStats(
        totalCustomersThisYear: 670,
        purchasesThisMonth: 92,
        notFullyUsedThisMonth: 28,
        usageRateThisMonth: 0.66,
        topPlansThisMonth: const [
          PlanStatsRow(planName: 'Basic - 10 entries', purchasedThisMonth: 39, fullyUsedThisMonth: 19, notFullyUsedThisMonth: 20),
          PlanStatsRow(planName: 'Unlimited', purchasedThisMonth: 22, fullyUsedThisMonth: 14, notFullyUsedThisMonth: 8),
          PlanStatsRow(planName: 'Weekend - 4 entries', purchasedThisMonth: 17, fullyUsedThisMonth: 7, notFullyUsedThisMonth: 10),
        ],
      );
    } else {
      base = LocationStats(
        totalCustomersThisYear: 410,
        purchasesThisMonth: 61,
        notFullyUsedThisMonth: 19,
        usageRateThisMonth: 0.70,
        topPlansThisMonth: const [
          PlanStatsRow(planName: 'Starter - 5 entries', purchasedThisMonth: 28, fullyUsedThisMonth: 15, notFullyUsedThisMonth: 13),
          PlanStatsRow(planName: 'Standard - 8 entries', purchasedThisMonth: 19, fullyUsedThisMonth: 10, notFullyUsedThisMonth: 9),
          PlanStatsRow(planName: 'Unlimited', purchasedThisMonth: 9, fullyUsedThisMonth: 7, notFullyUsedThisMonth: 2),
        ],
      );
    }

    // Apply small variations
    var usage = base.usageRateThisMonth - monthFactor + yearFactor;
    usage = usage.clamp(0.0, 1.0);

    var purchases = (base.purchasesThisMonth * (1 - monthFactor + yearFactor)).round();
    var notFully = (base.notFullyUsedThisMonth * (1 + monthFactor)).round();
    var totalYtd = (base.totalCustomersThisYear * (1 + yearFactor)).round();

    // Apply usage filter if present (simulate by adjusting totals)
    if (usageYesNo != null && usagePercent != null) {
      final threshold = (usagePercent / 100).clamp(0.0, 1.0);
      final pass = usageYesNo == YesNo.yes ? usage >= threshold : usage <= threshold;
      if (!pass) {
        // Simulate "no data matching" by reducing counts
        purchases = (purchases * 0.25).round();
        notFully = (notFully * 0.25).round();
      }
    }

    return LocationStats(
      totalCustomersThisYear: totalYtd,
      purchasesThisMonth: purchases,
      notFullyUsedThisMonth: notFully,
      usageRateThisMonth: usage,
      topPlansThisMonth: base.topPlansThisMonth,
    );
  }
}
