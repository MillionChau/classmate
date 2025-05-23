import '../admin/approve_notification_screen.dart';
import '../admin/manage_accouts_screen.dart';
import '../admin/student_screen.dart';
import '../admin/teacher_screen.dart';
import 'package:flutter/material.dart';
import '../../widgets/admin_draw.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: const AdminDrawer(),
      appBar: AppBar(
        title: const Text("Trang chủ"),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Chào mừng, Admin!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Thẻ thống kê
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const StudentManagementScreen(),
                      ),
                    );
                  },
                  child: _buildStatCard(
                    count: 20,
                    label: 'Học sinh',
                    icon: Icons.school,
                    color: Colors.blue,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TeacherManagementScreen(),
                      ),
                    );
                  },
                  child: _buildStatCard(
                    count: 10,
                    label: 'Giáo viên',
                    icon: Icons.people,
                    color: const Color.fromARGB(255, 102, 220, 161),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ApproveNotificationScreen(),
                      ),
                    );
                  },
                  child: _buildStatCard(
                    count: 5,
                    label: 'Thông báo',
                    icon: Icons.notifications,
                    color: const Color.fromARGB(255, 228, 178, 90),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),
            const Divider(thickness: 1),
            const SizedBox(height: 20),

            const Text(
              'Truy cập nhanh:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            // Tự co giãn chiều cao của GridView
            GridView.count(
              crossAxisCount: screenWidth > 600 ? 3 : 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildDashboardCard(
                  context,
                  icon: Icons.people,
                  label: "Quản lý giáo viên",
                  color: Colors.green,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TeacherManagementScreen(),
                      ),
                    );
                  },
                ),
                _buildDashboardCard(
                  context,
                  icon: Icons.child_care,
                  label: "Quản lý học sinh",
                  color: Colors.blue,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const StudentManagementScreen(),
                      ),
                    );
                  },
                ),
                _buildDashboardCard(
                  context,
                  icon: Icons.person_add,
                  label: "Thêm User",
                  color: Colors.purple,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ManageAccountsScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required int count,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return SizedBox(
      width: 110,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // căn giữa theo chiều dọc
            crossAxisAlignment:
                CrossAxisAlignment.center, // căn giữa theo chiều ngang
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(height: 6),
              Text(
                '($count)$label',
                style: const TextStyle(fontSize: 14, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    String? value,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 10),
              if (value != null)
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              Text(label, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
