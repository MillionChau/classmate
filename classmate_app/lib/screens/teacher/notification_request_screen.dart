import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trang chủ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TeacherNotification(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TeacherNotification extends StatefulWidget {
  const TeacherNotification({super.key});

  @override
  State<TeacherNotification> createState() => _TeacherNotificationState();
}

class _TeacherNotificationState extends State<TeacherNotification> {
  final List<String> notifications = [
    'Học sinh lớp 10A1 nghỉ học ngày mai!',
    'Lịch kiểm tra giữa kỳ sẽ diễn ra vào tuần tới.',
    'Giáo viên vui lòng cập nhật điểm sớm trước ngày 20/03.'
  ];

  final TextEditingController _controller = TextEditingController();

  void _addNotification(String text) {
    if (text.isNotEmpty) {
      setState(() {
        notifications.add(text);
      });
      _controller.clear();
      Navigator.of(context).pop();
    }
  }

  void _showAddNotificationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Thêm thông báo'),
          content: TextField(
            controller: _controller,
            decoration: const InputDecoration(labelText: 'Nội dung thông báo'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () => _addNotification(_controller.text),
              child: const Text('Thêm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gửi thông báo'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const Icon(Icons.campaign),
                title: Text(notifications[index]),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddNotificationDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
