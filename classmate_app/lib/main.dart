<<<<<<< HEAD
=======
// lib/main.dart

import 'package:flutter/material.dart';

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
    );
  }
}
>>>>>>> 7d4fcb01065babd82dc557bb5d15c510387ae653
