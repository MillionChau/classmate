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
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => ScheduleItem.fromMap(item)).toList();
      } else {
        throw Exception('Failed to load schedule');
      }
    } catch (e) {
      throw Exception('Error fetching schedule: $e');
    }
  }
}