import 'dart:convert';
import 'package:backend/models/notification.dart';
import 'package:shelf/shelf.dart';
import '../services/mongo_service.dart';

class NotificationController {
 static Future<Response> sendNotification(Request req) async {
    try {
      final payload = await req.readAsString();
      final data = jsonDecode(payload);

      final title = data['title']?.toString();
      final description = data['description']?.toString();
      final createdBy = data['createdBy']?.toString();

      if (title == null || description == null || createdBy == null) {
        return Response.badRequest(
          body: jsonEncode({'message': 'Thiếu thông tin thông báo'}),
        );
      }

      final collection = MongoService.db.collection('notifications');

      final now = DateTime.now();
      final year = now.year.toString().substring(2);
      final prefix = 'TB$year';

      final count = await collection.count({
        'id': {'\$regex': '^$prefix'}
      });

      final id = '$prefix-${(count + 1).toString().padLeft(3, '0')}';

      final notification = Notification(
        id: id,
        title: title,
        description: description,
        createdBy: createdBy,
        status: 'pending',
        createdAt: now,
      );

      await collection.insertOne(notification.toMap());

      return Response.ok(jsonEncode({
        'message': 'Gửi thông báo thành công!',
        'notification': notification.toMap()
      }));
    } catch (e, stack) {
      print('Lỗi khi gửi thông báo: $e\n$stack');
      return Response.internalServerError(
        body: jsonEncode({'message': 'Lỗi server khi gửi thông báo'}),
      );
    }
  }

  static Future<Response> getAllNotifications(Request req) async {
    try {
      final collection = MongoService.db.collection('notifications');

      final approvedNotifications = await collection
          .find({'status': 'approved'})
          .toList();

      return Response.ok(jsonEncode(approvedNotifications));
    } catch (e, stack) {
      print('Lỗi khi lấy thông báo: $e\n$stack');
      return Response.internalServerError(
        body: jsonEncode({'message': 'Lỗi server khi lấy thông báo'}),
      );
    }
  }

  static Future<Response> getNotificationPending(Request req) async {
    try {
      final collection = MongoService.db.collection('notifications');

      final pendingNotifications = await collection
          .find({'status': 'pending'})
          .toList();

      return Response.ok(jsonEncode(pendingNotifications));
    } catch (e, stack) {
      print('Lỗi khi lấy thông báo: $e\n$stack');
      return Response.internalServerError(
        body: jsonEncode({'message': 'Lỗi server khi lấy thông báo'}),
      );
    }
  }
  static Future<Response> approveNotification(Request req, String id) async {
    try {
      final collection = MongoService.db.collection('notifications');

      final notification = await collection.findOne({'id': id});

      if (notification == null) {
        return Response.notFound(
          jsonEncode({'message': 'Không tìm thấy thông báo'}),
        );
      }

      if (notification['status'] == 'approved') {
        return Response.badRequest(
          body: jsonEncode({'message': 'Thông báo đã được duyệt rồi'}),
        );
      }

      await collection.update({'id': id}, {
        r'$set': {'status': 'approved'}
      });

      return Response.ok(jsonEncode({'message': 'Duyệt thông báo thành công'}));
    } catch (e, stack) {
      print('Lỗi khi duyệt thông báo: $e\n$stack');
      return Response.internalServerError(
        body: jsonEncode({'message': 'Lỗi server khi duyệt thông báo'}),
      );
    }
  }

  static Future<Response> removedNotification(Request req, String id) async {
    try {
      final collection = MongoService.db.collection('notifications');

      final notification = await collection.findOne({'id': id}); // ❗ await ở đây!

      if (notification == null) {
        return Response.notFound(
          jsonEncode({'message': 'Không tìm thấy thông báo!'}),
        );
      }

      await collection.deleteOne({'id': id});

      return Response.ok(jsonEncode({'message': 'Xoá thông báo thành công'}));
    } catch (e, stack) {
      print('Lỗi khi xoá thông báo: $e\n$stack');
      return Response.internalServerError(
        body: jsonEncode({'message': 'Lỗi server khi xoá thông báo'}),
      );
    }
  }

  static Future<Response> getAllNotificationCount(Request req) async {
    try {
      final collection = await MongoService.db.collection('notifications');
      final count = await collection.count({'status': 'approved'});

      return Response.ok(jsonEncode({'count': count}));
    } catch (e, stack) {
      print('Lỗi khi lấy số lượng giáo viên: $e\n$stack');
      return Response.internalServerError(
        body: jsonEncode({'message': 'Lỗi server khi lấy số lượng giáo viên'}),
      );
    }
  }
}
