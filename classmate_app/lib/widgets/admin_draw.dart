import '../screens/admin/student_screen.dart';
import '../screens/admin/teacher_screen.dart';
import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            color: Colors.blue,
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Column(
              children: const [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: Colors.blue),
                ),
                SizedBox(height: 10),
                Text(
                  "ADMIN",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Menu Items
          _buildDrawerItem(
            icon: Icons.home,
            label: 'Trang chủ',
            onTap: () => Navigator.pushNamed(context, AppRoutes.adminDashboard),
          ),
          _buildDrawerItem(
            icon: Icons.child_care,
            label: 'Quản lý học sinh',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const StudentManagementScreen(),
                ),
              );
            }, // Thêm route khi có
          ),
          _buildDrawerItem(
            icon: Icons.people,
            label: 'Quản lý giáo viên',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TeacherManagementScreen(),
                ),
              );
            }, // Thêm route khi có
          ),
          _buildDrawerItem(
            icon: Icons.person_add,
            label: 'Thêm User',
            onTap: () => Navigator.pushNamed(context, AppRoutes.adminAccount),
          ),
          _buildDrawerItem(
            icon: Icons.schedule,
            label: 'Sắp xếp lịch học',
            onTap: () => Navigator.pushNamed(context, AppRoutes.adminSchedule),
          ),
          _buildDrawerItem(
            icon: Icons.notifications,
            label: 'Quản lý thông báo',
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.adminNotification),
          ),
          const Spacer(),
          const Divider(),
          _buildDrawerItem(
            icon: Icons.logout,
            label: 'Đăng xuất',
            onTap: () => Navigator.pushReplacementNamed(context, '/'),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(label),
      onTap: onTap,
    );
  }
}
