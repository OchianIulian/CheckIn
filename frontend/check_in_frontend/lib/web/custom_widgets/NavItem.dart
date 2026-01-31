import 'package:flutter/material.dart';

class NavItem extends StatelessWidget {
  final bool expanded;
  final bool selected;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const NavItem({super.key,
    required this.expanded,
    required this.selected,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected ? Colors.white.withOpacity(0.14) : Colors.transparent;

    return Material(
      color: bg,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: expanded ? 12 : 6,
            vertical: 12,
          ),
          child: expanded
              ? Row(
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          )
              : Center(
            child: Icon(icon, color: Colors.white),
          ),
        ),
      ),
    );
  }
}