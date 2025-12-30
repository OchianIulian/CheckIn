import 'package:check_in_frontend/web/WebApp.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'mobile/MobileApp.dart';

void main() {
  runApp(
    kIsWeb ? const WebApp() : const MobileApp(),
  );
}
