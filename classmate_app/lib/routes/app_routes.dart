// lib/routes/app_routes.dart

import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/student/home_screen.dart' as StudentHome;

class AppRoutes {
  static const login = '/';
  static const studentHome = '/student';
  
  static final routes = <String, WidgetBuilder>{
    login: (_) => const LoginScreen(),
    studentHome: (_) => const StudentHome.StudentHomePage(),
  };
}
