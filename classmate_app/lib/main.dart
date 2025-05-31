import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
<<<<<<< HEAD
import 'package:classmate_app/providers/user_provider.dart'; // Import UserProvider
import 'routes/app_routes.dart';
=======
import './provider/user_provider.dart';
import './routes/app_routes.dart';
>>>>>>> 8bd2927b1d48cdb2771c0909822b43e2f65919d4

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
<<<<<<< HEAD
    return ChangeNotifierProvider(
      create: (context) => UserProvider()..loadUserData(),
      child: MaterialApp(
        title: 'ClassMate',
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.login,
        routes: AppRoutes.routes,
      ),
=======
    return MaterialApp(
      title: 'ClassMate',
      debugShowCheckedModeBanner: false,

      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes,
>>>>>>> 8bd2927b1d48cdb2771c0909822b43e2f65919d4
    );
  }
}