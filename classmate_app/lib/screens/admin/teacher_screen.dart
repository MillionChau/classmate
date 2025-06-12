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

  void _showEditDialog(Teacher teacher) {
    final nameController = TextEditingController(text: teacher.name);
    final subjectController = TextEditingController(text: teacher.subject);
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Chỉnh sửa giáo viên"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Tên giáo viên'),
              ),
              TextField(
                controller: subjectController,
                decoration: const InputDecoration(labelText: 'Môn dạy'),
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Mật khẩu mới (nếu có)'),
                obscureText: true,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy"),
          ),
          TextButton(
            onPressed: () async {
              final updated = teacher.copyWith(
                name: nameController.text.trim(),
                subject: subjectController.text.trim(),
                password: passwordController.text.trim().isNotEmpty
                    ? passwordController.text.trim()
                    : null,
              );

              try {
                await _teacherService.updateTeacher(updated);
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cập nhật thành công')),
                  );
                  setState(() {
                    _teachersFuture = _teacherService.getAllTeachers();
                  });
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Lỗi cập nhật: $e')),
                );
              }
            },
            child: const Text("Lưu"),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(Teacher teacher) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Xác nhận xoá"),
        content: Text('Bạn có chắc muốn xoá giáo viên "${teacher.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy"),
          ),
          TextButton(
            onPressed: () async {
              try {
                await _teacherService.deleteTeacher(teacher.id);
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã xoá giáo viên')),
                  );
                  setState(() {
                    _teachersFuture = _teacherService.getAllTeachers();
                  });
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Lỗi xoá: $e')),
                );
              }
            },
            child: const Text("Xoá"),
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
            return const Center(child: Text('Không có giáo viên nào.'));
          }

          final teachers = snapshot.data!;
          return ListView.builder(
            itemCount: teachers.length,
            itemBuilder: (context, index) {
              final teacher = teachers[index];
              return ListTile(
                leading: const Icon(Icons.person),
                title: Text(teacher.name),
                subtitle: Text('ID: ${teacher.id} | Môn: ${teacher.subject}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showEditDialog(teacher),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _showDeleteDialog(teacher),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
