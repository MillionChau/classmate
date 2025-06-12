import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../services/mongo_service.dart';
import 'package:uuid/uuid.dart';
import '../controllers/schedule_controller.dart';

class MarkController {
  static final _collection = MongoService.db.collection('marks');

  // Nhập điểm
  static Future<Response> addMark(Request req) async {
    try {
      final payload = jsonDecode(await req.readAsString());

      final studentId = payload['studentId'];
      final classId = payload['classId'];
      final subject = payload['subject'];
      final teacherId = payload['teacherId'];
      final score = (payload['score'] as num).toDouble();

      if ([studentId, classId, subject, teacherId].contains(null)) {
        return Response.badRequest(body: jsonEncode({'message': 'Thiếu dữ liệu'}));
      }

      // Kiểm tra giáo viên có dạy môn đó không
      final scheduleRes = await ScheduleController.getScheduleByTeacher(req, teacherId);
      final scheduleData = jsonDecode(await scheduleRes.readAsString());

      final allSchedules = scheduleData['data'] as List<dynamic>;
      final teachingList = <Map<String, String>>[];

      for (final item in allSchedules) {
        final classId_ = item['classId'];
        final scheduleList = item['schedule'] as List<dynamic>;

        for (final slot in scheduleList) {
          if (slot['teacherId'] == teacherId) {
            teachingList.add({'classId': classId_, 'subject': slot['subject']});
          }
        }
      }

      final canTeach = teachingList.any((e) => e['classId'] == classId && e['subject'] == subject);
      if (!canTeach) {
        return Response.forbidden(jsonEncode({'message': 'Bạn không có quyền nhập điểm cho lớp/môn này'}));
      }

      final mark = {
        'id': const Uuid().v4(),
        'studentId': studentId,
        'classId': classId,
        'subject': subject,
        'teacherId': teacherId,
        'score': score,
        'createdAt': DateTime.now().toIso8601String(),
      };

      await _collection.insertOne(mark);
      return Response.ok(jsonEncode({'message': 'Nhập điểm thành công'}));
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'message': 'Lỗi server', 'error': e.toString()}));
    }
  }

  // Lấy điểm theo học sinh
  static Future<Response> getMarksByStudent(Request req, String studentId) async {
    try {
      final marks = await _collection.find({'studentId': studentId}).toList();
      return Response.ok(jsonEncode(marks));
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'message': 'Lỗi server'}));
    }
  }

  // Lấy danh sách lớp + môn mà giáo viên đang dạy (để nhập điểm)
  static Future<Response> getTeachingSubjects(Request req, String teacherId) async {
    try {
      final scheduleRes = await ScheduleController.getScheduleByTeacher(req, teacherId);
      final scheduleData = jsonDecode(await scheduleRes.readAsString());

      final allSchedules = scheduleData['data'] as List<dynamic>;
      final teachingList = <Map<String, String>>[];

      for (final item in allSchedules) {
        final classId = item['classId'];
        final scheduleList = item['schedule'] as List<dynamic>;

        for (final slot in scheduleList) {
          if (slot['teacherId'] == teacherId) {
            teachingList.add({'classId': classId, 'subject': slot['subject']});
          }
        }
      }

      // Loại bỏ trùng
      final seen = <String>{};
      final unique = teachingList.where((e) {
        final key = '${e['classId']}_${e['subject']}';
        return seen.add(key);
      }).toList();

      return Response.ok(jsonEncode(unique));
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'message': 'Lỗi server', 'error': e.toString()}));
    }
  }

  // GET /mark/student/:studentId/subject/:subject
  static Future<Response> getMarksByStudentAndSubject(Request req, String studentId, String rawSubject) async {
    try {
      final subject = Uri.decodeComponent(rawSubject);

      final marks = await _collection.find({
        'studentId': studentId,
        'subject': subject,
      }).toList();

      return Response.ok(jsonEncode(marks));
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'message': 'Lỗi server', 'error': e.toString()}));
    }
  }
}
