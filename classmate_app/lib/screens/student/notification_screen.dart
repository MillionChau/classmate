import 'package:flutter/material.dart';
import '../../services/notification_service.dart';
import '../../models/notification.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';

class ThongBaoScreen extends StatefulWidget {
  const ThongBaoScreen({super.key});

  @override
  _ThongBaoScreenState createState() => _ThongBaoScreenState();
}

class _ThongBaoScreenState extends State<ThongBaoScreen> {
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
        title: const Text('Xem thông báo'),
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
    );
  }
}
