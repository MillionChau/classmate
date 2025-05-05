// lib/main.dart

import 'package:classmate_app/screens/admin/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(const ClassMateApp());
}

class ClassMateApp extends StatelessWidget {
  const ClassMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      title: 'ClassMate',
      debugShowCheckedModeBanner: false,

      // Uncomment when ready
      // initialRoute: AppRoutes.login,
      // routes: AppRoutes.routes,
    );
  }
}
