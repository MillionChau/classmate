import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:classmate_app/providers/user_provider.dart'; // Import UserProvider
import 'routes/app_routes.dart';

void main() {
  runApp(const ClassMateApp());
}

class ClassMateApp extends StatelessWidget {
  const ClassMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProvider()..loadUserData(),
      child: MaterialApp(
        title: 'ClassMate',
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.login,
        routes: AppRoutes.routes,
      ),
    );
  }
}