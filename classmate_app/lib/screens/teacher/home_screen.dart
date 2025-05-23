import 'package:flutter/material.dart';
import '../../widgets/sidebar.dart';
import '../../widgets/statcard.dart';
import '../../widgets/quick_access.dart';
import '../../services/dashboard_service.dart';
import '../../provider/user_provider.dart';
import 'package:provider/provider.dart';

class TeacherHomePage extends StatefulWidget {
  const TeacherHomePage({super.key});

  @override
  State<TeacherHomePage> createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
  int student = 0;
  int teacher = 0;
  int notification = 0;
  @override
  void initState() {
    super.initState();
    loadStats();
  }

  Future<void> loadStats() async {
    try {
      final studentCount = await DashboardService.fetchStudentCount();
      final teacherCount = await DashboardService.fetchTeacherCount();
      final notificationCount = await DashboardService.fetchNotificationsCount();

      setState(() {
        student = studentCount;
        teacher = teacherCount;
        notification = notificationCount;
      });
    } catch(e) {
      print("Lỗi khi load số liệu: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi tải dữ liệu: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final username = userProvider.username ?? 'Người dùng';
    final role = userProvider.role ?? 'Vai trò';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang chủ'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: Sidebar(role: role),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chào mừng, $username!',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                StatCard(
                  title: "Học sinh",
                  count: student.toString(),
                  icon: Icons.school,
                  color: Colors.blue,
                ),
                StatCard(
                  title: "Giáo viên",
                  count: teacher.toString(),
                  icon: Icons.person,
                  color: Colors.green,
                ),
                StatCard(
                  title: "Thông báo",
                  count: notification.toString(),
                  icon: Icons.notifications,
                  color: Colors.orange,
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Truy cập nhanh:', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  QuickAccessCard(
                    title: 'Xem lịch giảng',
                    icon: Icons.access_alarm,
                    onTap: () => Navigator.pushNamed(context, '/teacher/schedule'),
                  ),
                  QuickAccessCard(
                    title: 'Nhập điểm',
                    icon: Icons.edit,
                    onTap: () => Navigator.pushNamed(context, '/teacher/enter-marks'),
                  ),
                  QuickAccessCard(
                    title: 'Gửi thông báo',
                    icon: Icons.notifications,
                    onTap: () => Navigator.pushNamed(context, '/teacher/notification-request'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}