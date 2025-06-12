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
    print('Lỗi khi thêm học sinh: $e\n$stack');
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
      print('Lỗi khi lấy danh sách học sinh: $e\n$stack');
      return Response.internalServerError(
        body: jsonEncode({'message': 'Lỗi server khi lấy danh sách học sinh'}),
      );
    }
  }

  static Future<Response> getStudentCount(Request req) async {
    try {
      final collection = MongoService.db.collection('users');
      final count = await collection.count({'role': 'student'});

      return Response.ok(jsonEncode({'count': count}));
    } catch (e, stack) {
      print('Lỗi khi lấy số lượng học sinh: $e\n$stack');
      return Response.internalServerError(
        body: jsonEncode({'message': 'Lỗi server khi lấy số lượng học sinh'}),
      );
    }
  }

  static Future<Response> updateStudent(Request req, String id) async {
    try {
      final payload = await req.readAsString();
      final data = jsonDecode(payload);

      final name = data['name']?.toString();
      final className = data['className']?.toString();
      final password = data['password']?.toString();

      if (name == null || className == null || password == null) {
        return Response.badRequest(body: jsonEncode({'message': 'Thiếu dữ liệu'}));
      }

      final collection = MongoService.db.collection('users');

      final existingStudent = await collection.findOne({'id': id, 'role': 'student'});

      if (existingStudent == null) {
        return Response.notFound(jsonEncode({'message': 'Không tìm thấy học sinh'}));
      }

      final updateData = <String, dynamic>{};

      if (name.isNotEmpty) updateData['name'] = name;
      if (className.isNotEmpty) updateData['className'] = className;
      if (password.isNotEmpty) updateData['password'] = password;

      await collection.update(
        {'id': id},
        {r'$set': updateData},
      );

      return Response.ok(jsonEncode({'message': 'Cập nhật học sinh thành công'}));
    } catch (e, stack) {
      print('Lỗi khi cập nhật học sinh: $e\n$stack');
      return Response.internalServerError(
        body: jsonEncode({'message': 'Lỗi server khi cập nhật học sinh'}),
      );
    }
  }

  static Future<Response> getStudentsByClass(Request req, String className) async {
    final collection = MongoService.db.collection('users');

    try {
      final decodedClass = Uri.decodeComponent(className);
      final results = await collection.find({
        'role': 'student',
        'className': decodedClass,
      }).toList();

      final students = results.map((doc) => Student.fromMap(doc).toMap()).toList();
      return Response.ok(jsonEncode(students));
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'message': 'Lỗi server', 'error': e.toString()}),
      );
    }
  }
}
