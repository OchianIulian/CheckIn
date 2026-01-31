import 'package:flutter/material.dart';

class CardSetupCard extends StatelessWidget {
  final bool configured;
  final String? brand;
  final String? last4;
  final VoidCallback onConfigure;
  final VoidCallback onRemove;

  const CardSetupCard({super.key,
    required this.configured,
    required this.brand,
    required this.last4,
    required this.onConfigure,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.credit_card, color: Colors.black),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Payout card setup',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (!configured)
          Text(
            'No card configured yet. Configure a card to receive payouts.',
            style: TextStyle(color: Colors.black.withOpacity(0.78)),
          )
        else
          Row(
            children: [
              const Icon(Icons.verified, color: Colors.green),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Configured: ${brand ?? 'CARD'} •••• ${last4 ?? '----'}',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: configured ? null : onConfigure,
                icon: const Icon(Icons.settings),
                label: const Text('Configure'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: configured ? onRemove : null,
                icon: const Icon(Icons.delete_outline),
                label: const Text('Remove'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}