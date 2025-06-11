import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';

// Student
import '../screens/student/home_screen.dart' as StudentHome;
import '../screens/student/marks_screen.dart';
import '../screens/student/notification_screen.dart';
import '../screens/student/timetable_screen.dart';

// Teacher
import '../screens/teacher/home_screen.dart' as TeacherHome;
import '../screens/teacher/enter_marks_screen.dart';
import '../screens/teacher/notification_request_screen.dart';
import '../screens/teacher/schedule_screen.dart';

// Admin
import '../screens/admin/dashboard_screen.dart' as AdminDashboard;
import '../screens/admin/approve_notification_screen.dart';
import '../screens/admin/assign_schedule_screen.dart';
import '../screens/admin/manage_accouts_screen.dart';
import '../screens/admin/student_screen.dart';
import '../screens/admin/teacher_screen.dart';

class AppRoutes {
  // Login
  static const login = '/';

  // Student
  static const studentHome = '/student';
  static const studentSchedule = '/student/timetable';
  static const studentNotification = '/student/notifications';
  static const studentMarks = '/student/marks';

  // Teacher
  static const teacherHome = '/teacher';
  static const teacherSchedule = '/teacher/schedule';
  static const teacherEnterMarks = '/teacher/enter-marks';
  static const teacherNotification = '/teacher/notification-request';

  // Admin
  static const adminDashboard = '/admin';
  static const listStudent = '/admin/students';
  static const listTeacher = '/admin/teachers';
  static const adminAccount = '/admin/manage-accounts';
  static const adminSchedule = '/admin/assign-schedule';
  static const adminNotification = '/admin/approve-notifications';

  // Routes Map
  static final routes = <String, WidgetBuilder>{
    login: (_) => const LoginScreen(),

    // Student
    studentHome: (_) => const StudentHome.StudentHomePage(),
    studentSchedule: (_) => ThoiKhoaBieuScreen(),
    studentNotification: (_) => ThongBaoScreen(),
    studentMarks: (_) => DiemSoScreen(),

    // Teacher
    teacherHome: (_) => const TeacherHome.TeacherHomePage(),
    teacherSchedule: (_) => const TeacherScheduleScreen(),
    teacherEnterMarks: (_) => const EnterMarks(),
    teacherNotification: (_) => const TeacherNotification(),

    // Admin
    adminDashboard: (_) => AdminDashboard.DashboardScreen(),
    listStudent: (_) => StudentManagementScreen(),
    listTeacher: (_) => TeacherManagementScreen(),
    adminAccount: (_) => ManageAccountsScreen(),
    adminSchedule: (_) => AssignScheduleScreen(),
    adminNotification: (_) => ApproveNotificationScreen(),
  };
}
