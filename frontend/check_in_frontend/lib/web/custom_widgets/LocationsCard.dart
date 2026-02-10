import 'package:flutter/material.dart';

import '../utilitars/AdminLocation.dart';
import 'LocationTile.dart';

class LocationsCard extends StatelessWidget {
  final List<AdminLocation> locations;
  final String? selectedId;
  final ValueChanged<String> onSelect;
  final VoidCallback onAdd;
  final ValueChanged<AdminLocation> onEdit;
  final ValueChanged<AdminLocation> onDelete;

  const LocationsCard({super.key,
    required this.locations,
    required this.selectedId,
    required this.onSelect,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.place, color: Colors.black),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Locations',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
              ),
            ),
            ElevatedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('Add'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (locations.isEmpty)
          Text(
            'No locations yet. Add one to start creating subscription plans.',
            style: TextStyle(color: Colors.black.withOpacity(0.78)),
          )
        else
          Column(
            children: locations.map((l) {
              final isSelected = l.id == selectedId;
              return LocationTile(
                location: l,
                selected: isSelected,
                onTap: () => onSelect(l.id),
                onEdit: () => onEdit(l),
                onDelete: () => onDelete(l),
              );
            }).toList(),
          ),
      ],
    );
  }
}
