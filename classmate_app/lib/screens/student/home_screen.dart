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

<<<<<<< HEAD
  Widget _buildStatCard(
      String title, String count, IconData icon, Color color) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(count,
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
=======
  @override
  void initState() {
    super.initState();
    loadStats();
>>>>>>> 814d39281f518b60938b35860c6a3d789cfae7a9
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
      print("❌ Lỗi khi load số liệu: $e");
      // Có thể thêm SnackBar để hiển thị lỗi cho người dùng
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
                    title: 'Xem TKB',
                    icon: Icons.calendar_today,
                    onTap: () => Navigator.pushNamed(context, '/student/timetable'),
                  ),
                  QuickAccessCard(
                    title: 'Xem điểm',
                    icon: Icons.star,
                    onTap: () => Navigator.pushNamed(context, '/student/marks'),
                  ),
                  QuickAccessCard(
                    title: 'Thông báo',
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