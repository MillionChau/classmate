import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../services/mongo_service.dart';
import '../models/admin.dart';
import '../models/student.dart';
import '../models/teacher.dart';

class AuthController {
  static Future<Response> login(Request req) async {
    try {
      final payload = await req.readAsString();
      final data = jsonDecode(payload);

      final input = data['username'];
      final password = data['password'];

      if (input == null || password == null) {
        return Response.badRequest(
          body: jsonEncode({'message': 'Thiếu username hoặc password'}),
        );
      }

      final collection = MongoService.db.collection('users');

      // Tìm theo username hoặc name + password
      final user = await collection.findOne({
        r'$or': [
          {'username': input},
          {'name': input},
        ],
        'password': password,
      });

      if (user == null) {
        return Response.forbidden(
          jsonEncode({'message': 'Tài khoản hoặc mật khẩu sai'}),
        );
      }

      switch (user['role']) {
        case 'admin':
          return buildAdminResponse(user);
        case 'teacher':
          return buildTeacherResponse(user);
        case 'student':
          return buildStudentResponse(user);
        default:
          return Response.forbidden(
            jsonEncode({'message': 'Vai trò không hợp lệ'}),
          );
      }
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'message': 'Lỗi server: ${e.toString()}'}),
      );
    }
  }

  static Response buildAdminResponse(Map<String, dynamic> user) {
    final admin = Admin.fromMap(user);
    return Response.ok(jsonEncode({
      'message': 'Đăng nhập admin thành công',
      'user': {
        'id': admin.id,
        'name': admin.name,
        'position': admin.position,
        'role': 'admin',
        'permissions': ['manage_users', 'manage_system', 'view_all_data'],
      },
      'access_token': generateToken(admin.id, 'admin'),
    }));
  }

  static Response buildTeacherResponse(Map<String, dynamic> user) {
    final teacher = Teacher.fromMap(user);
    return Response.ok(jsonEncode({
      'message': 'Đăng nhập giáo viên thành công',
      'user': {
        'id': teacher.id,
        'name': teacher.name,
        'subject': teacher.subject,
        'role': 'teacher',
        'permissions': ['manage_classes', 'post_grades', 'view_students'],
      },
      'access_token': generateToken(teacher.id, 'teacher'),
    }));
  }

  static Response buildStudentResponse(Map<String, dynamic> user) {
    final student = Student.fromMap(user);
    return Response.ok(jsonEncode({
      'message': 'Đăng nhập học sinh thành công',
      'user': {
        'id': student.id,
        'name': student.name,
        'className': student.className,
        'role': 'student',
        'permissions': ['view_grades', 'view_schedule', 'submit_assignments'],
      },
      'access_token': generateToken(student.id, 'student'),
    }));
  }

  static String generateToken(String userId, String role) {
    return base64Encode(
      utf8.encode('$userId|$role|${DateTime.now().toIso8601String()}'),
    );
  }
}
