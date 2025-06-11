import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/schedule.dart';

class ScheduleService {
  static final String baseUrl = kIsWeb
  ? 'http://localhost:8080'
  : 'http://10.0.2.2:8080';

  static Future<List<ScheduleItem>> getTeacherSchedule(String teacherId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/schedules/teacher/$teacherId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final schedules = jsonData['data'] as List<dynamic>;
        final List<ScheduleItem> result = [];

        for (var schedule in schedules) {
          final scheduleItems = schedule['schedule'] as List<dynamic>;
          for (var item in scheduleItems) {
            if (item['teacherId'] == teacherId) {
              result.add(ScheduleItem.fromMap({
                ...item,
                'classId': schedule['classId'],
              }));
            }
          }
        }

        return result;
      } else {
        throw Exception('Lỗi khi lấy lịch: ${response.body}');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối: $e');
    }
  }

  // Lấy thời khóa biểu theo classId
  static Future<Map<String, List<Map<String, dynamic>>>> getScheduleByClass(String classId) async {
    final uri = Uri.parse('$baseUrl/schedules/class/$classId');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Không thể tải thời khóa biểu');
    }

    final data = jsonDecode(response.body);

    if (data.isEmpty || data[0]['schedule'] == null) {
      return {};
    }

    final scheduleList = data[0]['schedule'] as List;

    final Map<String, List<Map<String, dynamic>>> grouped = {};

    for (var item in scheduleList) {
      final day = item['day'];
      grouped.putIfAbsent(day, () => []).add(Map<String, dynamic>.from(item));
    }

    for (var day in grouped.keys) {
      grouped[day]!.sort((a, b) => a['slot'].compareTo(b['slot']));
    }

    return grouped;
  }
}