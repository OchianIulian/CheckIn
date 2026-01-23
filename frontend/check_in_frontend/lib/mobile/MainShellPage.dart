import 'package:check_in_frontend/mobile/ClientHomePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils_mobile/CustomColors.dart';
import 'MarketplacePage.dart';
import 'ProfilePage.dart';

class MainShellPage extends StatefulWidget {
  const MainShellPage({super.key});

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  int _index = 0;
  static const navBarHeight = 50.0;     // NavigationBar default
  static const navBottomMargin = 10.0;  // container margin bottom
  static const navOuterPadding = 10.0;  // container margin left/right, irrelevant for height
  static const extraBuffer = 12.0;      // small safety buffer



  final _pages = const [
    ClientHomePage(),
    MarketplacePage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final bodyBottomPadding =
        navBarHeight + navBottomMargin + bottomInset + extraBuffer;

    return Scaffold(
      extendBody: true,
      body: Padding(
        padding: EdgeInsets.only(bottom: bodyBottomPadding),
        child: IndexedStack(
          index: _index,
          children: _pages,
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          decoration: BoxDecoration(
            color: CustomColors.greenDark,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                blurRadius: 18,
                offset: const Offset(0, 10),
                color: Colors.black.withOpacity(0.18),
              ),
            ],
          ),
          child: NavigationBarTheme(
            data: NavigationBarThemeData(
              backgroundColor: Colors.transparent,
              elevation: 0,
              indicatorColor: Colors.white.withOpacity(0.16),
              labelTextStyle: WidgetStateProperty.resolveWith((states) {
                final selected = states.contains(WidgetState.selected);
                return TextStyle(
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                  color: Colors.white,
                );
              }),
              iconTheme: WidgetStateProperty.resolveWith((states) {
                final selected = states.contains(WidgetState.selected);
                return IconThemeData(
                  size: 24,
                  color: selected ? Colors.white : Colors.white.withOpacity(0.72),
                );
              }),
            ),
            child: NavigationBar(
              selectedIndex: _index,
              onDestinationSelected: (i) => setState(() => _index = i),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.airplane_ticket_outlined),
                  selectedIcon: Icon(Icons.airplane_ticket),
                  label: 'My Tickets',
                ),
                NavigationDestination(
                  icon: Icon(Icons.storefront_outlined),
                  selectedIcon: Icon(Icons.storefront),
                  label: 'Marketplace',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}