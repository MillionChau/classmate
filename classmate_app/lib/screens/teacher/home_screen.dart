import 'package:flutter/material.dart';
import '../../widgets/sidebar.dart';
import '../../widgets/statcard.dart';
import '../../widgets/quick_access.dart';
import '../../services/dashboard_service.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({super.key});

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  int student = 0;
  int teacher = 0;
  int admin = 0;
  @override
  void initState() {
    super.initState();
    loadStats();
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi tải dữ liệu: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang chủ'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: const Sidebar(role: 'student'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Chào mừng, Học sinh!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                    onTap: () => Navigator.pushNamed(context, '/student/timetable'),
                  ),
                  QuickAccessCard(
                    title: 'Nhập điểm',
                    icon: Icons.star,
                    onTap: () => Navigator.pushNamed(context, '/student/marks'),
                  ),
                  QuickAccessCard(
                    title: 'Gửi thông báo',
                    icon: Icons.notifications_active,
                    onTap: () => Navigator.pushNamed(context, '/student/notifications'),
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