import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../services/mongo_service.dart';

class ScheduleController {
  // Tạo thời khoá biểu cho 1 lớp trong 1 tuần
  static Future<Response> addSchedule(Request req) async {
    try {
      final payload = jsonDecode(await req.readAsString());
      final collection = MongoService.db.collection('schedules');

      final classId = payload['classId'];
      final week = payload['week'];
      final schedule = payload['schedule'];

      if (classId == null || week == null || schedule == null) {
        return Response.badRequest(body: jsonEncode({'message': 'Thiếu dữ liệu'}));
      }

      // Kiểm tra trùng lịch
      final existing = await collection.findOne({'classId': classId, 'week': week});
      if (existing != null) {
        return Response.badRequest(body: jsonEncode({'message': 'Lịch đã tồn tại'}));
      }

      await collection.insert({
        'classId': classId,
        'week': week,
        'schedule': schedule,
      });

      return Response.ok(jsonEncode({'message': 'Tạo thời khoá biểu thành công'}));
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'message': 'Lỗi server'}));
    }
  }

  // Cập nhật TKB theo classId + week
  static Future<Response> updateSchedule(Request req, String classId, String week) async {
    try {
      final payload = jsonDecode(await req.readAsString());
      final collection = MongoService.db.collection('schedules');

      final updated = await collection.update(
        {'classId': classId, 'week': week},
        {r'$set': {'schedule': payload['schedule']}},
      );

      if (updated['nModified'] == 0) {
        return Response.notFound(jsonEncode({'message': 'Không tìm thấy lịch'}));
      }

      return Response.ok(jsonEncode({'message': 'Cập nhật lịch thành công'}));
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'message': 'Lỗi server'}));
    }
  }

  // Xoá TKB theo lớp và tuần
  static Future<Response> deleteSchedule(String classId, String week) async {
  // Validate input
  if (classId.isEmpty || week.isEmpty) {
    return Response.badRequest(
      body: jsonEncode({'error': 'classId và week không được để trống'}),
    );
  }

  try {
    final collection = MongoService.db.collection('schedules');

    // First check if document exists
    final existingDoc = await collection.findOne({
      'classId': classId,
      'week': week
    });

    if (existingDoc == null) {
      return Response.notFound(
        jsonEncode({
          'error': 'Không tìm thấy thời khóa biểu',
          'details': {'classId': classId, 'week': week}
        }),
      );
    }

    // Perform deletion
    final writeResult = await collection.deleteOne({
      'classId': classId,
      'week': week
    });

    // Verify deletion was successful
    if (!writeResult.isSuccess) {
      return Response.internalServerError(
        body: jsonEncode({
          'error': 'Lỗi khi xóa dữ liệu',
          'serverError': writeResult.errmsg ?? 'Unknown error'
        }),
      );
    }

    return Response.ok(
      jsonEncode({
        'success': true,
        'message': 'Đã xóa thời khóa biểu thành công',
        'deletedCount': 1
      }),
    );

  } catch (e, stackTrace) {
    print('Error deleting schedule: $e');
    print('Stack trace: $stackTrace');
    
    return Response.internalServerError(
      body: jsonEncode({
        'error': 'Lỗi hệ thống',
        'message': e.toString()
      }),
    );
  }
}


  // Lấy lịch theo lớp
  static Future<Response> getScheduleByClass(Request req, String classId) async {
    try {
      final collection = MongoService.db.collection('schedules');
      final schedules = await collection.find({'classId': classId}).toList();

      return Response.ok(jsonEncode(schedules));
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'message': 'Lỗi server'}));
    }
  }


  // Lấy lịch theo lớp + tuần
  static Future<Response> getScheduleByClassAndWeek(String classId, String week) async {
    try {
      final collection = MongoService.db.collection('schedules');
      final schedule = await collection.findOne({'classId': classId, 'week': week});

      if (schedule == null) {
        return Response.notFound(jsonEncode({'message': 'Không tìm thấy lịch'}));
      }

      return Response.ok(jsonEncode(schedule));
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'message': 'Lỗi server'}));
    }
  }

  // Giáo viên xem tất cả các tiết dạy của mình
  static Future<Response> getScheduleByTeacher(Request req, String teacherId) async {
    if (teacherId.isEmpty) {
      return Response.badRequest(body: jsonEncode({'error': 'teacherId không được để trống'}));
    }

    try {
      final collection = MongoService.db.collection('schedules');

      final schedules = await collection.find({
        'schedule': {
          r'$elemMatch': {'teacherId': teacherId}
        }
      }).toList();

      if (schedules.isEmpty) {
        return Response.ok(jsonEncode({
          'message': 'Không tìm thấy lịch giảng dạy cho giáo viên',
          'data': []
        }));
      }

      return Response.ok(jsonEncode({
        'message': 'Lấy lịch giảng dạy thành công',
        'data': schedules
      }));
    } catch (e, stackTrace) {
      print('Error fetching teacher schedule: $e');
      print('Stack trace: $stackTrace');
      return Response.internalServerError(body: jsonEncode({
        'error': 'Lỗi hệ thống',
        'message': e.toString()
      }));
    }
  }

  static Future<Response> getAllSchedules(Request req) async {
    try {
      final collection = MongoService.db.collection('schedules');
      final allSchedules = await collection.find().toList();

      return Response.ok(jsonEncode({
        'message': 'Lấy tất cả thời khóa biểu thành công',
        'data': allSchedules,
      }));
    } catch (e, stackTrace) {
      print('Error fetching all schedules: $e');
      print('Stack trace: $stackTrace');
      return Response.internalServerError(
        body: jsonEncode({'error': 'Lỗi hệ thống', 'message': e.toString()}),
      );
    }
  }
}
