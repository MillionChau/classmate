import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/sidebar.dart';
import '../../provider/user_provider.dart';

class EnterMarks extends StatelessWidget {
  const EnterMarks({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final role = userProvider.role ?? 'teacher';
    final name = userProvider.username ?? 'Người dùng';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nhập điểm'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      drawer: Sidebar(role: role),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Nhập điểm',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildStudentMarkInput('Nguyễn Văn A'),
                  _buildStudentMarkInput('Trần Thị B'),
                  _buildStudentMarkInput('Lê Hoàng C'),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _saveMarks(context),
        child: const Icon(Icons.save),
      ),
    );
  }

  Widget _buildStudentMarkInput(String studentName) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(studentName, style: const TextStyle(fontSize: 16)),
          ),
          SizedBox(
            width: 100,
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 8),
                labelText: 'Điểm',
              ),
              keyboardType: TextInputType.number,
            ),
          ),
        ],
      ),
    );
  }

  void _saveMarks(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã lưu điểm thành công')),
    );
  }
}