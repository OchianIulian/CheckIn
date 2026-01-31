import 'package:flutter/material.dart';

import '../utilitars/SubscriptionPlan.dart';

class PlanEditDialog extends StatefulWidget {
  final String title;
  final SubscriptionPlan? initial;

  const PlanEditDialog({
    super.key,
    required this.title,
    required this.initial,
  });

  @override
  State<PlanEditDialog> createState() => _PlanEditDialogState();
}

class _PlanEditDialogState extends State<PlanEditDialog> {
  late final TextEditingController titleCtrl;
  late final TextEditingController priceCtrl;
  late final TextEditingController durationCtrl;
  late final TextEditingController descCtrl;

  // Number of entries
  late final TextEditingController entriesCustomCtrl;
  static const int _customOptionValue = -1;
  static const int _unlimitedOptionValue = 0; // we'll map this to null in model
  final List<int> _entryOptions = <int>[10, 25, 50, 100, _customOptionValue, _unlimitedOptionValue];

  int _selectedEntriesOption = 10; // default
  bool active = true;

  @override
  void initState() {
    super.initState();

    titleCtrl = TextEditingController(text: widget.initial?.title ?? '');
    priceCtrl = TextEditingController(text: (widget.initial?.priceRon ?? '').toString());
    durationCtrl = TextEditingController(text: (widget.initial?.durationDays ?? '').toString());
    descCtrl = TextEditingController(text: widget.initial?.description ?? '');

    active = widget.initial?.active ?? true;

    final initialLimit = widget.initial?.entriesLimit; // int? (null = unlimited)
    entriesCustomCtrl = TextEditingController();

    if (initialLimit == null) {
      // unlimited
      _selectedEntriesOption = _unlimitedOptionValue;
    } else if (_entryOptions.contains(initialLimit)) {
      // matches one of presets (10/25/50/100)
      _selectedEntriesOption = initialLimit;
    } else {
      // custom
      _selectedEntriesOption = _customOptionValue;
      entriesCustomCtrl.text = initialLimit.toString();
    }
  }

  @override
  void dispose() {
    titleCtrl.dispose();
    priceCtrl.dispose();
    durationCtrl.dispose();
    descCtrl.dispose();
    entriesCustomCtrl.dispose();
    super.dispose();
  }

  String _newId() => 'plan_${DateTime.now().microsecondsSinceEpoch}';

  int _parseInt(String s, int fallback) {
    final v = int.tryParse(s.trim());
    return v ?? fallback;
  }

  int? _computeEntriesLimit() {
    // null = unlimited
    if (_selectedEntriesOption == _unlimitedOptionValue) return null;

    if (_selectedEntriesOption == _customOptionValue) {
      final custom = _parseInt(entriesCustomCtrl.text, 0);
      // Treat <=0 as unlimited? or as invalid? Here I clamp to minimum 1.
      return custom <= 0 ? 1 : custom;
    }

    // preset value
    return _selectedEntriesOption;
  }

  String _entriesLabel(int v) {
    if (v == _customOptionValue) return 'Custom';
    if (v == _unlimitedOptionValue) return 'Unlimited';
    return v.toString();
  }

  @override
  Widget build(BuildContext context) {
    final isCustom = _selectedEntriesOption == _customOptionValue;

    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Plan title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: priceCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Price (RON)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: durationCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Duration (days)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              TextField(
                controller: descCtrl,
                minLines: 2,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              // Number of entries section
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Number of entries',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              const SizedBox(height: 6),

              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: _selectedEntriesOption,
                      items: _entryOptions
                          .map(
                            (v) => DropdownMenuItem<int>(
                          value: v,
                          child: Text(_entriesLabel(v)),
                        ),
                      )
                          .toList(),
                      onChanged: (v) {
                        if (v == null) return;
                        setState(() => _selectedEntriesOption = v);
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Entries limit',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: entriesCustomCtrl,
                      enabled: isCustom,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Custom value',
                        border: const OutlineInputBorder(),
                        hintText: isCustom ? 'e.g. 75' : '',
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              SwitchListTile(
                value: active,
                onChanged: (v) => setState(() => active = v),
                title: const Text('Active'),
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final old = widget.initial;

            final res = SubscriptionPlan(
              id: old?.id ?? _newId(),
              title: titleCtrl.text.trim(),
              priceRon: _parseInt(priceCtrl.text, 0),
              durationDays: _parseInt(durationCtrl.text, 30),
              description: descCtrl.text.trim(),
              active: active,
              entriesLimit: _computeEntriesLimit(),
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
