import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:uuid/uuid.dart';

import '../services/mongo_service.dart';
import '../models/admin.dart';

class AdminController {
  static Future<Response> addAdmin(Request req) async {
    try {
      final payload = await req.readAsString();
      final data = jsonDecode(payload);

      final name = data['name']?.toString();
      final position = data['position']?.toString();
      final password = data['password']?.toString();

      if(name == null || position == null || password == null) {
        return Response.badRequest(
          body: jsonEncode({'message:': 'Thiếu thông tin admin'})
        );
      }

      final collection = MongoService.db.collection('users');
      
      final admin = Admin(
        id: Uuid().v4(),
        name: name,
        position: position,
        password: password,
      );

      await collection.insert(admin.toMap());

      return Response.ok(
        jsonEncode({
        'message': 'Thêm admin thành công',
        'id': admin.id,
      }));
    } catch(e, stack) {
      print('Lỗi khi thêm admin: $e\n$stack');
      return Response.internalServerError(
        body: jsonEncode({'message': 'Lỗi khi server thêm admin', 'details': e.toString()})
      );
    }
  }

  static Future<Response> getAdmin(Request req) async {
    try {
      final collection = MongoService.db.collection('users');
      final Admins = await collection.find({'role': 'admin'}).toList();

      return Response.ok(jsonEncode(Admins));
    } catch(e, stack) {
      print('Lỗi khi lấy danh sách admin: $e\n$stack');

      return Response.internalServerError(
        body: jsonEncode({'message': 'Lỗi khi lấy danh sách admin'})
      );
    }
  }

  static Future<Response> updateAdmin(Request req, String id) async {
    try {
      final payload = await req.readAsString();
      final data = jsonDecode(payload);

      final name = data['name']?.toString();
      final position = data['position']?.toString();
      final password = data['password']?.toString();

      if (name == null || position == null || password == null) {
        return Response.badRequest(body: jsonEncode({'message': 'Thiếu dữ liệu'}));
      }

      final collection = MongoService.db.collection('users');

      final existingAdmin = await collection.findOne({'id': id, 'role': 'admin'});

      if (existingAdmin == null) {
        return Response.notFound(jsonEncode({'message': 'Không tìm thấy admin'}));
      }

      final updateData = <String, dynamic>{};

      if (name.isNotEmpty) updateData['name'] = name;
      if (position.isNotEmpty) updateData['position'] = position;
      if (password.isNotEmpty) updateData['password'] = password;

      await collection.update(
        {'id': id},
        {r'$set': updateData},
      );

      return Response.ok(jsonEncode({'message': 'Cập nhật admin thành công'}));
    } catch (e, stack) {
      print('Lỗi khi cập nhật admin: $e\n$stack');
      return Response.internalServerError(
        body: jsonEncode({'message': 'Lỗi server khi cập nhật admin'}),
      );
    }
  }

  static Future<Response> deleteAdmin(Request req, String id) async {
    try {
      final collection = MongoService.db.collection('users');

      final Admin = await collection.findOne({
        'id': id,
        'role': 'admin',
      });

      if (Admin == null) {
        return Response.notFound(
          jsonEncode({'message': 'Không tìm thấy admin'}),
        );
      }

      await collection.deleteOne({'id': id});

      return Response.ok(jsonEncode({'message': 'Xoá admin thành công'}));
    } catch (e, stack) {
      print('Lỗi khi xoá admin: $e\n$stack');
      return Response.internalServerError(
        body: jsonEncode({'message': 'Lỗi server khi xoá admin'}),
      );
    }
  }

  static Future<Response> getAdminCount(Request req) async {
    try {
      final collection = MongoService.db.collection('users');
      final count = await collection.count({'role': 'admin'});

      return Response.ok(jsonEncode({'count': count}));
    } catch (e, stack) {
      print('Lỗi khi lấy số lượng admin: $e\n$stack');
      return Response.internalServerError(
        body: jsonEncode({'message': 'Lỗi server khi lấy số lượng admin'}),
      );
    }
  }
}