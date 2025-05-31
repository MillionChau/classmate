import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/sidebar.dart';
import '../../provider/user_provider.dart';
import '../../services/notification_service.dart';
import '../../models/notification.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';


class ApproveNotificationScreen extends StatefulWidget {
  const ApproveNotificationScreen({super.key});

  @override
  State<ApproveNotificationScreen> createState() => _ApproveNotificationScreenState();
}

class _ApproveNotificationScreenState extends State<ApproveNotificationScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý thông báo'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
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
        onPressed: () {
          // TODO: Điều hướng hoặc mở form thêm thông báo
          // Navigator.pushNamed(context, AppRoutes.addNotification);
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Thêm thông báo"),
              content: const Text("Chức năng này sẽ được triển khai sau."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Đóng"),
                ),
              ],
            ),
          );
        },
        tooltip: 'Thêm thông báo',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildNotificationItem(String content) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            const Icon(Icons.notifications),
            const SizedBox(width: 20),
            Expanded(child: Text(content, style: TextStyle(fontSize: 17))),
          ],
        ),
      ),
    );
  }
}
