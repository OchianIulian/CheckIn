import 'package:flutter/material.dart';

import '../../utilitars/PlanStatsRow.dart';
import 'PlansStatsTile.dart';

class TopPlansThisMonth extends StatelessWidget {
  final List<PlanStatsRow> plans;
  const TopPlansThisMonth({super.key, required this.plans});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.star_outline, color: Colors.black),
            SizedBox(width: 8),
            Text(
              'Top plans this month',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
            ),
          ],
        ),
        const SizedBox(height: 12),
        for (final p in plans) ...[
          PlanStatsTile(row: p),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}