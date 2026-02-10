import 'package:flutter/material.dart';

class CompanyCard extends StatelessWidget {
  final String name;
  final String location;
  final String description;
  final VoidCallback onEdit;

  const CompanyCard({super.key,
    required this.name,
    required this.location,
    required this.description,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.business, color: Colors.black),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Location details',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
              ),
            ),
            TextButton.icon(
              onPressed: onEdit,
              icon: const Icon(Icons.edit, size: 18),
              label: const Text('Edit'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _kv('Name', name),
        const SizedBox(height: 8),
        _kv('Address', location),
        const SizedBox(height: 8),
        const Text(
          'Description',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        Text(
          description,
          style: TextStyle(color: Colors.black.withOpacity(0.78)),
        ),
      ],
    );
  }

  Widget _kv(String k, String v) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 88,
          child: Text(
            k,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
        Expanded(
          child: Text(
            v,
            style: TextStyle(color: Colors.black.withOpacity(0.78)),
          ),
        ),
      ],
    );
  }
}