import 'dart:convert';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:uuid/uuid.dart';

import '../services/mongo_service.dart';
import '../models/teacher.dart';

class TeacherController {
  static Future<Response> addTeacher(Request req) async {
    try {
      final payload = await req.readAsString();
      final data = jsonDecode(payload);

      final name = data['name']?.toString();
      final subject = data['subject']?.toString();
      final password = data['password']?.toString();

      if(name == null || subject == null || password == null) {
        return Response.badRequest(
          body: jsonEncode({'message:': 'Thiếu thông tin giáo viên'})
        );
      }

      final collection = MongoService.db.collection('users');
      
      final teacher = Teacher(
        id: Uuid().v4(),
        name: name,
        subject: subject,
        password: password,
      );

      await collection.insert(teacher.toMap());

      return Response.ok(
        jsonEncode({
        'message': 'Thêm giáo viên thành công',
        'id': teacher.id,
      }));
    } catch(e, stack) {
      print('❌ Lỗi khi thêm giáo viên: $e\n$stack');
      return Response.internalServerError(
        body: jsonEncode({'message': 'Lỗi khi server thêm giáo viên', 'details': e.toString()})
      );
    }
  }

  static Future<Response> getTeacher(Request req) async {
    try {
      final collection = MongoService.db.collection('users');
      final teachers = await collection.find({'role': 'teacher'}).toList();

      return Response.ok(jsonEncode(teachers));
    } catch(e, stack) {
      print('❌ Lỗi khi lấy danh sách giáo viên: $e\n$stack');

      return Response.internalServerError(
        body: jsonEncode({'message': 'Lỗi khi lấy danh sách giáo viên'})
      );
    }
  }

  static Future<Response> updateTeacher(Request req, String id) async {
    try {
      final payload = await req.readAsString();
      final data = jsonDecode(payload);

      final name = data['name']?.toString();
      final subject = data['subject']?.toString();
      final password = data['password']?.toString();

      if (id == null || name == null || subject == null || password == null) {
        return Response.badRequest(body: jsonEncode({'message': 'Thiếu dữ liệu'}));
      }

      final collection = MongoService.db.collection('users');

      final existingTeacher = await collection.findOne({'id': id, 'role': 'teacher'});

      if (existingTeacher == null) {
        return Response.notFound(jsonEncode({'message': 'Không tìm thấy giáo viên'}));
      }

      final updateData = <String, dynamic>{};

      if (name.isNotEmpty) updateData['name'] = name;
      if (subject.isNotEmpty) updateData['subject'] = subject;
      if (password.isNotEmpty) updateData['password'] = password;

      await collection.update(
        {'id': id},
        {r'$set': updateData},
      );

      return Response.ok(jsonEncode({'message': 'Cập nhật giáo viên thành công'}));
    } catch (e, stack) {
      print('❌ Lỗi khi cập nhật giáo viên: $e\n$stack');
      return Response.internalServerError(
        body: jsonEncode({'message': 'Lỗi server khi cập nhật giáo viên'}),
      );
    }
  }

  static Future<Response> deleteTeacher(Request req, String id) async {
    try {
      final collection = MongoService.db.collection('users');

      final teacher = await collection.findOne({
        'id': id,
        'role': 'teacher',
      });

      if (teacher == null) {
        return Response.notFound(
          jsonEncode({'message': 'Không tìm thấy giáo viên'}),
        );
      }

      await collection.deleteOne({'id': id});

      return Response.ok(jsonEncode({'message': 'Xoá giáo viên thành công'}));
    } catch (e, stack) {
      print('❌ Lỗi khi xoá giáo viên: $e\n$stack');
      return Response.internalServerError(
        body: jsonEncode({'message': 'Lỗi server khi xoá giáo viên'}),
      );
    }
  }

  static Future<Response> getTeacherCount(Request req) async {
    try {
      final collection = MongoService.db.collection('users');
      final count = await collection.count({'role': 'teacher'});

      return Response.ok(jsonEncode({'count': count}));
    } catch (e, stack) {
      print('❌ Lỗi khi lấy số lượng giáo viên: $e\n$stack');
      return Response.internalServerError(
        body: jsonEncode({'message': 'Lỗi server khi lấy số lượng giáo viên'}),
      );
    }
  }
}