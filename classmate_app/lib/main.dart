// lib/main.dart
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
      title: 'ClassMate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes,
    );
  }
}
