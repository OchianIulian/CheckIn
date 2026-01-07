import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MarketplacePage extends StatelessWidget {
  const MarketplacePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Client Marketplace Page'),
      ),
      body: const Center(
          child: Text("Aplicatia pentru clienti",
            style: TextStyle(fontSize: 18),
          )
      ),
    );
  }
}