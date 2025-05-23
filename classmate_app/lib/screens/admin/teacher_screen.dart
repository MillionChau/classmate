import 'package:flutter/material.dart';

class TeacherManagementScreen extends StatelessWidget {
  const TeacherManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý giáo viên')),
      body: Column(
        children: [
          // TODO: Hiển thị danh sách giáo viên từ cơ sở dữ liệu
          Expanded(
            child: ListView.builder(
              itemCount: 10, // ví dụ tạm thời
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.person),
                  title: Text('Giáo viên ${index + 1}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // TODO: Điều hướng hoặc mở form thêm thông báo
                          // Navigator.pushNamed(context, AppRoutes.addNotification);
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Thông báo"),
                              content: const Text(
                                "Chức năng này sẽ được triển khai sau.",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Đóng"),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          // TODO: Điều hướng hoặc mở form thêm thông báo
                          // Navigator.pushNamed(context, AppRoutes.addNotification);
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Thông báo"),
                              content: const Text(
                                "Chức năng này sẽ được triển khai sau.",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Đóng"),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              // TODO: Mở form thêm giáo viên
              // Navigator.pushNamed(context, AppRoutes.addNotification);
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Thông báo"),
                  content: const Text(
                    "Chức năng này sẽ được triển khai sau.",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Đóng"),
                    ),
                  ],
                ),
              );
            },
            icon: Icon(Icons.add),
            label: Text('Thêm giáo viên'),
          ),
        ],
      ),
    );
  }
}
