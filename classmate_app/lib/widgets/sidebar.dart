import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final String role;

  const Sidebar({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
        children: [
          Text('Xin chào, $role',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Divider(),

          // Menu dùng chung
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Trang chủ'),
            onTap: () => Navigator.pushReplacementNamed(context, '/$role'),
          ),

          // Menu riêng theo vai trò
          if (role == 'student') ...[
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Thời khoá biểu'),
              onTap: () => Navigator.pushNamed(context, '/student/timetable'),
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Thông báo'),
              onTap: () => Navigator.pushNamed(context, '/student/notifications'),
            ),
            ListTile(
              leading: const Icon(Icons.grade),
              title: const Text('Xem điểm'),
              onTap: () => Navigator.pushNamed(context, '/student/marks'),
            ),
          ] else if (role == 'teacher') ...[
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Lịch giảng dạy'),
              onTap: () => Navigator.pushNamed(context, '/teacher/schedule'),
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Nhập điểm'),
              onTap: () => Navigator.pushNamed(context, '/teacher/enter-marks'),
            ),
            ListTile(
              leading: const Icon(Icons.send),
              title: const Text('Gửi thông báo'),
              onTap: () => Navigator.pushNamed(context, '/teacher/notification-request'),
            ),
          ] else if (role == 'admin') ...[
            ListTile(
              leading: const Icon(Icons.manage_accounts),
              title: const Text('Quản lý tài khoản'),
              onTap: () => Navigator.pushNamed(context, '/admin/manage-accounts'),
            ),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Chia lịch dạy'),
              onTap: () => Navigator.pushNamed(context, '/admin/assign-schedule'),
            ),
            ListTile(
              leading: const Icon(Icons.check),
              title: const Text('Duyệt thông báo'),
              onTap: () => Navigator.pushNamed(context, '/admin/approve-notifications'),
            ),
          ],

          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Đăng xuất'),
            onTap: () => Navigator.pushReplacementNamed(context, '/'),
          ),
        ],
      ),
    );
  }
}
