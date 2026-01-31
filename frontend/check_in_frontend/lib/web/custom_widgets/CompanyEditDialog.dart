import 'package:flutter/material.dart';

import '../utilitars/CompanyEditResult.dart';

class CompanyEditDialog extends StatefulWidget {
  final String initialName;
  final String initialLocation;
  final String initialDescription;

  const CompanyEditDialog({
    super.key,
    required this.initialName,
    required this.initialLocation,
    required this.initialDescription,
  });

  @override
  State<CompanyEditDialog> createState() => _CompanyEditDialogState();
}

class _CompanyEditDialogState extends State<CompanyEditDialog> {
  late final TextEditingController nameCtrl;
  late final TextEditingController locCtrl;
  late final TextEditingController descCtrl;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.initialName);
    locCtrl = TextEditingController(text: widget.initialLocation);
    descCtrl = TextEditingController(text: widget.initialDescription);
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    locCtrl.dispose();
    descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit company details'),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Company name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: locCtrl,
                decoration: const InputDecoration(
                  labelText: 'Company location',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descCtrl,
                minLines: 3,
                maxLines: 6,
                decoration: const InputDecoration(
                  labelText: 'Description',
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
            Navigator.pop(
              context,
              CompanyEditResult(
                name: nameCtrl.text.trim(),
                location: locCtrl.text.trim(),
                description: descCtrl.text.trim(),
              ),
            );
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