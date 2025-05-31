import 'package:flutter/material.dart';
import '../../services/user_service.dart';
import '../../models/teacher.dart';

class TeacherManagementScreen extends StatefulWidget {
  const TeacherManagementScreen({super.key});

  @override
  State<TeacherManagementScreen> createState() => _TeacherManagementScreenState();
}

class _TeacherManagementScreenState extends State<TeacherManagementScreen> {
  final TeacherService _teacherService = TeacherService();
  late Future<List<Teacher>> _teachersFuture;

  @override
  void initState() {
    super.initState();
    _teachersFuture = _teacherService.getAllTeachers();
  }

  void _showNotImplementedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Thông báo"),
        content: const Text("Chức năng này sẽ được triển khai sau."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Đóng"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý giáo viên')),
      body: FutureBuilder<List<Teacher>>(
        future: _teachersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Không có học sinh nào.'));
          }

          final students = snapshot.data!;
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final student = students[index];
                    return ListTile(
                      leading: const Icon(Icons.school),
                      title: Text(student.name ?? 'Không tên'),
                      subtitle: Text('ID: ${student.id ?? "?"}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: _showNotImplementedDialog,
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: _showNotImplementedDialog,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
