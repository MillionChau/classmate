import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';

import '../../services/notification_service.dart';
import '../../models/notification.dart';

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
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final approved = await _notificationService.getAllNotification();
      final pending = await _notificationService.getAllPendingNotification();

      final combined = [...pending, ...approved];

      setState(() {
        _notifications = combined;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _approveNotification(AppNotification noti) async {
    try {
      if (noti.status != 'approved') {
        final updated = await _notificationService.submitNotification(noti.id);
        setState(() {
          final index = _notifications.indexWhere((n) => n.id == noti.id);
          if (index != -1) {
            _notifications[index] = updated;
            _notifications = List.from(_notifications); // Force rebuild
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Phê duyệt thành công')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Thông báo đã được duyệt')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi phê duyệt: $e')),
      );
    }
  }

  Future<void> _deleteNotification(AppNotification noti) async {
    try {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Xác nhận xoá'),
          content: Text('Bạn có chắc muốn xoá thông báo "${noti.title}" không?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Xoá'),
            ),
          ],
        ),
      );

      if (confirm == true) {
        final success = await _notificationService.deleteNotification(noti.id);
        if (success) {
          setState(() {
            _notifications.removeWhere((n) => n.id == noti.id);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã xoá thông báo')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi xoá: $e')),
      );
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
                          final noti = _notifications[index];
                          final isApproved = noti.status == 'approved';

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            color: isApproved ? Colors.green.shade50 : Colors.orange.shade50,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              leading: Icon(
                                isApproved ? Icons.verified : Icons.pending_actions,
                                color: isApproved ? Colors.green : Colors.orange,
                              ),
                              title: Text(noti.title),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(noti.description),
                                  Text(
                                    'Tạo bởi: ${noti.createdBy}',
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                  Text(
                                    'Ngày tạo: ${formatDateTime(noti.createdAt)}',
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                              trailing: Wrap(
                                spacing: 8,
                                children: [
                                  Switch(
                                    value: isApproved,
                                    onChanged: (_) => _approveNotification(noti),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _deleteNotification(noti),
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
