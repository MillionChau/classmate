import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/sidebar.dart';
import '../../provider/user_provider.dart';
import '../../services/notification_service.dart';
import '../../models/notification.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';

class TeacherNotification extends StatefulWidget {
  const TeacherNotification({super.key});

  @override
  State<TeacherNotification> createState() => _TeacherNotificationState();
}

class _TeacherNotificationState extends State<TeacherNotification> {
  static final String baseUrl = kIsWeb 
      ? 'http://localhost:8080'   
      : 'http://10.0.2.2:8080'; 
  late NotificationService _notificationService;
  List<AppNotification> _notifications = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _notificationService = NotificationService(baseUrl: baseUrl);
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    try {
      final data = await _notificationService.getAllNotification();
      setState(() {
        _notifications = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  String formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy – HH:mm').format(dateTime);
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  Future<void> _addNotification(BuildContext context) async {
    final title = _titleController.text;
    final desc = _descController.text;
    if (title.isNotEmpty && desc.isNotEmpty) {
      try {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        final userId = userProvider.userId?? '';
        if (userId.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Không tìm thấy thông tin người dùng')),
          );
          return;
        }

        final newNotification = await _notificationService.sendNotification(
          title: title,
          desc: desc,
          userId: userId,
        );

        setState(() {
          _notifications.add(newNotification);
        });

        _titleController.clear();
        _descController.clear();
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi thêm thông báo: $e')),
        );
      }
    }
  }

  void _showAddNotificationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Thêm thông báo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Tiêu đề thông báo'),
              ),
              TextField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Nội dung thông báo'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                () => _addNotification(context);
                () => Navigator.pop(context);
              },
              child: const Text('Thêm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final username = userProvider.username ?? 'Người dùng';
    final role = userProvider.role ?? 'Vai trò';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gửi thông báo'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: Sidebar(role: role),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(child: Text('Lỗi: $_error'))
                : _notifications.isEmpty
                    ? const Center(child: Text('Không có thông báo nào'))
                    : ListView.builder(
                        itemCount: _notifications.length,
                        itemBuilder: (context, index) {
                          final notification = _notifications[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              leading: const Icon(Icons.campaign),
                              title: Text(notification.title),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(notification.description),
                                  Text(
                                    'Ngày tạo: ${formatDateTime(notification.createdAt)}',
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
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