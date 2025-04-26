<<<<<<< HEAD
=======
// lib/main.dart

>>>>>>> 814d39281f518b60938b35860c6a3d789cfae7a9
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
