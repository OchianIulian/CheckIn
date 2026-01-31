import 'package:check_in_frontend/utils_mobile/CustomColors.dart';
import 'package:flutter/material.dart';
import '../utilitars/AdminLocation.dart';
import '../utilitars/SubscriptionPlan.dart';
import 'PlanTile.dart';

class PlansCard extends StatelessWidget {
  final AdminLocation? location;
  final ValueChanged<AdminLocation> onAdd;
  final void Function(AdminLocation, SubscriptionPlan) onEdit;
  final void Function(AdminLocation, SubscriptionPlan) onDelete;
  final void Function(AdminLocation, SubscriptionPlan) onToggleActive;

  const PlansCard({
    super.key,
    required this.location,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleActive,
  });

  String _entriesText(SubscriptionPlan p) {
    final limit = p.entriesLimit; // int? (null = unlimited)
    return limit == null ? 'Unlimited' : limit.toString();
  }

  @override
  Widget build(BuildContext context) {
    final loc = location;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.subscriptions, color: Colors.black),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                loc == null ? 'Subscription plans' : 'Plans for: ${loc.name}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            ElevatedButton.icon(
              onPressed: loc == null ? null : () => onAdd(loc),
              icon: const Icon(Icons.add),
              label: const Text('Add plan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (loc == null)
          Text(
            'Select a location to manage its plans.',
            style: TextStyle(color: CustomColors.black78),
          )
        else if (loc.plans.isEmpty)
          Text(
            'No plans yet for this location. Add one.',
            style: TextStyle(color: CustomColors.black78),
          )
        else
          Column(
            children: loc.plans.map((p) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: PlanTile(
                        plan: p,
                        onEdit: () => onEdit(loc, p),
                        onDelete: () => onDelete(loc, p),
                        onToggleActive: () => onToggleActive(loc, p),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Chip(
                      label: Text('Entries: ${_entriesText(p)}'),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}
