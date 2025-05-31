import 'package:flutter/material.dart';
import '../../widgets/sidebar.dart';
import '../../widgets/statcard.dart';
import '../../widgets/quick_access.dart';
import '../../services/dashboard_service.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../services/auth_service.dart';

class TeacherHomePage extends StatefulWidget {
  const TeacherHomePage({super.key});

  @override
  State<TeacherHomePage> createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
  int student = 0;
  int teacher = 0;
  int admin = 0;

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
      final adminCount = await DashboardService.fetchAdminCount();

      setState(() {
        student = studentCount;
        teacher = teacherCount;
        admin = adminCount;
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
    final userName = userProvider.name ?? 'Giáo viên';
    final userRole = userProvider.role ?? 'teacher';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang chủ Giáo viên'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: Sidebar(role: userRole),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Chào mừng, $userName!',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                StatCard(
                  title: "Học sinh", 
                  count: student.toString(), 
                  icon: Icons.school, 
                  color: Colors.blue
                ),
                StatCard(
                  title: "Giáo viên", 
                  count: teacher.toString(), 
                  icon: Icons.person, 
                  color: Colors.green
                ),
                StatCard(
                  title: "Thông báo", 
                  count: admin.toString(), 
                  icon: Icons.notifications, 
                  color: Colors.orange
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