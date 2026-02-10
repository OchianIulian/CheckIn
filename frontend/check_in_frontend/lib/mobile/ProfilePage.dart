import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Client Profile Page'),
      ),
      body: const Center(
          child: Text("Aplicatia pentru clienti",
            style: TextStyle(fontSize: 18),
          )
      ),
    );
  }
}