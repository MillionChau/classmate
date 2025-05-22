<<<<<<< HEAD
// lib/main.dart
=======
import 'package:classmate_app/screens/admin/dashboard_screen.dart';
>>>>>>> a0072a239524841fe073ff58c02f285f61d2b361
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

      //initialRoute: AppRoutes.login,
      //routes: AppRoutes.routes,
    );
  }
}
