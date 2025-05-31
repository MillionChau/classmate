import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:classmate_app/providers/user_provider.dart'; // Import UserProvider
import 'routes/app_routes.dart';
import './provider/user_provider.dart';
import './routes/app_routes.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
    return MaterialApp(
      title: 'ClassMate',
      debugShowCheckedModeBanner: false,

      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes,
    );
  }
}