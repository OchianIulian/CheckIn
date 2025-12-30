import 'package:check_in_frontend/web/AdminLoginPage.dart';
import 'package:flutter/material.dart';

class WebApp extends StatelessWidget{
  const WebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Check-In Web App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: const AdminLoginPage(),
    );
  }
}