import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/sidebar.dart';
import '../../provider/user_provider.dart';

class TeacherScheduleScreen extends StatelessWidget {
  const TeacherScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final username = userProvider.username ?? 'Người dùng';
    final role = userProvider.role ?? 'Vai trò';

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text('Xem lịch giảng'),
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
              'Thời khóa biểu',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Các thẻ ngày học
            _buildDayCard('Thứ Hai: Toán - Văn - Anh'),
            _buildDayCard('Thứ Ba: Lý - Hóa - Sinh'),
            _buildDayCard('Thứ Tư: Sử - Địa - GDCD'),
            _buildDayCard('Thứ Năm: Công nghệ - Tin học'),
            _buildDayCard('Thứ Sáu: Thể dục - Âm nhạc'),
          ],
        ),
      ),
    );
  }

  Widget _buildDayCard(String text) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(text),
      ),
    );
  }
}
