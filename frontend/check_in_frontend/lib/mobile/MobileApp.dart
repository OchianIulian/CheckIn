import 'package:check_in_frontend/mobile/ClientLoginPage.dart';
import 'package:flutter/material.dart';

class MobileApp extends StatelessWidget  {
  const MobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Check-In Mobile App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const ClientLoginPage(),
    );
  }
}
