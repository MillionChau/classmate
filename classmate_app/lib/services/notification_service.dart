import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/notification.dart'; // Import model Notification

class NotificationService {
  final String baseUrl;

  NotificationService({required this.baseUrl});

  // Gửi thông báo mới
 Future<AppNotification> sendNotification({
    required String title,
    required String desc,
    required String userId,
    String status = 'pending',
  }) async {
    try {
      final newNotification = AppNotification(
        id: '',
        title: title,
        description: desc,
        createdBy: userId,
        status: status,
        createdAt: DateTime.now(),
      );

      final response = await http.post(
        Uri.parse('$baseUrl/notification/add'),
        headers: {
          'Content-Type': 'application/json'
        },
        body: jsonEncode(newNotification.toMap()),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['notification'] == null) {
          throw Exception('Phản hồi không chứa thông báo');
        }
        return AppNotification.fromMap(responseData['notification']);
      } else {
        throw Exception('Gửi thông báo thất bại: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Lỗi khi gửi thông báo: $e');
    }
  }

  // Lấy tất cả thông báo
  Future<List<AppNotification>> getAllNotification() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/notification/read'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => AppNotification.fromMap(item)).toList();
      } else {
        throw Exception('Lấy thông báo thất bại: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi khi lấy thông báo: $e');
    }
  }

  // Phê duyệt thông báo
  Future<AppNotification> submitNotification(String id) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/notification/approve/$id'),
      );

      if (response.statusCode == 200) {
        return AppNotification.fromMap(jsonDecode(response.body));
      } else {
        throw Exception('Phê duyệt thông báo thất bại: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi khi phê duyệt thông báo: $e');
    }
  }

  // Xóa thông báo
  Future<bool> deleteNotification(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/notification/delete/$id'),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Xóa thông báo thất bại: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi khi xóa thông báo: $e');
    }
  }
}