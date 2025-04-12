import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:uuid/uuid.dart';

import '../services/mongo_service.dart';
import '../models/teacher.dart';

class StudentController {
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

      return Response.ok({
        'message': 'Thêm giáo viên thành công',
        'id': teacher.id,
      });
    } catch(e, stack) {
      print('❌ Lỗi khi thêm giáo viên: $e\n$stack');
      return Response.internalServerError(
        body: jsonEncode({'message': 'Lỗi khi server thêm giáo viên'})
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

}