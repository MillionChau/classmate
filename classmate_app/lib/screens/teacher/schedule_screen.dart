import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'schedule_screen.dart'; // import file này nè

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lịch Giảng',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ScheduleScreen(), // gọi màn hình schedule
      debugShowCheckedModeBanner: false,
    );
  }
}

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50], // Màu nền nhạt
      appBar: AppBar(
        title: const Text('Xem lịch giảng'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer(); // Nếu có Drawer
          },
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
