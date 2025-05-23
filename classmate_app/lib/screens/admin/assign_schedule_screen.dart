import 'package:flutter/material.dart';

class AssignScheduleScreen extends StatelessWidget {
  const AssignScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sắp xếp lịch học'),
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
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildScheduleItem('Thứ Hai', 'Toán - Văn - Anh'),
            _buildScheduleItem('Thứ Ba', 'Lý - Hóa - Sinh'),
            _buildScheduleItem('Thứ Tư', 'Sử - Địa - GDCD'),
            _buildScheduleItem('Thứ Năm', 'Công nghệ - Tin học'),
            _buildScheduleItem('Thứ Sáu', 'Thể dục - Âm nhạc'),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleItem(String day, String subjects) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(day, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(subjects),
          ],
        ),
      ),
    );
  }
}
