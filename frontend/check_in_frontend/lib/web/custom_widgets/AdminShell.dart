import 'package:check_in_frontend/web/AdminHomePage.dart';
import 'package:check_in_frontend/web/AdminStatisticsPage.dart';
import 'package:check_in_frontend/web/custom_widgets/SideNav.dart';
import 'package:flutter/material.dart';

// TODO: adjust imports to your paths

enum AdminPage { home, stats }

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  bool _expanded = true;
  AdminPage _selected = AdminPage.home;

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    final Widget page = switch (_selected) {
      AdminPage.home => const AdminHomePage(),
      AdminPage.stats => const AdminStatisticsPage(),
    };

    return Scaffold(
      appBar: isDesktop
          ? null
          : AppBar(
        title: const Text('Admin'),
        backgroundColor: Colors.black,
      ),
      drawer: isDesktop
          ? null
          : Drawer(
        child: SafeArea(
          child: SideNav(
            expanded: true, // pe mobile drawer-ul e full width
            selected: _selected,
            onSelect: (p) {
              setState(() => _selected = p);
              Navigator.of(context).pop();
            },
            onToggle: () {},
          ),
        ),
      ),
      body: Row(
        children: [
          if (isDesktop)
            SideNav(
              expanded: _expanded,
              selected: _selected,
              onSelect: (p) => setState(() => _selected = p),
              onToggle: () => setState(() => _expanded = !_expanded),
            ),
          Expanded(child: page),
        ],
      ),
    );
  }
}







