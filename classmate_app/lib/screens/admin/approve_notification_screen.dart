import 'package:flutter/material.dart';

class ApproveNotificationScreen extends StatelessWidget {
  const ApproveNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý thông báo'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thông báo',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildNotificationItem('Học sinh lớp 10A1 nghỉ học ngày mai'),
            _buildNotificationItem(
              'Lịch kiểm tra giữa kỳ sẽ diễn ra vào tuần tới',
            ),
            _buildNotificationItem(
              'Giáo viên vui lòng cập nhật điểm số trước ngày 20/03',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Điều hướng hoặc mở form thêm thông báo
          // Navigator.pushNamed(context, AppRoutes.addNotification);
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Thêm thông báo"),
              content: const Text("Chức năng này sẽ được triển khai sau."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Đóng"),
                ),
              ],
            ),
          );
        },
        tooltip: 'Thêm thông báo',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildNotificationItem(String content) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            const Icon(Icons.notifications),
            const SizedBox(width: 20),
            Expanded(child: Text(content, style: TextStyle(fontSize: 17))),
          ],
        ),
      ),
    );
  }
}
