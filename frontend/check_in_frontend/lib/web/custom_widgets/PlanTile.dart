import 'package:check_in_frontend/utils_mobile/CustomColors.dart';
import 'package:flutter/material.dart';

import '../utilitars/SubscriptionPlan.dart';
import 'StatusChip.dart';

class PlanTile extends StatelessWidget {
  final SubscriptionPlan plan;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleActive;

  const PlanTile({super.key,
    required this.plan,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleActive,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: CustomColors.black08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            plan.title,
                            style: const TextStyle(fontWeight: FontWeight.w900),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        StatusChip(active: plan.active),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${plan.priceRon} RON • ${plan.durationDays} days',
                      style: TextStyle(color: CustomColors.black75),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      plan.description,
                      style: TextStyle(color: CustomColors.black75),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        TextButton.icon(
                          onPressed: onToggleActive,
                          icon: Icon(plan.active ? Icons.pause : Icons.play_arrow),
                          label: Text(plan.active ? 'Disable' : 'Enable'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onEdit,
                tooltip: 'Edit',
                icon: const Icon(Icons.edit_outlined),
              ),
              IconButton(
                onPressed: onDelete,
                tooltip: 'Delete',
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),
        ),
      ),
    );
  }
}