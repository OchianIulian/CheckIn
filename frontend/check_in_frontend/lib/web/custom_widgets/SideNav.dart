import 'package:check_in_frontend/web/custom_widgets/AdminShell.dart';
import 'package:check_in_frontend/web/custom_widgets/NavItem.dart';
import 'package:flutter/material.dart';

class SideNav extends StatelessWidget {
  final bool expanded;
  final AdminPage selected;
  final VoidCallback onToggle;
  final ValueChanged<AdminPage> onSelect;

  const SideNav({super.key,
    required this.expanded,
    required this.selected,
    required this.onToggle,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final width = expanded ? 260.0 : 88.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      width: width,
      decoration: const BoxDecoration(color: Colors.black),
      child: SafeArea(
        child: Column(
          children: [
            // header...
            Padding(
              padding: EdgeInsets.symmetric(horizontal: expanded ? 12 : 8, vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.admin_panel_settings, color: Colors.white),
                  if (expanded) ...[
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Admin Panel',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ] else ...[
                    const Spacer(),
                  ],
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: IconButton(
                      onPressed: onToggle,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      tooltip: expanded ? 'Collapse' : 'Expand',
                      icon: Icon(
                        expanded ? Icons.chevron_left : Icons.chevron_right,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white24, height: 1),
            const SizedBox(height: 8),

            NavItem(
              expanded: expanded,
              selected: selected == AdminPage.home,
              icon: Icons.home,
              label: 'Home',
              onTap: () => onSelect(AdminPage.home),
            ),
            NavItem(
              expanded: expanded,
              selected: selected == AdminPage.stats,
              icon: Icons.bar_chart,
              label: 'Statistics',
              onTap: () => onSelect(AdminPage.stats),
            ),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.all(12),
              child: NavItem(
                expanded: expanded,
                selected: false,
                icon: Icons.logout,
                label: 'Logout',
                onTap: () {
                  // TODO logout
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}