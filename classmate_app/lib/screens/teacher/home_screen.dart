import 'package:flutter/material.dart';
import '../../widgets/sidebar.dart';
import '../../widgets/statcard.dart';
import '../../widgets/quick_access.dart';
import '../../services/dashboard_service.dart';
<<<<<<< HEAD
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../services/auth_service.dart';
=======
import '../../provider/user_provider.dart';
import 'package:provider/provider.dart';
>>>>>>> 8bd2927b1d48cdb2771c0909822b43e2f65919d4

class TeacherHomePage extends StatefulWidget {
  const TeacherHomePage({super.key});

  @override
  State<TeacherHomePage> createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
  int student = 0;
  int teacher = 0;
<<<<<<< HEAD
  int admin = 0;

=======
  int notification = 0;
>>>>>>> 8bd2927b1d48cdb2771c0909822b43e2f65919d4
  @override
  void initState() {
    super.initState();
    loadStats();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _verifyUserData(); // sẽ gọi loadUserData nếu cần
    });
  }


  void _verifyUserData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    await userProvider.loadUserData();
    
    if (userProvider.name == null || userProvider.role == null) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }


  Future<void> loadUserData() async {
    try {
      final userData = await AuthService.getCurrentUser();
      if (userData != null && mounted) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(userData['name'], userData['role']);
      }
    } catch (e) {
      print("Lỗi khi load thông tin user: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi tải thông tin người dùng: ${e.toString()}')),
        );
      }
    }
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi tải dữ liệu: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
<<<<<<< HEAD
    final userName = userProvider.name ?? 'Giáo viên';
    final userRole = userProvider.role ?? 'teacher';
=======
    final username = userProvider.username ?? 'Người dùng';
    final role = userProvider.role ?? 'Vai trò';
>>>>>>> 8bd2927b1d48cdb2771c0909822b43e2f65919d4

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang chủ Giáo viên'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
<<<<<<< HEAD
      drawer: Sidebar(role: userRole),
=======
      drawer: Sidebar(role: role),
>>>>>>> 8bd2927b1d48cdb2771c0909822b43e2f65919d4
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
<<<<<<< HEAD
            Text('Chào mừng, $userName!',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
=======
            Text(
              'Chào mừng, $username!',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
>>>>>>> 8bd2927b1d48cdb2771c0909822b43e2f65919d4
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
<<<<<<< HEAD
                    icon: Icons.calendar_today,
                    onTap: () => Navigator.pushNamed(context, '/teacher/timetable'),
                  ),
                  QuickAccessCard(
                    title: 'Nhập điểm',
                    icon: Icons.star,
                    onTap: () => Navigator.pushNamed(context, '/teacher/marks'),
                  ),
                  QuickAccessCard(
                    title: 'Gửi thông báo',
                    icon: Icons.notifications_active,
                    onTap: () => Navigator.pushNamed(context, '/teacher/notifications'),
=======
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
>>>>>>> 8bd2927b1d48cdb2771c0909822b43e2f65919d4
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