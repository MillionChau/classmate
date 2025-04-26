import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5FF), // nền tím nhạt
      appBar: AppBar(
        title: const Text('Trang chủ'),
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Chào mừng, Admin!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Thống kê nhanh
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                InfoCard(
                    count: '200',
                    label: 'Học sinh',
                    icon: Icons.school,
                    color: Colors.blue),
                InfoCard(
                    count: '20',
                    label: 'Giáo viên',
                    icon: Icons.person,
                    color: Colors.green),
                InfoCard(
                    count: '5',
                    label: 'Thông báo',
                    icon: Icons.notifications,
                    color: Colors.orange),
              ],
            ),

            const SizedBox(height: 30),
            const Text(
              'Truy cập nhanh:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Truy cập nhanh
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                QuickAccessCard(label: 'Quản lý học sinh', icon: Icons.school),
                QuickAccessCard(label: 'Quản lý giáo viên', icon: Icons.group),
                QuickAccessCard(label: 'Thêm User', icon: Icons.person_add),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Thẻ thống kê
class InfoCard extends StatelessWidget {
  final String count;
  final String label;
  final IconData icon;
  final Color color;

  const InfoCard({
    super.key,
    required this.count,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        child: Column(
          children: [
            Text(
              count,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(label, style: const TextStyle(fontSize: 13)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Thẻ truy cập nhanh
class QuickAccessCard extends StatelessWidget {
  final String label;
  final IconData icon;

  const QuickAccessCard({
    super.key,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Điều hướng đến chức năng tương ứng
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: Colors.blue),
            const SizedBox(height: 12),
            Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(padding: EdgeInsets.zero, children: [
      const UserAccountsDrawerHeader(
        accountName: Text("ADMIN"),
        accountEmail: null,
        currentAccountPicture: CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(Icons.person, size: 40, color: Colors.blue),
        ),
        decoration: BoxDecoration(color: Colors.blue),
      ),
      _buildDrawerItem(Icons.home, "Trang chủ", context),
      _buildDrawerItem(Icons.school, "Quản lý học sinh", context),
      _buildDrawerItem(Icons.group, "Quản lý giáo viên", context),
      _buildDrawerItem(Icons.person_add, "Thêm User", context),
      _buildDrawerItem(Icons.calendar_today, "Sắp xếp lịch học", context),
      _buildDrawerItem(Icons.notifications, "Quản lý thông báo", context),
      const Divider(),
      _buildDrawerItem(Icons.logout, "Đăng xuất", context),
    ]));
  }
}

ListTile _buildDrawerItem(IconData icon, String title, BuildContext context) {
  return ListTile(
    leading: Icon(icon),
    title: Text(title),
    onTap: () {
      Navigator.pop(context);
    },
  );
}
