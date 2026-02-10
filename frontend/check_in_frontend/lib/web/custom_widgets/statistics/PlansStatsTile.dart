import 'package:check_in_frontend/utils_mobile/CustomColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utilitars/PlanStatsRow.dart';

class PlanStatsTile extends StatelessWidget {
  final PlanStatsRow row;
  const PlanStatsTile({super.key, required this.row});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: CustomColors.black08),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              row.planName,
              style: const TextStyle(fontWeight: FontWeight.w900),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(flex: 2, child: _miniStat('Purchased', row.purchasedThisMonth)),
          Expanded(flex: 2, child: _miniStat('Fully used', row.fullyUsedThisMonth)),
          Expanded(flex: 2, child: _miniStat('Not fully used', row.notFullyUsedThisMonth)),
        ],
      ),
    );
  }

  Widget _miniStat(String label, int value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: CustomColors.black65, fontSize: 12)),
        const SizedBox(height: 4),
        Text('$value', style: const TextStyle(fontWeight: FontWeight.w900)),
      ],
    );
  }
}