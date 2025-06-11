import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final String role;
  final String name;

  const Sidebar({super.key, required this.role, required this.name});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
        children: [
          Text(
            'Xin chào, $name',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Divider(),

          // Menu dùng chung
          ListTile(
            key: const Key('home_tile'),
            leading: const Icon(Icons.home),
            title: const Text('Trang chủ'),
            onTap: () => Navigator.pushNamed(context, '/$role'), // Changed to pushNamed
          ),

          // Menu riêng theo vai trò
          if (role == 'student') ...[
            ListTile(
              key: const Key('student_timetable_tile'),
              leading: const Icon(Icons.calendar_today),
              title: const Text('Thời khoá biểu'),
              onTap: () => Navigator.pushNamed(context, '/student/timetable'),
            ),
            ListTile(
              key: const Key('student_notifications_tile'),
              leading: const Icon(Icons.notifications),
              title: const Text('Thông báo'),
              onTap: () => Navigator.pushNamed(context, '/student/notifications'),
            ),
            ListTile(
              key: const Key('student_marks_tile'),
              leading: const Icon(Icons.grade),
              title: const Text('Xem điểm'),
              onTap: () => Navigator.pushNamed(context, '/student/marks'),
            ),
          ] else if (role == 'teacher') ...[
            ListTile(
              key: const Key('teacher_schedule_tile'),
              leading: const Icon(Icons.schedule),
              title: const Text('Lịch giảng dạy'),
              onTap: () => Navigator.pushNamed(context, '/teacher/schedule'),
            ),
            ListTile(
              key: const Key('teacher_enter_marks_tile'),
              leading: const Icon(Icons.edit),
              title: const Text('Nhập điểm'),
              onTap: () => Navigator.pushNamed(context, '/teacher/enter-marks'),
            ),
            ListTile(
              key: const Key('teacher_notification_tile'),
              leading: const Icon(Icons.send),
              title: const Text('Gửi thông báo'),
              onTap: () => Navigator.pushNamed(context, '/teacher/notification-request'),
            ),
          ] else if (role == 'admin') ...[
            ListTile(
              key: const Key('admin_manage_accounts_tile'),
              leading: const Icon(Icons.manage_accounts),
              title: const Text('Quản lý tài khoản'),
              onTap: () => Navigator.pushNamed(context, '/admin/manage-accounts'),
            ),
            ListTile(
              key: const Key('admin_assign_schedule_tile'),
              leading: const Icon(Icons.schedule),
              title: const Text('Chia lịch dạy'),
              onTap: () => Navigator.pushNamed(context, '/admin/assign-schedule'),
            ),
            ListTile(
              key: const Key('admin_approve_notifications_tile'),
              leading: const Icon(Icons.check),
              title: const Text('Duyệt thông báo'),
              onTap: () => Navigator.pushNamed(context, '/admin/approve-notifications'),
            ),
          ],

          const Divider(),
          ListTile(
            key: const Key('logout_tile'),
            leading: const Icon(Icons.logout),
            title: const Text('Đăng xuất'),
            onTap: () {
              // Implement logout logic (e.g., clear session, auth state)
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
    );
  }
}