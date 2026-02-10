import 'package:flutter/material.dart';

import '../utilitars/AdminLocation.dart';

class LocationEditDialog extends StatefulWidget {
  final String title;
  final AdminLocation? initial;

  const LocationEditDialog({
    super.key,
    required this.title,
    required this.initial,
  });

  @override
  State<LocationEditDialog> createState() => _LocationEditDialogState();
}

class _LocationEditDialogState extends State<LocationEditDialog> {
  late final TextEditingController nameCtrl;
  late final TextEditingController addressCtrl;
  late final TextEditingController cityCtrl;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.initial?.name ?? '');
    addressCtrl = TextEditingController(text: widget.initial?.address ?? '');
    cityCtrl = TextEditingController(text: widget.initial?.city ?? '');
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    addressCtrl.dispose();
    cityCtrl.dispose();
    super.dispose();
  }

  String _newId() => 'loc_${DateTime.now().microsecondsSinceEpoch}';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Location name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: addressCtrl,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: cityCtrl,
                decoration: const InputDecoration(
                  labelText: 'City',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            final old = widget.initial;
            final res = AdminLocation(
              id: old?.id ?? _newId(),
              name: nameCtrl.text.trim(),
              address: addressCtrl.text.trim(),
              city: cityCtrl.text.trim(),
              plans: old?.plans ?? const [],
            );
            Navigator.pop(context, res);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }
}