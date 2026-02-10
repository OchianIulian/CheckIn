import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;

class StatusChip extends StatelessWidget {
  final bool active;

  const StatusChip({super.key, required this.active});

  @override
  Widget build(BuildContext context) {
    final bg = active
        ? const Color.fromRGBO(76, 175, 80, 0.14) // verde cu opacitate 0.14
        : const Color.fromRGBO(255, 152, 0, 0.14); // portocaliu cu opacitate 0.14
    final fg = active ? Colors.green.shade800 : Colors.orange.shade800;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        active ? 'Active' : 'Inactive',
        style: TextStyle(fontWeight: FontWeight.w800, color: fg, fontSize: 12),
      ),
    );
  }
}

