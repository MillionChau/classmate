// lib/routes/app_routes.dart

import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
// teacher role
import '../screens/teacher/home_screen.dart' as TeacherHome;
import '../screens/teacher/enter_marks_screen.dart';
import '../screens/teacher/notification_request_screen.dart';
import '../screens/teacher/schedule_screen.dart';
// student role
import '../screens/student/home_screen.dart' as StudentHome;
<<<<<<< HEAD
import '../screens/teacher/home_screen.dart' as TeacherHome;
=======
import '../screens/student/marks_screen.dart';
import '../screens/student/notification_screen.dart';
import '../screens/student/timetable_screen.dart';

// admin role
import '../screens/admin/dashboard_screen.dart' as AdminDashboard;
import '../screens/admin/assign_schedule_screen.dart';
import '../screens/admin/approve_notification_screen.dart';
import '../screens/admin/manage_accouts_screen.dart';
import '../screens/admin/student_screen.dart';
import '../screens/admin/teacher_screen.dart';
>>>>>>> 8bd2927b1d48cdb2771c0909822b43e2f65919d4

class AppRoutes {
  static const login = '/';
  static const teacherHome = '/teacher';
  static const teacherEnterMarks = '/teacher/enter-marks';
  static const teacherNotification = '/teacher/notification-request';
  static const teacherSchedule = '/teacher/schedule';

  static const studentHome = '/student';
<<<<<<< HEAD
  static const teacherHome = '/teacher';
=======
  static const studentSchedule = '/student/timetable';
  static const studentNotification = '/student/notifications';
  static const studentMarks = '/student/marks';

  static const adminDashboard = '/admin';
  static const adminSchedule = '/admin/schedule';
  static const adminNotification = '/admin/notification';
  static const adminAccount = '/admin/account';
  static const listStudent = '/admin/student-list';
  static const listTeacher = '/admin/teacher-list';

>>>>>>> 8bd2927b1d48cdb2771c0909822b43e2f65919d4

  static final routes = <String, WidgetBuilder>{
    login: (_) => const LoginScreen(),

    teacherHome: (_) => const TeacherHome.TeacherHomePage(),
    teacherEnterMarks: (_) => const EnterMarks(),
    teacherNotification: (_) => const TeacherNotification(),
    teacherSchedule: (_) => const TeacherScheduleScreen(),

    
    studentHome: (_) => const StudentHome.StudentHomePage(),
<<<<<<< HEAD
    teacherHome: (_) => const TeacherHome.TeacherHomePage(),
=======
    studentSchedule: (_) => ThoiKhoaBieuScreen(),
    studentNotification: (_) => ThongBaoScreen(),
    studentMarks: (_) => DiemSoScreen(),

    adminDashboard: (_) => AdminDashboard.DashboardScreen(),
    adminSchedule: (_) => AssignScheduleScreen(),
    adminNotification: (_) => ApproveNotificationScreen(),
    adminAccount: (_) => ManageAccountsScreen(),
    listStudent: (_) => StudentManagementScreen(),
    listTeacher: (_) => TeacherManagementScreen(),
>>>>>>> 8bd2927b1d48cdb2771c0909822b43e2f65919d4
  };
}
