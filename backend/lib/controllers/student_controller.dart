import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../services/mongo_service.dart';
import '../models/student.dart';

class StudentController {
  static Future<Response> addStudent(Request req) async {
  try {
    final payload = await req.readAsString();
    final data = jsonDecode(payload);

    final name = data['name']?.toString();
    final className = data['class']?.toString();
    final password = data['password']?.toString();

    if (name == null || className == null || password == null) {
      return Response.badRequest(
        body: jsonEncode({'message': 'Thiếu thông tin học sinh'}),
      );
    }

    final collection = MongoService.db.collection('users');

    final now = DateTime.now();
    final year = now.year.toString().substring(2);

    final prefix = 'HS$year';
    final count = await collection.count({
      'role': 'student',
      'id': {r'$regex': '^$prefix'}
    });

    final newId = '$prefix-${(count + 1).toString().padLeft(3, '0')}';

    final student = Student(
      id: newId,
      name: name,
      className: className,
      password: password,
    );

    await collection.insert(student.toMap());

    return Response.ok(jsonEncode({
      'message': 'Thêm học sinh thành công',
      'id': newId,
    }));
  } catch (e, stack) {
    print('❌ Lỗi khi thêm học sinh: $e\n$stack');
    return Response.internalServerError(
      body: jsonEncode({'message': 'Lỗi server khi thêm học sinh'}),
    );
  }
}


  static Future<Response> getStudent(Request req) async {
    try {
      final collection = MongoService.db.collection('users');
      final students = await collection.find({'role': 'student'}).toList();

      return Response.ok(jsonEncode(students));
    } catch (e, stack) {
      print('❌ Lỗi khi lấy danh sách học sinh: $e\n$stack');
      return Response.internalServerError(
        body: jsonEncode({'message': 'Lỗi server khi lấy danh sách học sinh'}),
      );
    }
  }
}
