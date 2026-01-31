import 'package:flutter/cupertino.dart';

class KpiItem {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;

  KpiItem({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
  });
}