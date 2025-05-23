import 'package:flutter/material.dart';

class StudentManagementScreen extends StatelessWidget {
  const StudentManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý học sinh')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 20, // ví dụ
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.school),
                  title: Text('Học sinh ${index + 1}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
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
              // TODO: Mở form thêm học sinh
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
            label: Text('Thêm học sinh'),
          ),
        ],
      ),
    );
  }
}
